#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=72:00:00
#$ -N dwel-ptcl-thresh-test-1064-hfhd20140421
#$ -V
#$ -m ae
#$ -t 1-16

CUBEFILES="/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140421/HFHD20140421-C/HFHD_20140421_C_1064_cube.img"

module purge
module load envi/4.8

# give the path to your idl .pro files
# IDL_PATH=~/Programs/DWEL2.0

# cd $IDL_PATH

# use which idl to find the path to your current idl
# explicitly give a preference file to IDL startup option
#PREF='/usr3/graduate/zhanli86/Programs/DWEL2.0/dwel2.0_idl.pref'
IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"

# add the path to your program to the IDL environment variable
# $IDL "PREF_SET, 'IDL_PATH', '$IDL_PATH:<IDL_DEFAULT>', /COMMIT"

FILENAME=$CUBEFILES
# FILENAME=${CUBEFILES[0]}
BASEFILENAME=${FILENAME:0:${#FILENAME}-4}

EXTENSION="bsfix_pxc_update_atp2.img"
ATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc_update_atp2_extrainfo.img"
ATANCFILENAME=${BASEFILENAME}_${EXTENSION}

# 16 choices
SDEVFAC=( \
2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 \
)
SIEVEFAC=( \
2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5 10 \
)

EXTENSION="bsfix_pxc_update_atp2_sdfac"${SDEVFAC[$SGE_TASK_ID-1]}"_sievefac"${SIEVEFAC[$SGE_TASK_ID-1]}"_ptcl.txt"
PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:${SDEVFAC[$SGE_TASK_ID-1]}, sievefac:${SIEVEFAC[$SGE_TASK_ID-1]}, dwel_az_n:0, save_zero_hits:0, cal_dat:1}"

wait