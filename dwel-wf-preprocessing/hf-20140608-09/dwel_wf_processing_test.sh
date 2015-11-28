#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=72:00:00
#$ -N dwel-wf-processing-hf20140608-09
#$ -V
#$ -m ae
#$ -t 11

# a switch to decide whether to delete large intermediate files. 
# 1: delete files; 0: keep files
DELINTM=0
if [ $DELINTM -eq 1 ]
then
    echo "will delete intermediate files"
fi

HDF5FILES=( \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/C/waveform_2014-06-08-12-21.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/E/waveform_2014-06-08-15-07.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/N/waveform_2014-06-08-13-39.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/S/waveform_2014-06-08-16-15.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/W/waveform_2014-06-08-11-10.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/C/waveform_2014-06-09-10-34.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/E/waveform_2014-06-09-14-20.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/N/waveform_2014-06-09-09-28.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/S/waveform_2014-06-09-11-51.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/W/waveform_2014-06-09-13-07.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/C/waveform_2014-06-08-12-21.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/E/waveform_2014-06-08-15-07.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/N/waveform_2014-06-08-13-39.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/S/waveform_2014-06-08-16-15.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/W/waveform_2014-06-08-11-10.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/C/waveform_2014-06-09-10-34.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/E/waveform_2014-06-09-14-20.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/N/waveform_2014-06-09-09-28.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/S/waveform_2014-06-09-11-51.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/W/waveform_2014-06-09-13-07.hdf5" \
)

CONFIGFILES=( \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/C/config_2010-01-10-05-48-16.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/E/config_2010-01-10-08-33-35.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/N/config_2010-01-10-07-06-28.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/S/config_2010-01-10-09-42-06.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/W/config_2010-01-10-04-36-52.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/C/config_2010-01-11-04-00-29.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/E/config_2010-01-11-07-46-27.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/N/config_2010-01-11-02-52-57.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/S/config_2010-01-11-05-18-24.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/W/config_2010-01-11-06-32-54.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/C/config_2010-01-10-05-48-16.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/E/config_2010-01-10-08-33-35.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/N/config_2010-01-10-07-06-28.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/S/config_2010-01-10-09-42-06.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June8HFHardwood/W/config_2010-01-10-04-36-52.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/C/config_2010-01-11-04-00-29.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/E/config_2010-01-11-07-46-27.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/N/config_2010-01-11-02-52-57.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/S/config_2010-01-11-05-18-24.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0608-0609/DWEL-HDF5/June9HFHemlock/W/config_2010-01-11-06-32-54.cfg" \
)

CUBEFILES=( \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/C/HFHD_20140608_C_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/E/HFHD_20140608_E_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/N/HFHD_20140608_N_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/S/HFHD_20140608_S_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/W/HFHD_20140608_W_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/C/HFHM_20140609_C_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/E/HFHM_20140609_E_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/N/HFHM_20140609_N_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/S/HFHM_20140609_S_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/W/HFHM_20140609_W_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/C/HFHD_20140608_C_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/E/HFHD_20140608_E_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/N/HFHD_20140608_N_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/S/HFHD_20140608_S_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140608/W/HFHD_20140608_W_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/C/HFHM_20140609_C_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/E/HFHM_20140609_E_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/N/HFHM_20140609_N_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/S/HFHM_20140609_S_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140609/W/HFHM_20140609_W_1548_cube.img" \
)

WL=( \
  1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 \
  1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 \
)

WLLABEL=( \
  1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 \
  1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 \
)

INSHEIGHTS=( \
 1.33 1.42 1.37 1.37 1.30 \
 1.335 1.44 1.35 1.38 1.435 \
 1.33 1.42 1.37 1.37 1.30 \
 1.335 1.44 1.35 1.38 1.435 \ 
)

DWELAZN=( \
333.48 \
76.02 \
358.44 \
199.2 \
323.64 \
260.22 \
73.73 \
34 \
9.85 \
180.77 \
333.48 \
76.02 \
358.44 \
199.2 \
323.64 \
260.22 \
73.73 \
34 \
9.85 \
180.77 \
)

module purge
module load envi/4.8

# give the path to your idl .pro files
# IDL_PATH=~/Programs/DWEL2.0

# cd $IDL_PATH

# use which idl to find the path to your current idl
# explicitly give a preference file to IDL startup option
#PREF='/usr3/graduate/zhanli86/Programs/DWEL2.0/dwel2.0_idl.pref'
IDL="/project/earth/packages/itt-4.8/bin/idl -quiet -e"

# add the path to your program to the IDL environment variable
# $IDL "PREF_SET, 'IDL_PATH', '$IDL_PATH:<IDL_DEFAULT>', /COMMIT"

# dwel2cube_cmd_nsf, DWEL_H5File, Config_File, DataCube_File, Wavelength, Wavelength_Label, DWEL_Height, beam_div, srate, err_flag, nadirshift=nadirelevshift
# $IDL "!EXCEPT=1 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel2cube_cmd_nsf, '${HDF5FILES[$SGE_TASK_ID-1]}', '${CONFIGFILES[$SGE_TASK_ID-1]}', '${CUBEFILES[$SGE_TASK_ID-1]}', ${WL[$SGE_TASK_ID-1]}, ${WLLABEL[$SGE_TASK_ID-1]}, ${INSHEIGHTS[$SGE_TASK_ID-1]}, 2.5, 2.0, err_flag"

FILENAME=${CUBEFILES[$SGE_TASK_ID-1]}
# FILENAME=${CUBEFILES[0]}
BASEFILENAME=${FILENAME:0:${#FILENAME}-4}

EXTENSION="ancillary.img"
ANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="ancillary_at_project.img"
ANCATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_anc2at_nsf, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "!EXCEPT=1 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2at_nsf, '$ANCFILENAME', '$ANCATPROJFILENAME', 180, 2.0, 0, err_flag"

EXTENSION="ancillary_hs_project.img"
ANCHSPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_anc2hs_nsf, DWEL_Anc_File, DWEL_HS_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2hs_nsf, '$ANCFILENAME', '$ANCHSPROJFILENAME', 180, 2.0, 0, err_flag"

EXTENSION="bsfix.img"
BSFIXFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_baseline_sat_fix_cmd_nsf, DWELCubeFile, ancillaryfile_name, out_satfix_name, Casing_Range, get_info_stats, zen_tweak, err
$IDL "!EXCEPT=1 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_baseline_sat_fix_cmd_nsf, '${CUBEFILES[$SGE_TASK_ID-1]}', '$ANCFILENAME', '$BSFIXFILENAME', [175, 180], 'lam', 1, 0, err_flag, /wire, settings={out_of_pulse:200}"

EXTENSION="bsfix_ancillary.img"
BSFIXANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc.img"
PULSEXCFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_swop_pulse_xc_nsf, inbsfixfile, inbsfixancfile, outxcfile, zen_tweak, ierr
$IDL "!EXCEPT=1 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_swop_pulse_xc_nsf, '$BSFIXFILENAME', '$BSFIXANCFILENAME', '$PULSEXCFILENAME', 0, err_flag, /wire"

if [ $DELINTM -eq 1 ]
then
    rm -f $BSFIXFILENAME
    echo "Delete _bsfix.img: $BSFIXFILENAME"
    rm -f $PULSEXCFILENAME
    echo "Delete _pxc.img: $PULSEXCFILENAME"
fi

# project bsfix cube (before pxc)
OUTRES=2
EXTENSION="bsfix_atp"$OUTRES".img"
BSFIXATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
$IDL "!EXCEPT=1 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_cube2at_nsf, '$BSFIXFILENAME', '$BSFIXANCFILENAME', '$BSFIXATPROJFILENAME', 117, $OUTRES, 0, err_flag, Overlap=1.0"

EXTENSION="bsfix_pxc_update.img"
XCUPDATEFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc_update_ancillary.img"
XCUPDATEANCFILENAME=${BASEFILENAME}_${EXTENSION}
OUTRES=2
EXTENSION="bsfix_pxc_update_atp"$OUTRES".img"
ATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_cube2at_nsf, DWEL_Cube_File, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "!EXCEPT=1 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_cube2at_nsf, '$XCUPDATEFILENAME', '$XCUPDATEANCFILENAME', '$ATPROJFILENAME', 117, $OUTRES, 0, err_flag, Overlap=1.0"

if [ $DELINTM -eq 1 ]
then
    rm -f $XCUPDATEFILENAME
    echo "Delete _pxc_update.img: $XCUPDATEFILENAME"
fi

# calibration from simultaneous fitting of two wavelengths to minimize rho_app
# error and ndi varianace
if [ ${WLLABEL[$SGE_TASK_ID-1]} -eq 1064 ]
then
    CALPAR="[5788.265818d0*0.984807753*6.583,0.000319d0,0.808880d0,25176.835032d0,1.384297d0]"
fi
if [ ${WLLABEL[$SGE_TASK_ID-1]} -eq 1548 ]
then
    CALPAR="[22054.218342d0*0.984807753*5.064,0.000319d0,0.540762d0,25176.835032d0,1.585985d0]"
fi

EXTENSION="bsfix_pxc_update_atp"$OUTRES"_extrainfo.img"
ATANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc_update_atp"$OUTRES"_ptcl.txt"
PTCLFILENAME=${BASEFILENAME}_${EXTENSION}

# parameter settings for point cloud generation
SDEVFAC=2
SIEVEFAC=2
RTHRESH=0.4
XMIN=-100.0
XMAX=100.0
YMIN=-100.0
YMAX=100.0
ZLOW=-5.0
ZHIGH=40.0

# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}

# dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "!EXCEPT=1 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC, dwel_az_n:${DWELAZN[$SGE_TASK_ID-1]}, save_zero_hits:1, cal_dat:1, cal_par:$CALPAR, r_thresh:$RTHRESH, xmin:$XMIN, xmax:$XMAX, ymin:$YMIN, ymax:$YMAX, zlow:$ZLOW, zhigh:$ZHIGH, save_pfilt:0}"

wait
