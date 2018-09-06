#!/bin/bash
module load gnu/4.8.5
module load gnu_ompi/1.10.6
mpicc mpi_hello_world.c -o mpi_hello_world.exe 
sbatch mpi_job.sh
