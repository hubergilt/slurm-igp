# Examples of SLURM scripts at IGP's cluster

The SLURM is an open source project which is used to administrate and schedule the system resources for a Linux cluster environment. 

Please, check [SLURM Workload Manager](https://slurm.schedmd.com/ "SLURM Official Webpage")
 
The following scripts are based on the examples from the official SLURM documentation (specifically from the examples from the srun command documentation) and the aim of this
 work is to adapt those examples in order to work properly for IGP's cluster.

## Simple job script example
This basic example allocates and executes eigth tasks with the "-n8" option and shows the name of the host (the compute node) on each task with the hostname command. Additionally the "-l" option is useful to show the label which refers to the remote task id.
```
>cat simple-job.sh
srun -n8 -l hostname
>sh simple-job.sh
0: n1
3: n1
5: n1
4: n1
7: n1
6: n1
2: n1
1: n1
```

## Job step relative example
This example allocates two nodes with the options "-N2" and executes two tasks and it started at the relative index 2 with the option "-r2" (note that the relative index starts at 0).
Additionally the second srun command executes two tasks and it starts at 0 relative index.
```
>test.sh 
#!/bin/bash
echo $SLURM_JOB_NODELIST
srun -lN2 -r2 hostname
srun -lN2 hostname
```
This basic example allocates 4 nodes with the option "-N4" and executes the test.sh script.
```
>cat job-step-relative.sh
salloc -N4 bash  test.sh
```
The following command executes the job-step-relative.sh script.
```
>sh job-step-relative.sh 
salloc: Granted job allocation 15760
n[1-4]
srun: Job step creation temporarily disabled, retrying
srun: Job step created
1: n4
0: n3
0: n1
1: n2
salloc: Relinquishing job allocation 15760
```

## Job step parallel example
This example allocates two nodes with the options "-N2" and executes 4 tasks and it started at the relative index 2 with the option "-r2" (note that the relative index starts at 0).
Additionally the second srun command executes two tasks and it starts at 0 relative index.
```
>test.sh 
#!/bin/bash
echo $SLURM_JOB_NODELIST
srun -lN2 -n4 -r2 sleep 60 &
srun -lN2 -n2 -r0 sleep 60 &
sleep 1
squeue
squeue -s
wait
```
This basic example allocates 4 nodes with the option "-N4" and executes the test.sh script.
```
>cat job-step-parallel.sh
salloc -N4 --ntasks-per-node=2 bash test.sh
```
The following command executes the job-step-parallel.sh script.
```
>sh job-step-parallel.sh 
salloc: Granted job allocation 15769
n[1-4]

JOBID    PARTITION     NAME     USER  ST       TIME  NODES  CPUS  NODELIST(REASON)
15769        debug     bash    hgilt  CF       0:01      4     8  n[1-4]

STEPID     NAME PARTITION     USER      TIME NODELIST

srun: Job step creation temporarily disabled, retrying
srun: Job step creation temporarily disabled, retrying

srun: Job step created
srun: Job step created

salloc: Relinquishing job allocation 15769
```

- complex-job
- different-jobs-exec
- job-step-dedicated
- job-step-parallel
- multi-core-options
- multiple-program
- simple-mpi-job

For more details about the explanation of this examples, please check the following link:
[srun documentation](https://slurm.schedmd.com/srun.html "srun command")
