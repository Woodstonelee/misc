#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=4
#$ -l h_rt=24:00:00
#$ -N dwel-raw2hdf5-hfhd20150818
#$ -V
#$ -m ae
#$ -t 4

WFBINFILES=( \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150818-C/waveform_2015-08-18-13-33" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150818-N/waveform_2015-08-18-14-36" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150818-S/waveform_2015-08-18-16-17" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150818-W/waveform_2015-08-18-11-02" \
)

ENCBINFILES=( \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150818-C/encoder_2015-08-18-13-33" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150818-N/encoder_2015-08-18-14-36" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150818-S/encoder_2015-08-18-16-17" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150818-W/encoder_2015-08-18-11-02" \
)

DWELENGDIR="/usr3/graduate/zhanli86/Programs/dwel-engineer/AutomatedTools-20140922"

# convert waveform binary to hdf5
python $DWELENGDIR/Binary2HDF5.app/binaryproc.py ${WFBINFILES[$SGE_TASK_ID-1]}

# convert encoder binary to hdf5
python $DWELENGDIR/Encoder2HDF5.app/angleproc.py ${ENCBINFILES[$SGE_TASK_ID-1]}

# combine the waveform and encoder hdf5 files
python $DWELENGDIR/Combine.app/combine_noshow.py ${WFBINFILES[$SGE_TASK_ID-1]}.hdf5 ${ENCBINFILES[$SGE_TASK_ID-1]}.hdf5