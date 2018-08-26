#!/bin/sh
MACHINEFILE="nodes.$SLURM_JOB_ID"

# Generate Machinefile for mpi such that hosts are in the same
#  order as if run via srun
#
srun -l /bin/hostname | sort -n | awk '{print $2}' > $MACHINEFILE

# Run using generated Machine file:
mpirun -np $SLURM_NTASKS -machinefile $MACHINEFILE mpi-app

rm $MACHINEFILE
