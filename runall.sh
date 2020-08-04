
#To clean the directory, this is optional

foamCleanTutorials

surfaceTransformPoints -scale '(0.3 0.3 0.3)' constant\triSurface/surfacemesh.stl constant\triSurface/surfacemesh_scaled.stl

surfaceFeatureExtract



#Run SHM in parallel (4 procs)

blockMesh

decomposePar

mpirun -np 4 snappyHexMesh -parallel -overwrite
mpirun -np 4 checkMesh -parallel



#Run the solver in parallel (4 procs)

reconstructParMesh -constant

rm -rf processor*

changeDictionary 

cp -r 0_org/ 0

decomposePar

mpirun -np 4 renumberMesh -overwrite -parallel

mpirun -np 4 simpleFoam -parallel
reconstructPar -latestTime

simpleFoam -postProcess -func yPlus -latestTime

simpleFoam -postProcess -func Q -latestTime

