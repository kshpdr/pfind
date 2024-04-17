#!/bin/sh

# generate new file name for this run
filename="git-$(date +%Y%m%d%H%M%S).csv"
touch $filename
echo "Writing to $filename"
echo "directory,keyword,find real time,find user time,find sys time,pfind real time,pfind user time,pfind sys time" > $filename

echo -n ".,test," >> $filename
\time -f '%e,%U,%S,' -a -o $filename find . -name "test" > /dev/null 2>&1
truncate -s-1 $filename
\time -f '%e,%U,%S,' -a -o $filename /home/ryan/spring24/cse6230/project/pfind/src/pfind . "test" > /dev/null 2>&1


echo -n ".,README.md," >> $filename
\time -f '%e,%U,%S,' -a -o $filename find . -name "README.md" > /dev/null 2>&1
truncate -s-1 $filename
\time -f '%e,%U,%S,' -a -o $filename /home/ryan/spring24/cse6230/project/pfind/src/pfind . "README.md" > /dev/null 2>&1

echo -n ".,util," >> $filename
\time -f '%e,%U,%S,' -a -o $filename find . -name "util" > /dev/null 2>&1
truncate -s-1 $filename
\time -f '%e,%U,%S,' -a -o $filename /home/ryan/spring24/cse6230/project/pfind/src/pfind . "util" > /dev/null 2>&1

echo -n ".,src," >> $filename
\time -f '%e,%U,%S,' -a -o $filename find . -name "src" > /dev/null 2>&1
truncate -s-1 $filename
\time -f '%e,%U,%S,' -a -o $filename /home/ryan/spring24/cse6230/project/pfind/src/pfind . "src" > /dev/null 2>&1
