RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
CLEAR='\033[0m'


# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script#comment9536277_246128
PSScriptRoot="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dirname=$(basename "$PSScriptRoot")
input_path=$(realpath "$PSScriptRoot/$dirname.cpp")
output_path=$(realpath "$PSScriptRoot/$dirname.exe")


g++ $input_path -o $output_path
if [ $? != 0 ]; then
    echo -e "${RED}Fix your shit! Exit code: $?${CLEAR}"
    exit $?
fi
echo -e "${GREEN}Built with $?${CLEAR}"


# 1 exit code
echo -e "${YELLOW}TESTING EXIT CODE 1${CLEAR}"
declare -a cmds=(
    "$output_path -h"
)
for cmd in "${cmds[@]}" 
do
    echo ""
    echo -e "${CYAN}$cmd${CLEAR}"
    eval $cmd
    if [ $? != 1 ]; then
        echo -e "${YELLOW}$cmd; exit $?, expected == 1${CLEAR}"
        exit $?
    fi
done


# 0 exit code
echo -e "${YELLOW}TESTING EXIT CODE 0${CLEAR}"
declare -a cmds=(
    "$output_path 0 helo"
    "$output_path 1 helo"
    "$output_path 2 helo"
    "$output_path 3 helo"
    "$output_path 4 helo"
    "$output_path 5 helo"
)
for cmd in "${cmds[@]}" 
do
    echo ""
    echo -e "${CYAN}$cmd${CLEAR}"
    eval $cmd
    if [ $? != 0 ]; then
        echo -e "${YELLOW}$cmd; exit $?, expected == 0${CLEAR}"
        exit $?
    fi
done


# >1 exit code
echo -e "${YELLOW}TESTING EXIT CODE >1${CLEAR}"
declare -a cmds=(
    "$output_path -1 helo"
    "$output_path helo world"
)
for cmd in "${cmds[@]}" 
do
    echo ""
    echo -e "${CYAN}$cmd${CLEAR}"
    eval $cmd
    if [ $? <= 1 ]; then
        echo -e "${YELLOW}$cmd; exit $?, expected == >1${CLEAR}"
        exit $?
    fi
done
