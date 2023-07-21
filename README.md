This repository collects a number of simulations that we have developed in order to
illustrate statistical mechanics and soft-condensed matter systems.

The simulations utilize the Large Atomic Molecular Massively Parallel Simulator
(LAMMPS) to run the simulations. You can download it here http://lammps.sandia.gov

Files with extension *.lam are LAMMPS scripts, whereas *.input or *.input.gz are
LAMMPS data files that defines the initial conformation of a system.

To run a simulation do
    mpirun -np <cores> lmp_stable -in <script.lam>

NB your lammps executable is likely to be called something else than lmp_stable.

Perl scripts are used to generate some of the initial conformations. These can
not be run without additional perl modules which are not included here.
