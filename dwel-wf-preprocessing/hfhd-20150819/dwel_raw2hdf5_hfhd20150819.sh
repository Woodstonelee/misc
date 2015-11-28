#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=4
#$ -l h_rt=24:00:00
#$ -N dwel-raw2hdf5-hfhd20150819
#$ -V
#$ -m ae
#$ -t 2-5

WFBINFILES=( \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C/waveform_2015-08-19-10-18" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-2/waveform_2015-08-19-13-30" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-3/waveform_2015-08-19-14-37" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-E/waveform_2015-08-19-12-01" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-4/waveform_2015-08-19-15-51" \
)

ENCBINFILES=( \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C/encoder_2015-08-19-10-18" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-2/encoder_2015-08-19-13-29-56" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-3/encoder_2015-08-19-14-36-22" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-E/encoder_2015-08-19-12-00-25" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-4/encoder_2015-08-19-15-50-26" \
)

DWELENGDIR="/usr3/graduate/zhanli86/Programs/dwel-engineer/AutomatedTools-20140922"

# convert waveform binary to hdf5
python $DWELENGDIR/Binary2HDF5.app/binaryproc.py ${WFBINFILES[$SGE_TASK_ID-1]}

# convert encoder binary to hdf5
python $DWELENGDIR/Encoder2HDF5.app/angleproc.py ${ENCBINFILES[$SGE_TASK_ID-1]}

# combine the waveform and encoder hdf5 files
python $DWELENGDIR/Combine.app/combine_noshow.py ${WFBINFILES[$SGE_TASK_ID-1]}.hdf5 ${ENCBINFILES[$SGE_TASK_ID-1]}.hdf5