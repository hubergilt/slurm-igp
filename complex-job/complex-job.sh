gcc master.c -o master
gcc slave.c -o slave
# original syntaxis is valid from upper than slurm version 17.11
# srun -n1 -c16 --mem-per-cpu=1gb master : -n16 --mem-per-cpu=1gb slave
srun -n1 -c16 --mem-per-cpu=1gb master
srun -n16 --mem-per-cpu=1gb slave
