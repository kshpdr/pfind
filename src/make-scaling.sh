#!/bin/sh
# create versions of one of the executables with different thread limits
g++ -fopenmp -O3 -DFIXED_NUM_THREADS=1 boost_parallel_find.cpp -lboost_system -lboost_thread -o b_pfind_1
g++ -fopenmp -O3 -DFIXED_NUM_THREADS=2 boost_parallel_find.cpp -lboost_system -lboost_thread -o b_pfind_2
g++ -fopenmp -O3 -DFIXED_NUM_THREADS=4 boost_parallel_find.cpp -lboost_system -lboost_thread -o b_pfind_4
g++ -fopenmp -O3 -DFIXED_NUM_THREADS=8 boost_parallel_find.cpp -lboost_system -lboost_thread -o b_pfind_8
g++ -fopenmp -O3 -DFIXED_NUM_THREADS=16 boost_parallel_find.cpp -lboost_system -lboost_thread -o b_pfind_16
g++ -fopenmp -O3 -DFIXED_NUM_THREADS=32 boost_parallel_find.cpp -lboost_system -lboost_thread -o b_pfind_32
g++ -fopenmp -O3 -DFIXED_NUM_THREADS=64 boost_parallel_find.cpp -lboost_system -lboost_thread -o b_pfind_64