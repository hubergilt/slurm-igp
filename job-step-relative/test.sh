#!/bin/bash
echo $SLURM_JOB_NODELIST
srun -lN2 -r2 hostname
srun -lN2 hostname
