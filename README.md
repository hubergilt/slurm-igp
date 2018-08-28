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
This basic example allocates 4 nodes with the option "-N4" and configure 2 tasks per node with the option "--ntasks-per-node" (otherwise the default is one task per node) and executes the test.sh script.
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

## Simple MPI job example
The following example shows a simple MPI program called "mpirun" that receives the number of process option "-np" with an environment variable called "$SLURM_NTASKS" as a parameter. In addition, the srun command finds the available nodes and saves it on the file name called "MACHINEFILE". Then this file is deleted at the last step.
```
>test.sh 
#!/bin/sh
MACHINEFILE="nodes.$SLURM_JOB_ID"

# Generate Machinefile for mpi such that hosts are in the same
#  order as if run via srun
#
srun -l /bin/hostname | sort -n | awk '{print $2}' > $MACHINEFILE

# Run using generated Machine file:
mpirun -np $SLURM_NTASKS -machinefile $MACHINEFILE mpi-app

rm $MACHINEFILE
```
The following script builds an application with the gcc compiler and then executes the salloc command which allocates 2 nodes with the option "-N2" and four tasks with the option "-n4" (the default assignement is three tasks in the first node and the last task in the second node) and finally executes the test.sh script.
```
>cat simple-mpi-job.sh
#!/bin/bash
module load gnu/4.8.5
module load gnu_ompi/1.10.6
mpicc mpi-app.c -o mpi-app
salloc -N2 -n4 bash test.sh
```
The following command is used to begin with the simple-mpi-job.sh script example.
```
>sh simple-mpi-job.sh
salloc: Pending job allocation 15787
salloc: job 15787 queued and waiting for resources
salloc: job 15787 has been allocated resources
salloc: Granted job allocation 15787
Hello world from processor  n2, rank  3 out of 4 processors
Hello world from processor  n1, rank  1 out of 4 processors
Hello world from processor  n1, rank  2 out of 4 processors
Hello world from processor  n1, rank  0 out of 4 processors
salloc: Relinquishing job allocation 15787
```

## Different job execution example
The following script illustres an alternative method to execute a job with two different chunk of code. Which depends of the relative node id to execute one of them. In addition, the environment variable called "$SLURM_NODEID" saves the node id.
```
>test.sh 
#!/bin/sh
case $SLURM_NODEID in
     0) echo "I am running on "
        hostname ;;
     1) hostname
        echo "is where I am running" ;;
esac
```
The following script allocates two nodes with the option "-N2" (specifically the nodes n1 and n2 with the option "-wn[1,2]") and then immediately executes the test.sh script.
```
>cat different-jobs-exec.sh
srun -N2 -wn[1,2] bash test.sh
```
The command bellow starts the "different-jobs-exec.sh" script and then, the result is showed.
```
>sh different-jobs-exec.sh 
I am running on 
n2
n1
is where I am running
```

- complex-job
- different-jobs-exec
- job-step-dedicated
- multi-core-options
- multiple-program

For more details about the explanation of this examples, please check the following link:
[srun documentation](https://slurm.schedmd.com/srun.html "srun command")
