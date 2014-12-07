#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=24:00:00
#$ -N pfilter-OzBFP-2013
#$ -V
#$ -m ae
#$ -t 1-3

module purge
module load envi/4.8

# array variables for IDL programs
DATAFILES=( \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1064_Cube_NadirCorrect_Aligned_nu_basefix_satfix.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix.img" \
)

ANCFILES=( \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_ancillary.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1064_Cube_NadirCorrect_Aligned_nu_basefix_satfix_ancillary.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_ancillary.img" \
)

OUTFILES=( \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S/Aug3_BFP_S_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E/Aug3_BFP_E_1064_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W/Aug3_BFP_W_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04.img" \
)

# prepare batch script files for the IDL program
(
cat <<EOF
[pfilter]
;Pulse Filter batch runs for DWEL basic reprocessing of Oz data of 2013
n_case=1
Run_Desc='DWEL processing of Oz of 2013 - pulse filtering'
log_file='/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/DWEL_pfilter_Oz_2013.$SGE_TASK_ID.log'
;
datafile=[ $
'${DATAFILES[$SGE_TASK_ID-1]}' $
]
;
ancfile=[ $
'${ANCFILES[$SGE_TASK_ID-1]}' $
]
;
outfile=[ $
'${OUTFILES[$SGE_TASK_ID-1]}' $
]
;
b_thresh=32
r_thresh=0.4
;
save_br=0
Exit_IDL=0
delete_input=0
EOF
) > "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/DWEL_pfilter_Oz_2013.$SGE_TASK_ID.txt"


# use which idl to find the path to your current idl
# IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"
IDL="/project/earth/packages/itt-4.8/idl/idl80/bin/idl -quiet -e"
# give the path to your idl .pro files
IDL_PATH=/projectnb/echidna/lidar/zhanli86/Programs/DWEL

# add the path to your program to the IDL environment variable
$IDL "PREF_SET, 'IDL_PATH', '$IDL_PATH:<IDL_DEFAULT>', /COMMIT"

# dwel_pfilter_batch_doit_cmd, script_file

$IDL "dwel_pfilter_batch_doit_cmd, '/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/DWEL_pfilter_Oz_2013.$SGE_TASK_ID.txt'" 

wait