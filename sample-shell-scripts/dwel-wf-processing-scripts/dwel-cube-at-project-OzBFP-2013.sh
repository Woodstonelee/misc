#!/bin/bash
#$ -pe omp 2
#$ -l h_rt=24:00:00
#$ -N dwel-cube-at-project-OzBFP-2013
#$ -V

module purge
module load envi/4.8

# use which idl to find the path to your current idl
IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"
# give the path to your idl .pro files
IDL_PATH=/projectnb/echidna/lidar/zhanli86/Programs/DWEL

# add the path to your program to the IDL environment variable
$IDL "PREF_SET, 'IDL_PATH', '$IDL_PATH:<IDL_DEFAULT>', /COMMIT"

$IDL ".compile dwel_cube2at.pro"

# DWEL_Cube2AT, DWEL_Cube_File, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution

$IDL "dwel_cube2at, '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1064_Cube_NadirCorrect_Aligned.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1064_Cube_NadirCorrect_Aligned_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1064_Cube_NadirCorrect_Aligned_at_project.img', 180, 2.0" &

$IDL "dwel_cube2at, '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_NadirCorrect_Aligned.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_NadirCorrect_Aligned_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_NadirCorrect_Aligned_at_project.img', 180, 2.0" &

wait
