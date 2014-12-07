#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=24:00:00
#$ -N basesatfix-OzBFP-2013
#$ -V
#$ -m ae
#$ -t 1-3

module purge
module load envi/4.8

# use which idl to find the path to your current idl
# IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"
IDL="/project/earth/packages/itt-4.8/idl/idl80/bin/idl -quiet -e"
# give the path to your idl .pro files
IDL_PATH=/projectnb/echidna/lidar/zhanli86/Programs/DWEL

# add the path to your program to the IDL environment variable
$IDL "PREF_SET, 'IDL_PATH', '$IDL_PATH:<IDL_DEFAULT>', /COMMIT"

CUBEFILES=( \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_NadirCorrect_Aligned.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1064_Cube_NadirCorrect_Aligned.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_NadirCorrect_Aligned.img" \
)

CASING_RANGE=( \
  [123, 125] \
  [123, 125] \
  [123, 125] \
)

$IDL "dwel_baseline_sat_fix_cmd, '${CUBEFILES[$SGE_TASK_ID-1]}', ${CASING_RANGE[$SGE_TASK_ID-1]}" 

wait