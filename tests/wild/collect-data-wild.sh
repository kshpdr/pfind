#!/bin/bash

export PATH=$PATH:$(pwd)/../
export PATH=$PATH:$(pwd)/../../src/

if ! which hyperfine > /dev/null 2>&1; then
    echo "'hyperfine' does not seem to be installed."
    echo "You can get it here: https://github.com/sharkdp/hyperfine"
    exit 1
fi

# generate new file name for this run
export folder="wild-hyperfine-$(date +%Y%m%d%H%M%S)-results"
mkdir -p $folder
echo "Results in $folder"

# order is find, fdfind, b_pfind, pfind, pfind_rec

test_ryan_func() {
    export filenamecsv="$folder/results-usr-$keyword.csv"
    export filenamejson="$folder/results-usr-$keyword.json"
    touch $filenamecsv
    touch $filenamejson
    hyperfine --sort command -u microsecond -N --export-json "$filenamejson" \
    --export-csv "$filenamecsv" --ignore-failure -r 50 -w 3 \
        "find $directory -name '$keyword' " \
        "fdfind -uu --glob $keyword $directory  " \
        "b_pfind $directory $keyword  " \
        "pfind $directory $keyword  " 
        # "/home/ryan/spring24/cse6230/project/pfind/src/pfind_rec $directory $keyword  "
}

export directory="/usr"
export keyword="test"
test_ryan_func

export directory="/usr"
export keyword="README.md"
test_ryan_func

export directory="/usr"
export keyword="README"
test_ryan_func

export directory="/usr"
export keyword="LICENSE"
test_ryan_func

export directory="/usr"
export keyword="COPYRIGHT"
test_ryan_func

export directory="/usr"
export keyword="include"
test_ryan_func