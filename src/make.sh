#!/bin/sh
g++ -fopenmp -O3 parallel_find.cpp -o pfind
g++ -fopenmp -O3 parallel_find_rec.cpp -o pfind_rec
g++ -O3 serial_find.cpp -o serial_find
g++ -fopenmp -O3 boost_parallel_find.cpp -lboost_system -lboost_thread -o b_pfind