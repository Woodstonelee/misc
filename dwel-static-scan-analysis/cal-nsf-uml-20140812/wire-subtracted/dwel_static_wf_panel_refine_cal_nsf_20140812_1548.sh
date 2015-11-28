#!/bin/bash
# #$ -pe omp 4
#$ -l mem_total=2
#$ -l h_rt=24:00:00
#$ -N dwel-wf-cal-nsf-20140812-1548
#$ -V
#$ -m ae
#$ -t 1-33

HDF5FILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/0.5/waveform_2014-08-12-16-12.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/1.5/waveform_2014-08-12-16-07.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/1/waveform_2014-08-12-16-09.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/10/waveform_2014-08-12-15-32.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/11/waveform_2014-08-12-15-30.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/12/waveform_2014-08-12-15-28.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/13/waveform_2014-08-12-15-26.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/14/waveform_2014-08-12-15-24.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/15/waveform_2014-08-12-15-21.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/2.5/waveform_2014-08-12-16-01.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/2/waveform_2014-08-12-16-05.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/20/waveform_2014-08-12-15-19.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/25/waveform_2014-08-12-15-16.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/3.5/waveform_2014-08-12-15-58.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/3/waveform_2014-08-12-16-00.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/30/waveform_2014-08-12-15-14.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/35/waveform_2014-08-12-15-09.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/4.5/waveform_2014-08-12-15-53.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/4/waveform_2014-08-12-15-56.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/40/waveform_2014-08-12-15-05.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/5.5/waveform_2014-08-12-15-49.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/5/waveform_2014-08-12-15-51.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/50/waveform_2014-08-12-15-02.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/6.5/waveform_2014-08-12-15-46.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/6/waveform_2014-08-12-15-48.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/60/waveform_2014-08-12-14-58.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/7.5/waveform_2014-08-12-15-42.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/7/waveform_2014-08-12-15-44.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/70/waveform_2014-08-12-14-53.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/8.5/waveform_2014-08-12-15-38.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/8/waveform_2014-08-12-15-40.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/9.5/waveform_2014-08-12-15-34.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/Calibration_NSFDWEL_20140812/9/waveform_2014-08-12-15-36.hdf5" \
)

CUBEFILES=( \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/0.5/cal_nsf_20140812_0.5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/1.5/cal_nsf_20140812_1.5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/1/cal_nsf_20140812_1_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/10/cal_nsf_20140812_10_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/11/cal_nsf_20140812_11_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/12/cal_nsf_20140812_12_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/13/cal_nsf_20140812_13_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/14/cal_nsf_20140812_14_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/15/cal_nsf_20140812_15_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/2.5/cal_nsf_20140812_2.5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/2/cal_nsf_20140812_2_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/20/cal_nsf_20140812_20_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/25/cal_nsf_20140812_25_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/3.5/cal_nsf_20140812_3.5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/3/cal_nsf_20140812_3_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/30/cal_nsf_20140812_30_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/35/cal_nsf_20140812_35_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/4.5/cal_nsf_20140812_4.5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/4/cal_nsf_20140812_4_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/40/cal_nsf_20140812_40_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/5.5/cal_nsf_20140812_5.5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/5/cal_nsf_20140812_5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/50/cal_nsf_20140812_50_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/6.5/cal_nsf_20140812_6.5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/6/cal_nsf_20140812_6_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/60/cal_nsf_20140812_60_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/7.5/cal_nsf_20140812_7.5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/7/cal_nsf_20140812_7_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/70/cal_nsf_20140812_70_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/8.5/cal_nsf_20140812_8.5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/8/cal_nsf_20140812_8_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/9.5/cal_nsf_20140812_9.5_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/9/cal_nsf_20140812_9_1548_cube.img" \
)

RANGES=( \
  0.5 \
  1.5 \
  1 \
  10 \
  11 \
  12 \
  13 \
  14 \
  15 \
  2.5 \
  2 \
  20 \
  25 \
  3.5 \
  3 \
  30 \
  35 \
  4.5 \
  4 \
  40 \
  5.5 \
  5 \
  50 \
  6.5 \
  6 \
  60 \
  7.5 \
  7 \
  70 \
  8.5 \
  8 \
  9.5 \
  9 \
)

module purge
module load envi/4.8

IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"

FILENAME=${CUBEFILES[$SGE_TASK_ID-1]}
# FILENAME=${CUBEFILES[0]}
BASEFILENAME=${FILENAME:0:${#FILENAME}-4}

# # $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_static_hdf2cube, '${HDF5FILES[$SGE_TASK_ID-1]}', '$FILENAME', 1064, 1548, 0.0, 2.5, 2.0"

# EXTENSION="ancillary.img"
# ANCFILENAME=${BASEFILENAME}_${EXTENSION}
# EXTENSION="bsfix.img"
# BSFIXFILENAME=${BASEFILENAME}_${EXTENSION}
# # $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_static_wire_baseline_sat_fix_cmd_nsf, '$FILENAME', '$ANCFILENAME', '$BSFIXFILENAME', 1, 0, err_flag"

# EXTENSION="bsfix_ancillary.img"
# BSFIXANCFILENAME=${BASEFILENAME}_${EXTENSION}
# EXTENSION="bsfix_pxc.img"
# PULSEXCFILENAME=${BASEFILENAME}_${EXTENSION}
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_static_swop_pulse_xc_nsf, '$BSFIXFILENAME', '$BSFIXANCFILENAME', '$PULSEXCFILENAME', 0, err_flag, target_range=${RANGES[$SGE_TASK_ID-1]}"

# EXTENSION="bsfix_pxc_update.img"
# XCUPDATEFILENAME=${BASEFILENAME}_${EXTENSION}
# EXTENSION="bsfix_pxc_update_ancillary.img"
# XCUPDATEANCFILENAME=${BASEFILENAME}_${EXTENSION}
# EXTENSION="bsfix_pxc_update_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$XCUPDATEFILENAME', '$XCUPDATEANCFILENAME', '$PTCLFILENAME', err_flag"

# clean point cloud from DWEL program and summarize panel returns
# path to the Matlab scripts and functions
BASEDIR='/usr3/graduate/zhanli86/Programs/misc/dwel-static-scan-analysis/wire-subtracted'
ML="/usr/local/bin/matlab -nodisplay -nojvm -singleCompThread -r "

EXTENSION="bsfix_pxc_update_ancillary.img"
XCUPDATEANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc_update_ptcl_points.txt"
POINTSFILENAME=${BASEFILENAME}_${EXTENSION}
ONLYFILENAME=$(echo $BASEFILENAME | sed 's:/[^ ]*/::g')
EXTENSION="bsfix_pxc_update_ptcl_points_panel_returns_refined.txt"
PANELFILENAME=${ONLYFILENAME}_${EXTENSION}
EXTENSION="_bsfix_pxc_update_ptcl_points_panel_returns_refined.txt"
OLDPANELFILENAME=${ONLYFILENAME}${EXTENSION}
$ML "inptclfile = '$POINTSFILENAME'; outpanelreturnsfile = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-wire-removed-panel-returns-summary/cal-nsf-20140812-wire-removed-panel-returns-refined-summary/$PANELFILENAME'; satinfofile = '$XCUPDATEANCFILENAME'; panelrange = ${RANGES[$SGE_TASK_ID-1]}; oldpanelreturnsfile = '/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/cal-nsf-20140812/cal-nsf-20140812-panel-returns-summary/cal-nsf-20140812-panel-return-refined/$OLDPANELFILENAME'; run('$BASEDIR/dwel_ptcl_to_panel_returns.m')"

wait