#!/bin/bash
#$ -pe omp 12
#$ -l h_rt=24:00:00
#$ -N job1cubeenc
#$ -V

#### -N dwel-data-import-enc-correct-OzBFP-2013
module purge
module load envi/4.8

# use which idl to find the path to your current idl
# IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"
IDL="/project/earth/packages/itt-4.8/idl/idl80/bin/idl -quiet -e"
# give the path to your idl .pro files
IDL_PATH=/projectnb/echidna/lidar/zhanli86/Programs/DWEL

# add the path to your program to the IDL environment variable
$IDL "PREF_SET, 'IDL_PATH', '$IDL_PATH:<IDL_DEFAULT>', /COMMIT"

# dwel2cube_encodercorr_cmd, DWEL_H5File, oldancillaryfile_name, DWEL_Casing_Mask, DataCube_File, Wavelength, Wavelength_Label, DWEL_Height, beam_div, srate

# Aug3 BFP C, 1.18
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_C/Aug3_Bris_C.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1064_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1064_Cube_NadirCorrect.img', 1548, 1064, 1.18, 2.5, 2.0" &
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_C/Aug3_Bris_C.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_NadirCorrect.img', 1064, 1548, 1.18, 2.5, 2.0" &

# BFP S, 1.13
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_S/Aug3_Bris_S.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1064_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1064_Cube_NadirCorrect.img', 1548, 1064, 1.13, 2.5, 2.0" &
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_S/Aug3_Bris_S.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_NadirCorrect.img', 1064, 1548, 1.13, 2.5, 2.0" &

# BFP E, 1.14
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_E/Aug3_Bris_E.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1064_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1064_Cube_NadirCorrect.img', 1548, 1064, 1.14, 2.5, 2.0" &
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_E/Aug3_Bris_E.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1548_Cube_NadirCorrect.img', 1064, 1548, 1.14, 2.5, 2.0" &

# BFP W, 1.11
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_W/Aug3_Bris_W.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1064_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1064_Cube_NadirCorrect.img', 1548, 1064, 1.11, 2.5, 2.0" &
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_W/Aug3_Bris_W.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_NadirCorrect.img', 1064, 1548, 1.11, 2.5, 2.0" &

# Aug2 BFP C, 1st half, 1.10
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug2_Bris_C/1st_half/Aug2_Bris_C1.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1064_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1064_Cube_NadirCorrect.img', 1548, 1064, 1.10, 1.25, 2.0" &
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug2_Bris_C/1st_half/Aug2_Bris_C1.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1548_Cube_NadirCorrect.img', 1064, 1548, 1.10, 1.25, 2.0" &

# Aug2 BFP C, 2nd half, 1.10
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug2_Bris_C/2nd_half/Aug2_Bris_C2.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1064_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1064_Cube_NadirCorrect.img', 1548, 1064, 1.10, 1.25, 2.0" &
$IDL "dwel2cube_encodercorr_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug2_Bris_C/2nd_half/Aug2_Bris_C2.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1548_Cube_ancillary.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1548_Cube_range_mask.img', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1548_Cube_NadirCorrect.img', 1064, 1548, 1.10, 1.25, 2.0" &

wait