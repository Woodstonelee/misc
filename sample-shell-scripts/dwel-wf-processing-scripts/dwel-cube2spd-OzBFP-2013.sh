#!/bin/bash
#$ -pe omp 1
#$ -l h_rt=48:00:00
#$ -N dwel-cube2spd-OzBFP-2013
#$ -V

CMDPATH=/projectnb/echidna/lidar/zhanli86/Programs/SPDConversion

# Aug3 BFP C, 1.18
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1064_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1064_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1064_Cube_NadirCorrect_Aligned.spd' 
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_C/Aug3_BFP_C_1548_Cube_NadirCorrect_Aligned.spd' 

# BFP S, 1.13
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1064_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1064_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1064_Cube_NadirCorrect_Aligned.spd' 
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_NadirCorrect_Aligned.spd' 

# BFP E, 1.14
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1064_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1064_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1064_Cube_NadirCorrect_Aligned.spd' 
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1548_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1548_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1548_Cube_NadirCorrect_Aligned.spd' 

# BFP W, 1.11
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1064_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1064_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1064_Cube_NadirCorrect_Aligned.spd' 
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_NadirCorrect_Aligned.spd' 

# Aug2 BFP C, 1st half, 1.10
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1064_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1064_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1064_Cube_NadirCorrect_Aligned.spd' 
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1548_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1548_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C1_1548_Cube_NadirCorrect_Aligned.spd' 

# Aug2 BFP C, 2nd half, 1.10
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1064_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1064_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1064_Cube_NadirCorrect_Aligned.spd' 
python $CMDPATH/dwelcube2spd.py -c '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1548_Cube_NadirCorrect_Aligned.img' -a '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1548_Cube_NadirCorrect_Aligned_ancillary.img' -o '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug2_BFP_C/Aug2_BFP_C2_1548_Cube_NadirCorrect_Aligned.spd' 