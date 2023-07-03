#!/bin/bash

mpirun -np 1 lmp_zqex -in brownian_langevin.lam

(cd img ; jpg2avi )
