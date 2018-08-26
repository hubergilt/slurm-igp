#!/bin/bash
module load gnu/4.8.5
module load gnu_ompi/1.10.6
mpicc mpi-app.c -o mpi-app
salloc -N2 -n4 bash test.sh
