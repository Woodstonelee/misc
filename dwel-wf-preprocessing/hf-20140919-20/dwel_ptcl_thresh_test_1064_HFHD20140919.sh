#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=72:00:00
#$ -N dwel-ptcl-thresh-test-1064-HFHD20140919
#$ -V
#$ -m ae
#$ -t 1-56

CUBEFILES="/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140919/HFHD_20140919_C/HFHD_20140919_C_1064_cube.img"

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

EXTENSION="bsfix_pulsexc_update_at_project.img"
ATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pulsexc_update_at_project_extrainfo.img"
ATANCFILENAME=${BASEFILENAME}_${EXTENSION}

# 8 choices
SDEVFAC=( \
1 2 3 4 5 6 7 8 \
1 2 3 4 5 6 7 8 \
1 2 3 4 5 6 7 8 \
1 2 3 4 5 6 7 8 \
1 2 3 4 5 6 7 8 \
1 2 3 4 5 6 7 8 \
1 2 3 4 5 6 7 8 \
)
# 7 choices
RTHRESH=( \
0 0 0 0 0 0 0 0 \
1 1 1 1 1 1 1 1 \
2 2 2 2 2 2 2 2 \
3 3 3 3 3 3 3 3 \
4 4 4 4 4 4 4 4 \
5 5 5 5 5 5 5 5 \
6 6 6 6 6 6 6 6 \
)

EXTENSION="bsfix_pulsexc_update_at_project_ptcl"-B${SDEVFAC[$SGE_TASK_ID-1]}-R${RTHRESH[$SGE_TASK_ID-1]}".txt"
PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & settings={sdevfac:2.0+0.5*${SDEVFAC[$SGE_TASK_ID-1]}, r_thresh:0.175+0.005*${RTHRESH[$SGE_TASK_ID-1]}, save_pfilt:0, xmin:-100.0, xmax:100.0, ymin:-100.0, ymax:100.0, zhigh:100.0} & print, settings & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings=settings"

wait