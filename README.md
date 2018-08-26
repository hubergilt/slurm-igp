# Examples of SLURM scripts at IGP's cluster
======

The SLURM is an open source project which is used to administrate and schedule the system resources for a Linux cluster environment. 

Please, check [SLURM Workload Manager](https://slurm.schedmd.com/ "SLURM Official Webpage")
 
The following scripts are based on the examples from the official SLURM documentation (specifically from the examples from the srun command) and the aim of this
 work is to adapt theirs in order to work properly for IGP's cluster.

#### Simple job script
This basic example allocates eigth tasks and shows the name of the host on each task.
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
- complex-job
- different-jobs-exec
- job-step-dedicated
- job-step-parallel
- job-step-relative
- multi-core-options
- multiple-program
- simple-mpi-job

For more details about the explanation of this examples, please check the following link:
[srun documentation](https://slurm.schedmd.com/srun.html "srun command")
