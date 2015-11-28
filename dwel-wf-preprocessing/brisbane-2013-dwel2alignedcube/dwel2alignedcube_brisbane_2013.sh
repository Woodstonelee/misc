#!/bin/bash
# request and reserve 4 cpus on the server for this job
#$ -pe omp 4
# request and reserve 8G RAM on the server for this job
#$ -l mem_total=8
# request 24 hours maximum running time on the server for this job
#$ -l h_rt=24:00:00
# the name of this job
#$ -N dwel2alignedcube-brisbane-2013
# tell the server to inherit all system environment variables from your own shell
#$ -V
# tell the server to send message tjo your default email address (BU email) once the job is finished or stopped b/c error
#$ -m ae
# number of tasks in the job, they will be running in parallel on the server. Now this option is commented out.
# #$ -t 1-20

IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"

HDF5FILES="/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug1_Kara5/Aug1_Kara5_C/Aug1_Kara5_C.hdf5"

FLAGFILES="/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug1_Kara5/Aug1_Kara5_C/Aug1_Kara5_C-flag.hdf5"

ALIGNMASKFILES="/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_Kara05/Aug1_Kara05_C/Aug1_Kara5_C_Cube_NadirCorrect_alignment_mask.tif"

CUBEFILES="/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_Kara05/Aug1_Kara05_C/Aug1_Kara5_C_Cube_NadirCorrect_Aligned_1064_cube.img"

WL=1548

WLLABEL=1064

INSHEIGHTS=1.33

$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & DWEL2AlignedCube_cmd, '$HDF5FILES', '$FLAGFILES', '$ALIGNMASKFILES', '$CUBEFILES', $WL, $WLLABEL, $INSHEIGHTS,2.5, 2.0"

wait
