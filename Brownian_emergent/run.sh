#!/bin/bash

mpirun -np 1 lmp_zqex -in brownian.lam

(cd img ; jpg2avi )
