#!/bin/bash
#$ -pe omp 1
# #$ -l mem_total=8
#$ -l h_rt=24:00:00
#$ -N dwel-raw2hdf5-processing-bu-rslab-test-20141118
#$ -V
#$ -m ae
#$ -t 1-3

WFBINFILES=( \
  "/projectnb/echidna/lidar/Data_DWEL_TestCal/bu-rslab-panel-test-20141118/gray1/waveform_2014-11-18-19-39" \
  "/projectnb/echidna/lidar/Data_DWEL_TestCal/bu-rslab-panel-test-20141118/gray2/waveform_2014-11-18-19-25" \
  "/projectnb/echidna/lidar/Data_DWEL_TestCal/bu-rslab-panel-test-20141118/lambertian/waveform_2014-11-18-19-13" \
)

ENCBINFILES=( \
  "/projectnb/echidna/lidar/Data_DWEL_TestCal/bu-rslab-panel-test-20141118/gray1/encoder_2010-03-05-12-41-19" \
  "/projectnb/echidna/lidar/Data_DWEL_TestCal/bu-rslab-panel-test-20141118/gray2/encoder_2010-03-05-12-27-30" \
  "/projectnb/echidna/lidar/Data_DWEL_TestCal/bu-rslab-panel-test-20141118/lambertian/encoder_2010-03-05-12-16-21" \
)

DWELENGDIR="/usr3/graduate/zhanli86/Programs/dwel-engineer/AutomatedTools-20140922"

# convert waveform binary to hdf5
# python $DWELENGDIR/Binary2HDF5.app/binaryproc.py ${WFBINFILES[$SGE_TASK_ID-1]}

# convert encoder binary to hdf5
# python $DWELENGDIR/Encoder2HDF5.app/angleproc.py ${ENCBINFILES[$SGE_TASK_ID-1]}

# combine the waveform and encoder hdf5 files
python $DWELENGDIR/Combine.app/combine_noshow.py ${WFBINFILES[$SGE_TASK_ID-1]}.hdf5 ${ENCBINFILES[$SGE_TASK_ID-1]}.hdf5