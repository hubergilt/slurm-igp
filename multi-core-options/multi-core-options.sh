#!/bin/bash
module load gnu/4.8.5
module load gnu_ompi/1.10.6
mpicc mpi-app.c
srun -N2 -B 2-2:4-4:1-1 a.out
