#!/bin/bash
#SBATCH --job-name=hw_matlab
#SBATCH --partition=matlab
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --ntasks=3

module purge
module load matlab/R2016b

srun -n 1 matlab -nodisplay -r "hello_world('Step-id 0'),exit" 
srun -n 2 matlab -nodisplay -r "hello_world('Step-id 1'),exit"
srun -n 3 matlab -nodisplay -r "hello_world('Step-id 2'),exit"
