# pfind

To do:

- [x] Implement an optimized non-parallel ```pfind```
- [ ] Benchmark naive ```find```, MPI version ```find```, and ```find``` with GNUParallel
- [ ] Prepare a testing benchmark (baseline with normal ```find```)


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
