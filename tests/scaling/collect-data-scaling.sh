#!/bin/bash

export PATH=$PATH:$(pwd)/../
export PATH=$PATH:$(pwd)/../../src/

if ! which hyperfine > /dev/null 2>&1; then
    echo "'hyperfine' does not seem to be installed."
    echo "You can get it here: https://github.com/sharkdp/hyperfine"
    exit 1
fi

# generate new file name for this run
export folder="scaling-hyperfine-$(date +%Y%m%d%H%M%S)-results"
mkdir -p $folder
echo "Results in $folder"

run_hyperfine_tests() {
    export filenamecsv="$folder/results-scaling-$keyword.csv"
    export filenamejson="$folder/results-scaling-$keyword.json"
    touch $filenamecsv
    touch $filenamejson
    hyperfine --sort command -u microsecond -N --export-json "$filenamejson" \
    --export-csv "$filenamecsv" --ignore-failure -r 25 -w 3 -L threads 1,2,4,8,16,32,64 \
        "b_pfind_{threads} $directory $keyword "
        # "/home/ryan/spring24/cse6230/project/pfind/src/pfind_rec $directory $keyword  "
}

export directory="/usr"
export keyword="LICENSE"
run_hyperfine_tests

export directory="../git"
export keyword="README.md"
run_hyperfine_tests