# openFOAM_Cessna
Cessna simulation - openFOAM Tutorial



How to run me:



#To clean the directory, this is optional

foamCleanTutorials

cp geo/cessna210.stl constant/triSurface/surfacemesh.stl

surfaceTransformPoints -scale '(0.3 0.3 0.3)' constant/triSurface/surfacemesh.stl constant/triSurface/surfacemesh_scaled.stl

surfaceFeatureExtract



#Run SHM in parallel (4 procs)

blockMesh

decomposePar

mpirun -np 4 snappyHexMesh -parallel -overwrite | tee log.shm

mpirun -np 4 checkMesh -parallel



#Run the solver in parallel (4 procs)

reconstructParMesh -constant

rm -rf processor*

changeDictionary 

cp -r 0_org/ 0

decomposePar

mpirun -np 4 renumberMesh -overwrite -parallel

mpirun -np 4 simpleFoam -parallel | tee log

reconstructPar -latestTime

simpleFoam -postProcess -func yPlus -latestTime

simpleFoam -postProcess -func Q -latestTime

paraFoam 





NOTE1:
Geometry generated using OpenVSP


NOTE2:
To compute k

    k = 3/2 * (U I)^2

    where U is the freestream velocity and I is the turbulence intensity


To compute epsilon

    epsilon = (C_mu rho kappa^2 / mu)*(eddy_viscosity_tatio)^-1

    where C_mu = 0.009 (turbulence model constant), rho is the freestream density, mu is the
    dynamic viscosity nad eddy_viscosity_ratio is equal to mu_t/mu

In this case I = 1% and mu_t/mu = 5

This case tends to diverge with the turbulence model on from the begining of the simulation
To stabilize turbulence variable play with the URF


mu_t/mu = eddy_viscosity_ratio	
Usually a value between 1 and 10.  Choose 5 is you want to play it safe.

To consider: 

k at the wall is zero (by definition).
