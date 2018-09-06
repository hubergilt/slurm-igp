#!/bin/bash
module load intel/16.0.3
module load intel_ompi/1.10.6
mpicc mpi_hello_world.c -o mpi_hello_world.exe 
sbatch mpi_job.sh
