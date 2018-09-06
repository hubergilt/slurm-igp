#!/usr/bin/env python

from __future__ import print_function
from mpi4py import MPI
from socket import gethostname
from sys import argv

comm = MPI.COMM_WORLD

print("%s : Hello world with python from node %s, rank  %d out of %d processors" % (len(argv)>1 and argv[1] or '', gethostname(), comm.rank, comm.size))
comm.Barrier() # wait for everybody to synchronize _here_
