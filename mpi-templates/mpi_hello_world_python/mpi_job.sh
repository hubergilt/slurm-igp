#!/bin/bash
#SBATCH --job-name=mpi_python
#SBATCH --partition=any2
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --ntasks=24
srun -n 3  python mpi_hello_world.py "Step-id 0" &
srun -n 5  python mpi_hello_world.py "Step-id 1" &
srun -n 8  python mpi_hello_world.py "Step-id 2" &
wait
