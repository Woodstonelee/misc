#!/bin/bash
#$ -pe omp 6
#$ -l h_rt=24:00:00
#$ -N job2jitterfix
#$ -V

# -N dwel-scan-align-OzBFP-2013

COMMAND_PATH=/projectnb/echidna/lidar/zhanli86/Programs/DWEL/JitterFix
ALIGN_COMMAND=$COMMAND_PATH/AlignScanImage.sh

# Aug3 BFP C, 1.18
$ALIGN_COMMAND --a1064 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1064_Cube_NadirCorrect_ancillary.img' --a1548 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_NadirCorrect_ancillary.img' -S 2 -M '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_Cube_NadirCorrect_alignment_mask.tif' -g -1024^2*2 &

# BFP S, 1.13
$ALIGN_COMMAND --a1064 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1064_Cube_NadirCorrect_ancillary.img' --a1548 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_NadirCorrect_ancillary.img' -S 3 -M '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_Cube_NadirCorrect_alignment_mask.tif' -g -1024^2*2 &

# BFP E, 1.14
$ALIGN_COMMAND --a1064 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1064_Cube_NadirCorrect_ancillary.img' --a1548 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1548_Cube_NadirCorrect_ancillary.img' -S 3 -M '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_Cube_NadirCorrect_alignment_mask.tif' -g -1024^2*2 &

# BFP W, 1.11
$ALIGN_COMMAND --a1064 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1064_Cube_NadirCorrect_ancillary.img' --a1548 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_NadirCorrect_ancillary.img' -S 3 -M '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_Cube_NadirCorrect_alignment_mask.tif' -g -1024^2*2 &

# Aug2 BFP C, 1st half, 1.10
$ALIGN_COMMAND --a1064 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1064_Cube_NadirCorrect_ancillary.img' --a1548 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1548_Cube_NadirCorrect_ancillary.img' -S 3 -M '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_Cube_NadirCorrect_alignment_mask.tif' -g -1024^2*2 &

# Aug2 BFP C, 2nd half, 1.10
$ALIGN_COMMAND --a1064 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1064_Cube_NadirCorrect_ancillary.img' --a1548 '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1548_Cube_NadirCorrect_ancillary.img' -S 2 -M '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_Cube_NadirCorrect_alignment_mask.tif' -g -1024^2*2 &

wait