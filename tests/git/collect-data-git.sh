#!/bin/bash

export PATH=$PATH:../
export PATH=$PATH:$(pwd)/../../src/

if ! which hyperfine > /dev/null 2>&1; then
    echo "'hyperfine' does not seem to be installed."
    echo "You can get it here: https://github.com/sharkdp/hyperfine"
    exit 1
fi

# generate new file name for this run
export folder="git-hyperfine-$(date +%Y%m%d%H%M%S)-results"
mkdir -p $folder
echo "Results in $folder"

# order is find, fdfind, b_pfind, pfind

run_hyperfine_tests() {
    export filenamecsv="$folder/results-$directory-$keyword.csv"
    export filenamejson="$folder/results-$directory-$keyword.json"
    touch $filenamecsv
    touch $filenamejson
    hyperfine --sort command -u microsecond -N --export-json "$filenamejson" \
    --export-csv "$filenamecsv" -r 50 -w 3 \
        "find $directory -name $keyword  " \
        "fdfind -uu --glob $keyword $directory  " \
        "b_pfind $directory $keyword  " \
        "pfind $directory $keyword  " 
        # "/home/ryan/spring24/cse6230/project/pfind/src/pfind_rec $directory $keyword  "
}

export directory="."
export keyword="src"
run_hyperfine_tests

export directory="."
export keyword="README.md"
run_hyperfine_tests