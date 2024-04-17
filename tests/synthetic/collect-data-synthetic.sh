#!/bin/sh

# generate new file name for this run
filename="synthetic-$(date +%Y%m%d%H%M%S).csv"
touch $filename
echo "Writing to $filename"
echo "directory,keyword,find real time,find user time,find sys time,pfind real time,pfind user time,pfind sys time" > $filename

echo -n "test1,file0," >> $filename
\time -f '%e,%U,%S,' -a -o $filename find test1 -name "file0" > /dev/null 2>&1
truncate -s-1 $filename
\time -f '%e,%U,%S,' -a -o $filename /home/ryan/spring24/cse6230/project/pfind/src/pfind test1 "file0" > /dev/null 2>&1


echo -n "test1,file1," >> $filename
\time -f '%e,%U,%S,' -a -o $filename find test1 -name "file1" > /dev/null 2>&1
truncate -s-1 $filename
\time -f '%e,%U,%S,' -a -o $filename /home/ryan/spring24/cse6230/project/pfind/src/pfind test1 "file1" > /dev/null 2>&1


echo -n "test1,file5," >> $filename
\time -f '%e,%U,%S,' -a -o $filename find test1 -name "file5" > /dev/null 2>&1
truncate -s-1 $filename
\time -f '%e,%U,%S,' -a -o $filename /home/ryan/spring24/cse6230/project/pfind/src/pfind test1 "file5" > /dev/null 2>&1



echo -n "test2,file3," >> $filename
\time -f '%e,%U,%S,' -a -o $filename find test2 -name "file3" > /dev/null 2>&1
truncate -s-1 $filename
\time -f '%e,%U,%S,' -a -o $filename /home/ryan/spring24/cse6230/project/pfind/src/pfind test2 "file3" > /dev/null 2>&1


echo -n ".,file4," >> $filename
\time -f '%e,%U,%S,' -a -o $filename find . -name "file4" > /dev/null 2>&1
truncate -s-1 $filename
\time -f '%e,%U,%S,' -a -o $filename /home/ryan/spring24/cse6230/project/pfind/src/pfind . "file4" > /dev/null 2>&1
