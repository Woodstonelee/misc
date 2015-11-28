#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=2
#$ -l h_rt=24:00:00
#$ -N dwel-raw2hdf5-hf-20140608-09
#$ -V
#$ -m ae
#$ -t 1-10

WFBINFILES=( \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/C/waveform_2014-06-08-12-21" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/E/waveform_2014-06-08-15-07" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/N/waveform_2014-06-08-13-39" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/S/waveform_2014-06-08-16-15" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/W/waveform_2014-06-08-11-10" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/C/waveform_2014-06-09-10-34" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/E/waveform_2014-06-09-14-20" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/N/waveform_2014-06-09-09-28" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/S/waveform_2014-06-09-11-51" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/W/waveform_2014-06-09-13-07" \
)

ENCBINFILES=( \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/C/encoder_2010-01-10-05-48-16" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/E/encoder_2010-01-10-08-33-35" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/N/encoder_2010-01-10-07-06-28" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/S/encoder_2010-01-10-09-42-06" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/W/encoder_2010-01-10-04-36-52" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/C/encoder_2010-01-11-04-00-29" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/E/encoder_2010-01-11-07-46-27" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/N/encoder_2010-01-11-02-52-57" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/S/encoder_2010-01-11-05-18-24" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/W/encoder_2010-01-11-06-32-54" \
)

DWELENGDIR="/usr3/graduate/zhanli86/Programs/misc/dwel-engineer/AutomatedTools-20140922"

# convert waveform binary to hdf5
python $DWELENGDIR/Binary2HDF5.app/binaryproc.py ${WFBINFILES[$SGE_TASK_ID-1]}

# convert encoder binary to hdf5
python $DWELENGDIR/Encoder2HDF5.app/angleproc.py ${ENCBINFILES[$SGE_TASK_ID-1]}

# combine the waveform and encoder hdf5 files
python $DWELENGDIR/Combine.app/combine_noshow.py ${WFBINFILES[$SGE_TASK_ID-1]}.hdf5 ${ENCBINFILES[$SGE_TASK_ID-1]}.hdf5

# optional step
# move the combined waveform hdf5 file to the place you like
OUTDIRS=( \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/C" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/E" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/N" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/S" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/W" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/C" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/E" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/N" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/S" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/W" \
)

CFGFILES=( \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/C/config_2010-01-10-05-48-16.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/E/config_2010-01-10-08-33-35.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/N/config_2010-01-10-07-06-28.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/S/config_2010-01-10-09-42-06.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/W/config_2010-01-10-04-36-52.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/C/config_2010-01-11-04-00-29.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/E/config_2010-01-11-07-46-27.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/N/config_2010-01-11-02-52-57.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/S/config_2010-01-11-05-18-24.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/W/config_2010-01-11-06-32-54.cfg" \
)

mv ${WFBINFILES[$SGE_TASK_ID-1]}.hdf5 ${OUTDIRS[$SGE_TASK_ID-1]}
cp ${CFGFILES[$SGE_TASK_ID-1]} ${OUTDIRS[$SGE_TASK_ID-1]}

wait