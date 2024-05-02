#!/bin/bash

# generate new file name for this run
export filename="synthetic-$(date +%Y%m%d%H%M%S).csv"
touch $filename
echo "Writing to $filename"
echo "directory,keyword,find real time,find user time,find sys time,fdfind real time,fdfind user time,fdfind sys time,b_pfind real time,b_pfind user time,b_pfind sys time,pfind real time,pfind user time,pfind sys time,pfind_rec real time,pfind_rec user time,pfind_rec sys time" > $filename

export TIMEFORMAT=%R,%U,%S,

# order is find, fdfind, b_pfind, pfind, pfind_rec

test_ryan_func() {
    echo -n "$directory,$keyword," >> $filename
    { time find "$directory" -name "$keyword" > /dev/null 2>&1 ; } 2>> $filename
    truncate -s-1 $filename
    { time fdfind "$keyword" "$directory" > /dev/null 2>&1 ; } 2>> $filename
    truncate -s-1 $filename
    { time /home/ryan/spring24/cse6230/project/pfind/src/b_pfind "$directory" "$keyword" > /dev/null 2>&1 ; } 2>> $filename
    truncate -s-1 $filename
    { time /home/ryan/spring24/cse6230/project/pfind/src/pfind "$directory" "$keyword" > /dev/null 2>&1 ; } 2>> $filename
    truncate -s-1 $filename
    { time /home/ryan/spring24/cse6230/project/pfind/src/pfind_rec "$directory" "$keyword" > /dev/null 2>&1 ; } 2>> $filename
}

export directory="test1"
export keyword="file0"
test_ryan_func

export directory="test1"
export keyword="file1"
test_ryan_func

export directory="test1"
export keyword="file5"
test_ryan_func

export directory="test2"
export keyword="file3"
test_ryan_func

export directory="."
export keyword="file4"
test_ryan_func