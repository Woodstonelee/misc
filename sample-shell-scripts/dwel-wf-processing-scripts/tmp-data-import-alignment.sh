#!/bin/bash
#$ -pe omp 4
#$ -l h_rt=24:00:00
#$ -N job1cubealign
#$ -V
#$ -l mem_total=8
#$ -m ae

# -N dwel-data-import-alignment-OzBFP-2013

module purge
module load envi/4.8

# use which idl to find the path to your current idl
# IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"
IDL="/project/earth/packages/itt-4.8/idl/idl80/bin/idl -quiet -e"
# give the path to your idl .pro files
IDL_PATH=/projectnb/echidna/lidar/zhanli86/Programs/DWEL

# add the path to your program to the IDL environment variable
$IDL "PREF_SET, 'IDL_PATH', '$IDL_PATH:<IDL_DEFAULT>', /COMMIT"

# dwel2alignedcube_cmd, DWEL_H5File, Flag_H5File, AlignedMaskFile, DataCube_File, Wavelength, Wavelength_Label, DWEL_Height, beam_div, srate

# BFP S, 1.13
$IDL "dwel2alignedcube_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_S/Aug3_Bris_S.hdf5', '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_S/Aug3_Bris_S-flag.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_Cube_NadirCorrect_alignment_mask--2097152.tif', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_NadirCorrect_Aligned.img', 1064, 1548, 1.13, 2.5, 2.0"

# BFP W, 1.11
$IDL "dwel2alignedcube_cmd, '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_W/Aug3_Bris_W.hdf5', '/projectnb/echidna/lidar/Data_2013OzBrisbane/DWEL/Aug3_Bris/Aug3_Bris_W/Aug3_Bris_W-flag.hdf5', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_Cube_NadirCorrect_alignment_mask--2097152.tif', '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_NadirCorrect_Aligned.img', 1064, 1548, 1.11, 2.5, 2.0"

wait