# openFOAM_Cessna
Cessna simulation - openFOAM Tutorial


![Immagine](https://user-images.githubusercontent.com/54579322/89345594-ff571100-d6a7-11ea-9463-a8a755756ffb.png)


![Immagine2](https://user-images.githubusercontent.com/54579322/89345612-07af4c00-d6a8-11ea-8d96-f133e64930bd.png)

How to run me:

Extract the geometry file

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

