gcc master.c -o master
gcc slave.c -o slave
# the original syntax is valid only since slurm version 17.11
# srun -n1 -c16 --mem-per-cpu=1gb master : -n16 --mem-per-cpu=1gb slave
srun -n1 -c16 --mem-per-cpu=1gb master
srun -n16 --mem-per-cpu=1gb slave
