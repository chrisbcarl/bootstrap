#!/usr/bin/env bash

# https://stackoverflow.com/a/246128
# SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# must be BASH_SOURCE[0] due to invoked either as executable or via source or .
SCRIPT_FILEPATH=$(realpath ${BASH_SOURCE[0]})
SCRIPT_DIRPATH=$(dirname ${BASH_SOURCE[0]})
echo "basename: [$(basename "$SCRIPT_FILEPATH")]"
echo "dirname : [$(dirname "$SCRIPT_FILEPATH")]"
echo "pwd     : [$(pwd)]"
