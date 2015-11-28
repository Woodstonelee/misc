#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=4
#$ -l h_rt=24:00:00
#$ -N dwel-raw2hdf5-hfhd20150919
#$ -V
#$ -m ae
#$ -t 1-5

WFBINFILES=( \
"/projectnb/echidna/lidar/Data_2015HF0919/DWEL/HFHD20150919-C/waveform_2015-09-19-09-58" \
"/projectnb/echidna/lidar/Data_2015HF0919/DWEL/HFHD20150919-E/waveform_2015-09-19-12-23" \
"/projectnb/echidna/lidar/Data_2015HF0919/DWEL/HFHD20150919-N/waveform_2015-09-19-11-14" \
"/projectnb/echidna/lidar/Data_2015HF0919/DWEL/HFHD20150919-S/waveform_2015-09-19-13-51" \
"/projectnb/echidna/lidar/Data_2015HF0919/DWEL/HFHD20150919-W/waveform_2015-09-19-15-05" \
)

ENCBINFILES=( \
"/projectnb/echidna/lidar/Data_2015HF0919/DWEL/HFHD20150919-C/encoder_2010-01-03-03-07-45" \
"/projectnb/echidna/lidar/Data_2015HF0919/DWEL/HFHD20150919-E/encoder_2015-09-19-12-23-07" \
"/projectnb/echidna/lidar/Data_2015HF0919/DWEL/HFHD20150919-N/encoder_2015-09-19-11-14-21" \
"/projectnb/echidna/lidar/Data_2015HF0919/DWEL/HFHD20150919-S/encoder_2015-09-19-13-51-08" \
"/projectnb/echidna/lidar/Data_2015HF0919/DWEL/HFHD20150919-W/encoder_2015-09-19-15-05-18" \
)

DWELENGDIR="/usr3/graduate/zhanli86/Programs/dwel-engineer/AutomatedTools-20140922"

# convert waveform binary to hdf5
python $DWELENGDIR/Binary2HDF5.app/binaryproc.py ${WFBINFILES[$SGE_TASK_ID-1]}

# convert encoder binary to hdf5
python $DWELENGDIR/Encoder2HDF5.app/angleproc.py ${ENCBINFILES[$SGE_TASK_ID-1]}

# combine the waveform and encoder hdf5 files
python $DWELENGDIR/Combine.app/combine_noshow.py ${WFBINFILES[$SGE_TASK_ID-1]}.hdf5 ${ENCBINFILES[$SGE_TASK_ID-1]}.hdf5