#!/bin/bash
SCRIPT=$(basename "${BASH_SOURCE[0]}")
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function usage {
    echo -e "Tool for automating network connection testing"
    echo -e " usage: $SCRIPT [-h] -f file"
    echo -e ""
    echo -e "       -f                      file to be read"
    echo -e "       -h                      show this help and exit"
    echo -e ""
    echo -e " examples:"
    echo -e "   $SCRIPT -f file" 
    echo -e ""
    echo -e "example file:"
    echo -e ""
    echo -e "192.168.0.1 443"
    echo -e "192.168.0.2 22"
    echo -e "192.168.0.3 80"
    exit 1
}

OPTSTRING="hf:"
while getopts ${OPTSTRING} OPT; do
    case $OPT in
    f | file)
      FILE=${OPTARG}
      ;;
    h | ? | *)
      usage
      ;;
esac
done
    
if [ $OPTIND == 1 ]; then
    usage >&2
fi

if [ ! -f $FILE ]; then
    echo "File: ${FILE} - does not exist"
    exit 1
fi 

while IFS= read -r line || [ -n "$line" ]; do
    l_TELNET=`echo "quit" | telnet $line 2>&1 | grep "Escape character is"` 
    if [ "$?" -ne 0 ]; then
        echo -e "${RED}[FAILURE]${NC} Connection to: ${line}"
    else
        echo -e "${GREEN}[SUCCESS]${NC} Connection to: ${line}"
    fi
done <  "$FILE"

exit 0
