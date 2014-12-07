#!/bin/bash
# 1. generate DEM from ground points. Write DEM in ascii file with a ArcGIS raster-to-ascii output format. 
# 2. search stems and extract trunk centers at 1.4m above ground. 
# Zhan Li, zhanli86@bu.edu
# Created: 2014-5-28
# Last revision: 2014/08/21
#$ -pe omp 4
#$ -l h_rt=24:00:00
#$ -N dwel-points-2-OzBFP-2013
#$ -V
#$ -t 1-3

# set up array variables for inputs to run multiple Matlab programs
EVIPTSPATHNAMES=( \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_E" \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_S" \
  "/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/Aug3_BFP_W" \
)

EVIPTSFILENAMES=( \
  "Aug3_BFP_E_1064_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.txt" \
  "Aug3_BFP_S_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.txt" \
  "Aug3_BFP_W_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.txt" \
)

# check and set up a directory for point cloud processing results if it does not exist. 
# TMPDIR="${EVIPTSPATHNAMES[$SGE_TASK_ID-1]}"
INPTSPATHNAME="/projectnb/echidna/lidar/DWEL_Processing/Brisbane2013Aug/Brisbane2013_BFP/brisbane2013-bfp-points/registration"
if [ ! -d "$INPTSPATHNAME" ]; then
  mkdir -p "$INPTSPATHNAME"
fi

TMPFILE="${EVIPTSFILENAMES[$SGE_TASK_ID-1]}"
INPTSFILENAME="${TMPFILE:0:${#TMPFILE}-4}.xyz"
GROUNDPTSFILENAME="${TMPFILE:0:${#TMPFILE}-4}_ground.xyz"
DEMFILENAME="${TMPFILE:0:${#TMPFILE}-4}_ground.dem"
FPFILENAME="${TMPFILE:0:${#TMPFILE}-4}.fp"

# path to the Matlab scripts and functions
BASEDIR='/projectnb/echidna/lidar/zhanli86/Programs/TIES-TLS'
ML="/usr/local/bin/matlab -nodisplay -nojvm -singleCompThread -r "

$ML "addpath(genpath('$BASEDIR')); GroundPtsPathName='$INPTSPATHNAME'; GroundPtsFileName='$GROUNDPTSFILENAME'; demfilename=fullfile('$INPTSPATHNAME', '$DEMFILENAME'); cellsize=0.2; nodata=-9999; maxTINedgelen=10; run Script3_Points2DEM; ptsfilename=fullfile('$INPTSPATHNAME', '$INPTSFILENAME'); fpfilename=fullfile('$INPTSPATHNAME', '$FPFILENAME'); range = 50; height_clear = 1.4; cellsize = 0.05; maxR = 30; sigmacoef = 1; epsion = 0.01; maxIter = 200; minnumfit = 9; minNumTrkCtr = 4; run Script4_TrkCtrSingleScanLayer" 

wait