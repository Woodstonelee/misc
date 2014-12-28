#!/bin/bash
# Run DualPts2ClassifiedPgap.m on server node by requesting large memory
# Zhan Li, zhanli86@bu.edu
# Created: 20141212
# last revision: 20141212
#$ -pe omp 1
#$ -l h_rt=24:00:00
#$ -l mem_total=8
#$ -N dualpts2classifiedpgap
#$ -V
#$ -m ae

BASEDIR="/usr3/graduate/zhanli86/Programs/misc/dwel-points-analysis"
ML="/usr/local/bin/matlab -nodisplay -nojvm -singleCompThread -r "

$ML "run $BASEDIR/DualPts2ClassifiedPgap.m"

wait