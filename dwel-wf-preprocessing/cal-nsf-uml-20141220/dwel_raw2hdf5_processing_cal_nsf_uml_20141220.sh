#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=2
#$ -l h_rt=24:00:00
#$ -N dwel-raw2hdf5-processing-cal-nsf-uml-20141220
#$ -V
#$ -m ae
#$ -t 1-35

WFBINFILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/0.5/waveform_2014-12-20-11-22" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1.5/waveform_2014-12-20-11-52" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1/waveform_2014-12-20-11-41" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/10/waveform_2014-12-20-17-06" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/11/waveform_2014-12-20-17-24" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/12/waveform_2014-12-20-17-34" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/13/waveform_2014-12-20-17-49" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/14/waveform_2014-12-20-18-02" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/15/waveform_2014-12-20-18-17" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2.5/waveform_2014-12-20-12-43" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2/waveform_2014-12-20-12-32" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/20/waveform_2014-12-20-18-29" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/25/waveform_2014-12-20-18-41" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3.5/waveform_2014-12-20-13-28" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3/waveform_2014-12-20-12-55" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/30/waveform_2014-12-20-18-56" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/35/waveform_2014-12-20-19-15" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4.5/waveform_2014-12-20-13-52" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4/waveform_2014-12-20-13-39" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/40/waveform_2014-12-20-20-30" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5.5/waveform_2014-12-20-14-25" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5/waveform_2014-12-20-14-04" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/50/waveform_2014-12-20-20-41" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6.5/waveform_2014-12-20-15-00" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6/waveform_2014-12-20-14-48" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/60/waveform_2014-12-20-20-53" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7.5/waveform_2014-12-20-15-29" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7/waveform_2014-12-20-15-12" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70/waveform_2014-12-20-10-41" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70_0/waveform_2014-12-20-10-26" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8.5/waveform_2014-12-20-16-30" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8/waveform_2014-12-20-16-17" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9.5/waveform_2014-12-20-16-52" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9/waveform_2014-12-20-16-41" \
)

ENCBINFILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/0.5/encoder_2009-12-31-20-20-28" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1.5/encoder_2009-12-31-20-38-37" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/1/encoder_2009-12-31-20-26-56" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/10/encoder_2010-01-01-02-04-37" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/11/encoder_2010-01-01-02-21-42" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/12/encoder_2010-01-01-02-32-37" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/13/encoder_2010-01-01-02-32-37" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/13/encoder_2010-01-01-02-35-24" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/14/encoder_2010-01-01-02-47-47" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/15/encoder_2010-01-01-03-03-14" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2.5/encoder_2009-12-31-21-41-07" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/2/encoder_2009-12-31-21-29-53" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/20/encoder_2010-01-01-03-15-17" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/25/encoder_2010-01-01-03-26-54" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3.5/encoder_2009-12-31-22-26-29" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/3/encoder_2009-12-31-21-53-28" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/30/encoder_2010-01-01-03-41-41" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/35/encoder_2010-01-01-04-01-36" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4.5/encoder_2009-12-31-22-49-38" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/4/encoder_2009-12-31-22-37-56" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/40/encoder_2010-01-01-05-22-14" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5.5/encoder_2009-12-31-23-17-51" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/5/encoder_2009-12-31-23-01-52" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/50/encoder_2010-01-01-05-34-05" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6.5/encoder_2009-12-31-23-51-41" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/6/encoder_2009-12-31-23-40-15" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/60/encoder_2010-01-01-05-45-25" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7.5/encoder_2010-01-01-00-20-49" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/7/encoder_2010-01-01-00-04-23" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70/encoder_2009-12-31-19-39-31" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/70_0/encoder_2009-12-31-19-24-09" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8.5/encoder_2010-01-01-01-28-40" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/8/encoder_2010-01-01-01-15-17" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9.5/encoder_2010-01-01-01-50-41" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/cal-nsf-uml-20141220/9/encoder_2010-01-01-01-39-26" \
)

DWELENGDIR="/usr3/graduate/zhanli86/Programs/misc/dwel-engineer/AutomatedTools-20140922"

# convert waveform binary to hdf5
python $DWELENGDIR/Binary2HDF5.app/binaryproc.py ${WFBINFILES[$SGE_TASK_ID-1]}

# convert encoder binary to hdf5
python $DWELENGDIR/Encoder2HDF5.app/angleproc.py ${ENCBINFILES[$SGE_TASK_ID-1]}

# combine the waveform and encoder hdf5 files
python $DWELENGDIR/Combine.app/combine_noshow.py ${WFBINFILES[$SGE_TASK_ID-1]}.hdf5 ${ENCBINFILES[$SGE_TASK_ID-1]}.hdf5