#!/bin/bash
#SBATCH --job-name=mpi_intel
#SBATCH --partition=any2
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --ntasks=24
module purge
module load intel/16.0.3
module load intel_ompi/1.10.6
srun -n 3  mpi_hello_world.exe "Step-id 0"
srun -n 5  mpi_hello_world.exe "Step-id 1"
srun -n 8  mpi_hello_world.exe "Step-id 2"
