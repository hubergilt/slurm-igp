# Examples of SLURM scripts at IGP's cluster

The SLURM is an open source project which is used to administrate and schedule the system resources for a Linux cluster environment. 

Please, check [SLURM Workload Manager](https://slurm.schedmd.com/ "SLURM Official Webpage")
 
The following scripts are based on the examples from the official SLURM documentation (specifically from the examples from the srun command documentation) and the aim of this
 work is to adapt those examples in order to work properly for IGP's cluster.

## Simple job script example
This basic example allocates and executes eigth tasks with the "-n8" option and shows the name of the host (the compute node) on each task with the hostname command. Additionally the "-l" option is useful to show the label which refers to the remote task id.
```
> cat simple-job.sh
srun -n8 -l hostname
> sh simple-job.sh
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
> cat test.sh 
#!/bin/bash
echo $SLURM_JOB_NODELIST
srun -lN2 -r2 hostname
srun -lN2 hostname
```
This basic example allocates 4 nodes with the option "-N4" and executes the test.sh script.
```
> cat job-step-relative.sh
salloc -N4 bash  test.sh
```
The following command executes the job-step-relative.sh script.
```
> sh job-step-relative.sh 
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
> test.sh 
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
> cat job-step-parallel.sh
salloc -N4 --ntasks-per-node=2 bash test.sh
```
The following command executes the job-step-parallel.sh script.
```
> sh job-step-parallel.sh 
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
> test.sh 
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
> cat simple-mpi-job.sh
#!/bin/bash
module load gnu/4.8.5
module load gnu_ompi/1.10.6
mpicc mpi-app.c -o mpi-app
salloc -N2 -n4 bash test.sh
```
The following command is used to begin with the simple-mpi-job.sh script example.
```
> sh simple-mpi-job.sh
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
> test.sh 
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
> cat different-jobs-exec.sh
srun -N2 -wn[1,2] bash test.sh
```
The command bellow starts the "different-jobs-exec.sh" script and then, the result is showed.
```
> sh different-jobs-exec.sh 
I am running on 
n2
n1
is where I am running
```
## Multi-core option example
The following script allocates two nodes with the option "-N2" with these resources: two sockets per node, four cores per socket and one thead for core with the option "-B 2-2:4-4:1-1".
```
> cat multi-core-options.sh 
#!/bin/bash
module load gnu/4.8.5
module load gnu_ompi/1.10.6
mpicc mpi-app.c
srun -N2 -B 2-2:4-4:1-1 a.out
```
The command bellow starts the "multi-core-options.sh" script and then, the result is showed.
```
> sh multi-core-options.sh 
Hello world from processor  n2, rank 15 out of 16 processors
Hello world from processor  n1, rank  0 out of 16 processors
Hello world from processor  n1, rank  1 out of 16 processors
Hello world from processor  n1, rank  2 out of 16 processors
Hello world from processor  n1, rank  3 out of 16 processors
Hello world from processor  n1, rank  4 out of 16 processors
Hello world from processor  n1, rank  5 out of 16 processors
Hello world from processor  n1, rank  6 out of 16 processors
Hello world from processor  n1, rank  7 out of 16 processors
Hello world from processor  n1, rank  8 out of 16 processors
Hello world from processor  n1, rank  9 out of 16 processors
Hello world from processor  n1, rank 10 out of 16 processors
Hello world from processor  n1, rank 11 out of 16 processors
Hello world from processor  n1, rank 12 out of 16 processors
Hello world from processor  n1, rank 13 out of 16 processors
Hello world from processor  n1, rank 14 out of 16 processors
```
## Job step dedicated example
The following script allocates four tasks and immediately executes the program "prog1" in exclusive or dedicated mode which means that only one program can execute per time on its respectively nodes. For instance, the first srun command isolate node n1 only for "prog1", then the second srun command isolate node n2 only for "prog2", and so on.
In addition, the last command "wait" is important because without it the program finished and killed the four subprocess of the srun command.
```
> cat my.script 
#!/bin/bash
srun -l --exclusive -n4 prog1 &
srun -l --exclusive -n3 prog2 &
srun -l --exclusive -n1 prog3 &
srun -l --exclusive -n1 prog4 &
wait
```
The following script compiles the programs and execute the previous "my.script" script.
```
> cat job-step-dedicated.sh 
#!/bin/bash
gcc prog1.c -o prog1
gcc prog2.c -o prog2
gcc prog3.c -o prog3
gcc prog4.c -o prog4
sh my.script
```
The command bellow starts the "job-step-dedicated.sh" script and then, the result is showed.
```
> sh job-step-dedicated.sh 
0: From prog4 : Hello, World!
2: From prog2 : HELLO
0: From prog2 : HELLO
1: From prog2 : HELLO
2: From prog1 : n4
1: From prog1 : n4
0: From prog1 : n4
3: From prog1 : n4
0: From prog3 : HELLO
```

## Complex job example
This feature is available from slurm's version upper than 17.11, but the script bellow adapt this functionality with two instances of the srun command. In addition this script build the sources of master.c and slave.c programs.
```
cat complex-job.sh 
gcc master.c -o master
gcc slave.c -o slave
# the original syntax is valid only since slurm version 17.11
# srun -n1 -c16 --mem-per-cpu=1gb master : -n16 --mem-per-cpu=1gb slave
srun -n1 -c16 --mem-per-cpu=1gb master
srun -n16 --mem-per-cpu=1gb slave
```
The command bellow starts the "complex-job.sh" script and then, the result is showed.
```
> sh complex-job.sh 
From master : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
From slave : HELLO
```

## Multiple program example
This method is the easiest way in order to parallel some none-parallel program, the script bellow describes various programs into a config file. For instance, the silly.conf file describes three types of programs (hostname, echo task and echo offset) that executes in different defined cores by numbers (it starts at 0).
```
> cat silly.conf 
4-6       hostname
1,7       echo  task:%t
0,2-3     echo  offset:%o
```
The following script allocates eight tasks and gives the previous "silly.conf" config file with the option "--multi-prog".
```
> cat multi-prog-conf.sh 
srun -n8 -l --multi-prog silly.conf
```
The command bellow starts the "multi-prog-conf.sh" script and then, the result is showed.
```
> sh multi-prog-conf.sh 
2: offset:1
5: n1
6: n1
7: task:7
0: offset:0
1: task:1
4: n1
3: offset:2
```

For more details about the explanation of the previous examples, please check the following link:
[srun documentation](https://slurm.schedmd.com/srun.html "srun command")

# MPI scripts templates for IGP's cluster

The following scripts templates were written for the users of IGP's cluster in order to help them to build their own MPI scripts, which are configured with eight tasks and three job steps. In addition, those MPI scripts are using gcc and intel compilers and also python programming language.

## MPI hello world example with gcc compiler

The bellow "mpi_job.sh" script is configured with job name as "mpi_gcc", partition name as "any2", output file as "slurm-%j.out", error file as "slurm-%j.err" and number of tasks "ntasks" as eigth. The following module commands setup the gcc compiler and openMPI library. The three srun commands launch an job step each one with different numbers of tasks as 3, 5 and 8 with the option "n".

```
> cat mpi_job.sh 
#!/bin/bash
#SBATCH --job-name=mpi_gcc
#SBATCH --partition=any2
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --ntasks=8
module purge
module load gnu/4.8.5
module load gnu_ompi/1.10.6
srun -n 3 mpi_hello_world.exe "Step-id 0"
srun -n 5 mpi_hello_world.exe "Step-id 1"
srun -n 8 mpi_hello_world.exe "Step-id 2"
```
The bellow "mpi_hello_world_gnu.sh" script compiles source code and summits the previous "mpi_job.sh" script into the cluster's resource manager.
```
> cat mpi_hello_world_gnu.sh 
#!/bin/bash
module load gnu/4.8.5
module load gnu_ompi/1.10.6
mpicc mpi_hello_world.c -o mpi_hello_world.exe 
sbatch mpi_job.sh
```
The command bellow starts the "mpi_hello_world_gnu.sh" script and then, an advice is showed.

```
> sh mpi_hello_world_gnu.sh 
Submitted batch job 16205
```
The result is saved in the output file. For instance, for this example is "slurm-16205.out".
```
> cat slurm-16205.out
Step-id 0 : Hello world with gnu from node n15, rank  0 out of 3 processors
Step-id 0 : Hello world with gnu from node n15, rank  1 out of 3 processors
Step-id 0 : Hello world with gnu from node n15, rank  2 out of 3 processors
Step-id 1 : Hello world with gnu from node n15, rank  0 out of 5 processors
Step-id 1 : Hello world with gnu from node n15, rank  1 out of 5 processors
Step-id 1 : Hello world with gnu from node n15, rank  2 out of 5 processors
Step-id 1 : Hello world with gnu from node n15, rank  3 out of 5 processors
Step-id 1 : Hello world with gnu from node n15, rank  4 out of 5 processors
Step-id 2 : Hello world with gnu from node n15, rank  0 out of 8 processors
Step-id 2 : Hello world with gnu from node n15, rank  1 out of 8 processors
Step-id 2 : Hello world with gnu from node n15, rank  2 out of 8 processors
Step-id 2 : Hello world with gnu from node n15, rank  3 out of 8 processors
Step-id 2 : Hello world with gnu from node n15, rank  4 out of 8 processors
Step-id 2 : Hello world with gnu from node n15, rank  5 out of 8 processors
Step-id 2 : Hello world with gnu from node n15, rank  6 out of 8 processors
Step-id 2 : Hello world with gnu from node n15, rank  7 out of 8 processors
```
