#!/bin/bash

mpirun -np 4 lmp_zqex -in gas_T1.lam                   -log T1.log
mpirun -np 4 lmp_zqex -in gas_T2.lam                   -log T2.log
mpirun -np 4 lmp_zqex -in gas_T1_compress_slow.lam     -log compress_slow.log
mpirun -np 4 lmp_zqex -in gas_T1_compress_fast.lam     -log compress_fast.log


