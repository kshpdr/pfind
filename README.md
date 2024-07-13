# pfind

The Linux `find` command does not currently support multithreading or any form of parallelism, which can be problematic in larger codebases. We propose a modified version called `pfind` that introduces multithreading using OpenMP. We benchmark it against actual find on multiple datasets. Results and our approach can be found in the [paper](https://github.com/kshpdr/pfind/blob/main/paper.pdf). Additionally, we upload a [presentation](https://github.com/kshpdr/pfind/blob/main/presentation.pdf) with better visualization of what happens under the hood.


## Usage:

Allocate a machine:
```
salloc -N1 -c8 --ntasks-per-node=1 -t1:00:00
```

Set number of threads:
```
export OMP_NUM_THREADS=8
```

Go to the src/ directory and compile:
```
./make.sh
```

After this you get two binaries `./pfind` and `./pfind_rec`
