#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=2
#$ -l h_rt=24:00:00
#$ -N dwel-raw2hdf5-cal-oz
#$ -V
#$ -m ae
#$ -t 1-38

WFBINFILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/0_5/waveform_2014-04-25-17-44" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1/waveform_2014-04-25-17-41" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/10/waveform_2014-04-25-16-48" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/11/waveform_2014-04-25-16-45" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/12/waveform_2014-04-25-16-42" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/13/waveform_2014-04-25-16-39" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/14/waveform_2014-04-25-16-33" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/15/waveform_2014-04-25-16-31" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1_5/waveform_2014-04-25-17-39" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2/waveform_2014-04-25-17-37" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/20/waveform_2014-04-25-16-27" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/25/waveform_2014-04-25-16-24" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2_5/waveform_2014-04-25-17-34" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3/waveform_2014-04-25-17-32" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/30/waveform_2014-04-25-16-20" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/35/waveform_2014-04-25-16-16" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3_5/waveform_2014-04-25-17-30" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4/waveform_2014-04-25-17-27" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/40/waveform_2014-04-25-16-13" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4_5/waveform_2014-04-25-17-25" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5/waveform_2014-04-25-17-20" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/50/waveform_2014-04-25-16-09" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5_5/waveform_2014-04-25-17-17" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6/waveform_2014-04-25-17-15" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/60/waveform_2014-04-25-16-06" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6_5/waveform_2014-04-25-17-11" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7/waveform_2014-04-25-17-08" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/70/waveform_2014-04-25-16-01" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7_5/waveform_2014-04-25-17-05" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8/waveform_2014-04-25-16-58" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8_5/waveform_2014-04-25-16-56" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9/waveform_2014-04-25-16-53" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9_5/waveform_2014-04-25-16-51" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/50/waveform_2014-05-03-12-19" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/60/waveform_2014-05-03-12-14" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/70/waveform_2014-05-03-12-00" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/80/waveform_2014-05-03-11-17" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/85/waveform_2014-05-03-11-39" \
)

ENCBINFILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/0_5/encoder_2014-04-25-08-50-02" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1/encoder_2014-04-25-08-47-45" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/10/encoder_2014-04-25-07-53-16" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/11/encoder_2014-04-25-07-51-28" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/12/encoder_2014-04-25-07-48-36" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/13/encoder_2014-04-25-07-43-19" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/14/encoder_2014-04-25-07-39-34" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/15/encoder_2014-04-25-07-37-50" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/1_5/encoder_2014-04-25-08-45-58" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2/encoder_2014-04-25-08-42-55" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/20/encoder_2014-04-25-07-34-04" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/25/encoder_2014-04-25-07-30-57" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/2_5/encoder_2014-04-25-08-40-23" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3/encoder_2014-04-25-08-38-44" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/30/encoder_2014-04-25-07-27-16" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/35/encoder_2014-04-25-07-23-03" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/3_5/encoder_2014-04-25-08-36-16" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4/encoder_2014-04-25-08-34-07" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/40/encoder_2014-04-25-07-19-35" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/4_5/encoder_2014-04-25-08-29-10" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5/encoder_2014-04-25-08-26-30" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/50/encoder_2014-04-25-07-16-02" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/5_5/encoder_2014-04-25-08-23-39" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6/encoder_2014-04-25-08-21-57" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/60/encoder_2014-04-25-07-12-34" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/6_5/encoder_2014-04-25-08-16-47" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7/encoder_2014-04-25-08-13-45" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/70/encoder_2014-04-25-07-08-04" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/7_5/encoder_2014-04-25-08-07-44" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8/encoder_2014-04-25-08-04-11" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/8_5/encoder_2014-04-25-08-01-58" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9/encoder_2014-04-25-08-00-02" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/9_5/encoder_2014-04-25-07-57-27" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/50/encoder_2014-05-03-03-26-42" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/60/encoder_2014-05-03-03-21-45" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/70/encoder_2014-05-03-03-07-03" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/80/encoder_2014-05-03-02-24-28" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_OzDWEL_20140425-0503/Calibration_OzDWEL_HF_20140503/85/encoder_2014-05-03-02-46-51" \
)

DWELENGDIR="/usr3/graduate/zhanli86/Programs/misc/dwel-engineer/AutomatedTools-20140922"

# convert waveform binary to hdf5
python $DWELENGDIR/Binary2HDF5.app/binaryproc.py ${WFBINFILES[$SGE_TASK_ID-1]}

# convert encoder binary to hdf5
python $DWELENGDIR/Encoder2HDF5.app/angleproc.py ${ENCBINFILES[$SGE_TASK_ID-1]}

# combine the waveform and encoder hdf5 files
python $DWELENGDIR/Combine.app/combine_noshow.py ${WFBINFILES[$SGE_TASK_ID-1]}.hdf5 ${ENCBINFILES[$SGE_TASK_ID-1]}.hdf5

# # optional step
# # move the combined waveform hdf5 file to the place you like
# OUTDIRS=( \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/C" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/E" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/N" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/S" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/W" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/C" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/E" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/N" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/S" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/W" \
# )

# CFGFILES=( \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/C/config_2010-01-10-05-48-16.cfg" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/E/config_2010-01-10-08-33-35.cfg" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/N/config_2010-01-10-07-06-28.cfg" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/S/config_2010-01-10-09-42-06.cfg" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June8HFHardwood/W/config_2010-01-10-04-36-52.cfg" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/C/config_2010-01-11-04-00-29.cfg" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/E/config_2010-01-11-07-46-27.cfg" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/N/config_2010-01-11-02-52-57.cfg" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/S/config_2010-01-11-05-18-24.cfg" \
# "/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-RawBinary/June9HFHemlock/W/config_2010-01-11-06-32-54.cfg" \
# )

# mv ${WFBINFILES[$SGE_TASK_ID-1]}.hdf5 ${OUTDIRS[$SGE_TASK_ID-1]}
# cp ${CFGFILES[$SGE_TASK_ID-1]} ${OUTDIRS[$SGE_TASK_ID-1]}

wait