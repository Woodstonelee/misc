#!/bin/bash
# automatically match trunk centers from two scans. 
# Zhan Li, zhanli86@bu.edu
# Created: 2014-5-28
# Last revision: 2014/08/21
#$ -pe omp 1
#$ -l h_rt=24:00:00
#$ -N dwel-points-3-1548-OzBFP-2013
#$ -V
#$ -t 1-5

# set up array variables for inputs to run multiple Matlab programs
EVIPTSFILENAMES=( \
  "Aug3_BFP_E_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.txt" \
  "Aug3_BFP_S_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.txt" \
  "Aug3_BFP_W_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.txt" \
  "Aug2_BFP_C1_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.txt" \
  "Aug2_BFP_C2_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.txt" \
)

# check and set up a directory for point cloud processing results if it does not exist. 
# TMPDIR="${EVIPTSPATHNAMES[$SGE_TASK_ID-1]}"
INPTSPATHNAME="/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/brisbane2013-bfp-points/registration"
if [ ! -d "$INPTSPATHNAME" ]; then
  mkdir -p "$INPTSPATHNAME"
fi

MODELFPPATHNAME="$INPTSPATHNAME"
MODELFPFILENAME="Aug3_BFP_C_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.fp"

DATAFPPATHNAME="$INPTSPATHNAME"
TMPFILE="${EVIPTSFILENAMES[$SGE_TASK_ID-1]}"
DATAFPFILENAME="${TMPFILE:0:${#TMPFILE}-4}.fp"

MATCHEDPATHNAME="$INPTSPATHNAME"
MATCHEDFILENAMES=( \
  "brisbane-bfp-automatch-trkctr-1548-e2c.txt" \
  "brisbane-bfp-automatch-trkctr-1548-s2c.txt" \
  "brisbane-bfp-automatch-trkctr-1548-w2c.txt" \
  "brisbane-bfp-automatch-trkctr-1548-c12c.txt" \
  "brisbane-bfp-automatch-trkctr-1548-c22c.txt" \
)
MATCHEDFILENAME="${MATCHEDFILENAMES[$SGE_TASK_ID-1]}"

# path to the Matlab scripts and functions
BASEDIR='/projectnb/echidna/lidar/zhanli86/Programs/TIES-TLS'
ML="/usr/local/bin/matlab -nodisplay -nojvm -singleCompThread -r "

$ML "addpath(genpath('$BASEDIR')); modelfppathname='$MODELFPPATHNAME'; modelfpfilename = '$MODELFPFILENAME'; datafppathname='$DATAFPPATHNAME'; datafpfilename = '$DATAFPFILENAME'; matchedfppathname = '$MATCHEDPATHNAME'; matchedfpfilename='$MATCHEDFILENAME'; disthreshold = 1.0; maxiter = 100; run Script5_AutoMatchTrkCtr"

wait