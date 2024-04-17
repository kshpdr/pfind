#!/bin/sh

# remove existing test directories
echo "Removing previous synthetic test directories"
rm -r test1 test2

# create a lot of empty directories
# loop from 0 to 99
# two deep
max=19
for i in $(seq 0 $max); do
    for j in $(seq 0 $max); do
        mkdir -p "test1/dir$i/dir$j" &
    done
done
wait
for i in $(seq 0 $max); do
    for j in $(seq 0 $max); do
        # mkdir -p "test1/dir$i/dir$j"
        for k in $(seq 0 $max); do
            touch "test1/dir$i/dir$j/file$k" &
        done
    done
done

max=4
for i in $(seq 0 $max); do
    for j in $(seq 0 $max); do
        for k in $(seq 0 $max); do
            for l in $(seq 0 $max); do
                for m in $(seq 0 $max); do
                    mkdir -p "test2/dir$i/dir$j/dir$k/dir$l/dir$m" &
                done
            done
        done
    done
done
wait
for i in $(seq 0 $max); do
    for j in $(seq 0 $max); do
        for k in $(seq 0 $max); do
            for l in $(seq 0 $max); do
                for m in $(seq 0 $max); do
                    # mkdir -p "test2/dir$i/dir$j/dir$k/dir$l/dir$m"
                    for n in $(seq 0 $max); do
                        touch "test2/dir$i/dir$j/dir$k/dir$l/dir$m/file$n" &
                    done
                done
            done
        done
    done
done
wait

# todo: create some files with really long names maybe