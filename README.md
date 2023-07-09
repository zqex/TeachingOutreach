This repository collects a number of simulations that we have developed in order to
illustrate statistical mechanics and soft-condensed matter systems.

The simulations utilize LAMMPS (http://lammps.sandia.giv) to run the simulations.
Files with extension *.lam are LAMMPS scripts, whereas *.input or *.input.gz are
LAMMPS data files that defines the initial conformation of a system.

To run a simulation do
    mpirun -np <cores> lmp_stable -in <script.lam>

NB your lammps executable may be called something else than lmp_stable.
