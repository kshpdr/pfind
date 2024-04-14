# pfind

To do:

- [ ] Benchmark naive ```find```, MPI version ```find```, and ```find``` with GNUParallel
- [ ] Prepare a testing benchmark (baseline with normal ```find```)
- [ ] Implement an optimized non-parallel ```pfind```


## Usage:

Create ```build``` directory:
```
mkdir build
cd build
```

Allocate a machine:
```
salloc -N1 -c8 --ntasks-per-node=1 -t1:00:00
```

Load cmake module and set number of threads:
```
module load cmake
export OMP_NUM_THREADS=8
```

Configure and build:
```
cmake ..
make
```

