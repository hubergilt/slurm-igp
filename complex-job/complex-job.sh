gcc master.c -o master
gcc slave.c -o slave
srun -n1 -c16 --mem-per-cpu=1gb master : -n16 --mem-per-cpu=1gb slave
