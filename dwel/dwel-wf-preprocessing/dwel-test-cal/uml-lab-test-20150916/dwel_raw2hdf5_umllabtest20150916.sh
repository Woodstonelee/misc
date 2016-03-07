#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=4
#$ -l h_rt=24:00:00
#$ -N dwel-raw2hdf5-uml20150916
#$ -V
#$ -m ae
#$ -t 1

WFBINFILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/uml-lab-test-20150916/Scan1/waveform_2015-09-16-14-50" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/uml-lab-test-20150916/Scan2/waveform_2015-09-16-15-00" \
)

ENCBINFILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/uml-lab-test-20150916/Scan1/encoder_2010-01-02-04-38-50" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/uml-lab-test-20150916/Scan2/encoder_2010-01-02-04-48-33" \
)

DWELENGDIR="/usr3/graduate/zhanli86/Programs/dwel-engineer/AutomatedTools-20140922"

# convert waveform binary to hdf5
python $DWELENGDIR/Binary2HDF5.app/binaryproc.py ${WFBINFILES[$SGE_TASK_ID-1]}

# convert encoder binary to hdf5
python $DWELENGDIR/Encoder2HDF5.app/angleproc.py ${ENCBINFILES[$SGE_TASK_ID-1]}

# combine the waveform and encoder hdf5 files
python $DWELENGDIR/Combine.app/combine_noshow.py ${WFBINFILES[$SGE_TASK_ID-1]}.hdf5 ${ENCBINFILES[$SGE_TASK_ID-1]}.hdf5