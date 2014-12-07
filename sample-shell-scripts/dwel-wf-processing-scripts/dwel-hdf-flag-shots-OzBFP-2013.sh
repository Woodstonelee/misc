#!/bin/bash
#$ -pe omp 6
#$ -l h_rt=24:00:00
#$ -N job3hdf
#$ -V

# -N dwel-hdf-flag-shots-OzBFP-2013

module purge
module load envi/4.8

# use which idl to find the path to your current idl
# IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"
IDL="/project/earth/packages/itt-4.8/idl/idl80/bin/idl -quiet -e"
# give the path to your idl .pro files
IDL_PATH=/projectnb/echidna/lidar/zhanli86/Programs/DWEL

# add the path to your program to the IDL environment variable
$IDL "PREF_SET, 'IDL_PATH', '$IDL_PATH:<IDL_DEFAULT>', /COMMIT"

# dwel_hdf_flag_shots, DWEL_H5File, ancillaryfile_name, Filtered_Casing_Mask_File, Flag_H5File

# Aug3 BFP C, 1.18
$IDL "dwel_hdf_flag_shots, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_C/Aug3_Bris_C.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_range_mask_morphopenclose.img', '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_C/Aug3_Bris_C-flag.hdf5'" &

# BFP S, 1.13
$IDL "dwel_hdf_flag_shots, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_S/Aug3_Bris_S.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_range_mask_morphopenclose.img', '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_S/Aug3_Bris_S-flag.hdf5'" &

# BFP E, 1.14
$IDL "dwel_hdf_flag_shots, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_E/Aug3_Bris_E.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1548_Cube_range_mask_morphopenclose.img', '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_E/Aug3_Bris_E-flag.hdf5'" &

# BFP W, 1.11
$IDL "dwel_hdf_flag_shots, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_W/Aug3_Bris_W.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_range_mask_morphopenclose.img', '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_W/Aug3_Bris_W-flag.hdf5'" &

# Aug2 BFP C, 1st half, 1.10
$IDL "dwel_hdf_flag_shots, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug2_Bris_C/1st_half/Aug2_Bris_C1.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1548_Cube_range_mask_morphopenclose.img', '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug2_Bris_C/1st_half/Aug2_Bris_C1-flag.hdf5'" &

# Aug2 BFP C, 2nd half, 1.10
$IDL "dwel_hdf_flag_shots, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug2_Bris_C/2nd_half/Aug2_Bris_C2.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1548_Cube_range_mask_morphopenclose.img', '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug2_Bris_C/2nd_half/Aug2_Bris_C2-flag.hdf5'" &

wait