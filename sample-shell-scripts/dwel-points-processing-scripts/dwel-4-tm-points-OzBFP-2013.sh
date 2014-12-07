#!/bin/bash
# repose the points with a set of registration parameters.
# Zhan Li, zhanli86@bu.edu
# Created: 2014-5-29
# Last modified: 2014/08/21
#$ -pe omp 1
#$ -l h_rt=24:00:00
#$ -N dwel-points-4-1064-2013
#$ -V
#$ -t 1-5

# path to the Matlab scripts and functions
BASEDIR='/projectnb/echidna/lidar/zhanli86/Programs/TIES-TLS'
ML="/usr/local/bin/matlab -nodisplay -nojvm -singleCompThread -r "

$ML "addpath(genpath('$BASEDIR')); inptcldpathname='/projectnb/echidna/lidar/DWEL_Processing/CA2013June/CA2013_Site305/June12_01_305_C'; inptcldfilename='June12_01_305_C_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points.txt'; outptcldpathname='/projectnb/echidna/lidar/DWEL_Processing/CA2013June/CA2013_Site305/CA2013-Site305-PointClouds'; outptcldfilename='June12_01_305_C_1548_Cube_NadirCorrect_Aligned_nu_basefix_satfix_pfilter_b32r04_at_project_ptcl_points_registered.txt'; offset=[0,0,0]; rotation=[0,0,0]; run Script_TMPoints;"

wait