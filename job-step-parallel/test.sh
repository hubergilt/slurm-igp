#!/bin/bash
echo $SLURM_JOB_NODELIST
srun -lN2 -n4 -r2 sleep 60 &
srun -lN2 -n2 -r0 sleep 60 &
sleep 1
squeue
squeue -s
wait
