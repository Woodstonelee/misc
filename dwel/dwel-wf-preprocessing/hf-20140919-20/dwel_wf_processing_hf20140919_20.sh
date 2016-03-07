#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=72:00:00
#$ -N dwel-wf-processing-hf20140919-20
#$ -V
#$ -m ae
#$ -t 1-22

# a switch to decide whether to delete large intermediate files. 
# 1: delete files; 0: keep files
DELINTM=0
if [ $DELINTM -eq 1 ]
then
    echo "will delete intermediate files"
fi

HDF5FILES=( \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-C/waveform_2014-09-19-13-16.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-E/waveform_2014-09-19-16-49.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-N/waveform_2014-09-19-15-10.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-S/waveform_2014-09-19-17-52.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-W/waveform_2014-09-19-10-53.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-C4/waveform_2014-09-20-14-15.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-E/waveform_2014-09-20-17-51.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-N/waveform_2014-09-20-16-32.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-S/waveform_2014-09-20-10-13.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-S2/waveform_2014-09-20-11-16.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-W/waveform_2014-09-20-15-23.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-C/waveform_2014-09-19-13-16.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-E/waveform_2014-09-19-16-49.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-N/waveform_2014-09-19-15-10.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-S/waveform_2014-09-19-17-52.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-W/waveform_2014-09-19-10-53.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-C4/waveform_2014-09-20-14-15.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-E/waveform_2014-09-20-17-51.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-N/waveform_2014-09-20-16-32.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-S/waveform_2014-09-20-10-13.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-S2/waveform_2014-09-20-11-16.hdf5" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-W/waveform_2014-09-20-15-23.hdf5" \
)

CONFIGFILES=( \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-C/config_2010-01-11-20-21-08.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-E/config_2010-01-11-23-54-00.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-N/config_2010-01-11-22-14-58.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-S/config_2010-01-12-00-57-10.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-W/config_2010-01-11-11-39-57.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-C4/config_2010-01-12-21-19-28.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-E/config_2010-01-13-00-56-11.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-N/config_2010-01-12-23-37-29.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-S/config_2010-01-12-17-18-36.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-S2/config_2010-01-12-18-20-44.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-W/config_2010-01-12-22-28-19.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-C/config_2010-01-11-20-21-08.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-E/config_2010-01-11-23-54-00.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-N/config_2010-01-11-22-14-58.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-S/config_2010-01-12-00-57-10.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHD20140919/HFHD20140919-W/config_2010-01-11-11-39-57.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-C4/config_2010-01-12-21-19-28.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-E/config_2010-01-13-00-56-11.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-N/config_2010-01-12-23-37-29.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-S/config_2010-01-12-17-18-36.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-S2/config_2010-01-12-18-20-44.cfg" \
  "/projectnb/echidna/lidar/Data_2014HF0919-1003/DWEL/HFHM20140920/HFHM20140920-W/config_2010-01-12-22-28-19.cfg" \
)

CUBEFILES=( \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140919/HFHD_20140919_C/HFHD_20140919_C_1064_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140919/HFHD_20140919_E/HFHD_20140919_E_1064_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140919/HFHD_20140919_N/HFHD_20140919_N_1064_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140919/HFHD_20140919_S/HFHD_20140919_S_1064_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140919/HFHD_20140919_W/HFHD_20140919_W_1064_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_C/HFHM_20140920_C_1064_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_E/HFHM_20140920_E_1064_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_N/HFHM_20140920_N_1064_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_S/HFHM_20140920_S_1064_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_S2/HFHM_20140920_S2_1064_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_W/HFHM_20140920_W_1064_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140919/HFHD_20140919_C/HFHD_20140919_C_1548_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140919/HFHD_20140919_E/HFHD_20140919_E_1548_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140919/HFHD_20140919_N/HFHD_20140919_N_1548_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140919/HFHD_20140919_S/HFHD_20140919_S_1548_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140919/HFHD_20140919_W/HFHD_20140919_W_1548_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_C/HFHM_20140920_C_1548_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_E/HFHM_20140920_E_1548_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_N/HFHM_20140920_N_1548_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_S/HFHM_20140920_S_1548_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_S2/HFHM_20140920_S2_1548_cube.img" \
  "/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hemlock20140920/HFHM_20140920_W/HFHM_20140920_W_1548_cube.img" \
)

WL=( \
  1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 \
  1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 \
)

WLLABEL=( \
  1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 1064 \
  1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 1548 \
)

INSHEIGHTS=( \
  1.30 1.40 1.10 1.12 1.36 \
  1.26 1.21 1.17 1.12 1.12 1.21 \
  1.30 1.40 1.10 1.12 1.36 \
  1.26 1.21 1.17 1.12 1.12 1.21 \
)

DWELAZN=( \
55.41 \
173.9 \
250.71 \
226.44 \
259.76 \
182.83 \
23.35 \
42.36 \
160.96 \
298.57 \
213.97 \
55.41 \
173.9 \
250.71 \
226.44 \
259.76 \
182.83 \
23.35 \
42.36 \
160.96 \
298.57 \
213.97 \
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
# $IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel2cube_cmd_nsf, '${HDF5FILES[$SGE_TASK_ID-1]}', '${CONFIGFILES[$SGE_TASK_ID-1]}', '${CUBEFILES[$SGE_TASK_ID-1]}', ${WL[$SGE_TASK_ID-1]}, ${WLLABEL[$SGE_TASK_ID-1]}, ${INSHEIGHTS[$SGE_TASK_ID-1]}, 2.5, 2.0, err_flag"

FILENAME=${CUBEFILES[$SGE_TASK_ID-1]}
# FILENAME=${CUBEFILES[0]}
BASEFILENAME=${FILENAME:0:${#FILENAME}-4}

EXTENSION="ancillary.img"
ANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="ancillary_at_project.img"
ANCATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_anc2at_nsf, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2at_nsf, '$ANCFILENAME', '$ANCATPROJFILENAME', 180, 2.0, 0, err_flag"

EXTENSION="ancillary_hs_project.img"
ANCHSPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_anc2hs_nsf, DWEL_Anc_File, DWEL_HS_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2hs_nsf, '$ANCFILENAME', '$ANCHSPROJFILENAME', 180, 2.0, 0, err_flag"

EXTENSION="bsfix.img"
BSFIXFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_baseline_sat_fix_cmd_nsf, DWELCubeFile, ancillaryfile_name, out_satfix_name, Casing_Range, get_info_stats, zen_tweak, err
# $IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_baseline_sat_fix_cmd_nsf, '${CUBEFILES[$SGE_TASK_ID-1]}', '$ANCFILENAME', '$BSFIXFILENAME', [175, 180], 'lam', 1, 0, err_flag, /wire, settings={out_of_pulse:400}"

EXTENSION="bsfix_ancillary.img"
BSFIXANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc.img"
PULSEXCFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_swop_pulse_xc_nsf, inbsfixfile, inbsfixancfile, outxcfile, zen_tweak, ierr
# $IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_swop_pulse_xc_nsf, '$BSFIXFILENAME', '$BSFIXANCFILENAME', '$PULSEXCFILENAME', 0, err_flag, /wire"

if [ $DELINTM -eq 1 ]
then
    rm -f $BSFIXFILENAME
    echo "Delete _bsfix.img: $BSFIXFILENAME"
    rm -f $PULSEXCFILENAME
    echo "Delete _pxc.img: $PULSEXCFILENAME"
fi

EXTENSION="bsfix_pxc_update.img"
XCUPDATEFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc_update_ancillary.img"
XCUPDATEANCFILENAME=${BASEFILENAME}_${EXTENSION}
OUTRES=2
EXTENSION="bsfix_pxc_update_atp"$OUTRES".img"
ATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_cube2at_nsf, DWEL_Cube_File, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_cube2at_nsf, '$XCUPDATEFILENAME', '$XCUPDATEANCFILENAME', '$ATPROJFILENAME', 117, $OUTRES, 0, err_flag, Overlap=1.0"

# if [ $DELINTM -eq 1 ]
# then
#     rm -f $XCUPDATEFILENAME
#     echo "Delete _pxc_update.img: $XCUPDATEFILENAME"
# fi

# calibration, v20150103, before wire offset correction
# if [ ${WLLABEL[$SGE_TASK_ID-1]} -eq 1064 ]
# then
#     CALPAR="[5863.906d0*0.984807753*6.583, 3413.743d0, 0.895d0, 15.640d0, 3413.743d0, 1.402d0]"
# fi
# if [ ${WLLABEL[$SGE_TASK_ID-1]} -eq 1548 ]
# then
#     CALPAR="[20543.960d0*0.984807753*5.064, 5.133d0, 0.646d0, 1.114d0, 5.133d0, 1.566d0]"
# fi

# calibration, v20150202, after wire offset correction
# if [ ${WLLABEL[$SGE_TASK_ID-1]} -eq 1064 ]
# then
#     CALPAR="[5084.052d0*0.984807753*6.583, 1198.004d0, 0.899d0, 13.485d0, 1198.004d0, 1.366d0]"
# fi
# if [ ${WLLABEL[$SGE_TASK_ID-1]} -eq 1548 ]
# then
#     CALPAR="[17930.134d0*0.984807753*5.064, 12.316d0, 0.595d0, 4.866d0, 12.316d0, 1.535d0]"
# fi

# CALPAR = "[c0, c1, c2, c3, c4, b]"
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


echo $BASEFILENAME $CALPAR

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
$IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC, dwel_az_n:${DWELAZN[$SGE_TASK_ID-1]}, save_zero_hits:1, cal_dat:1, cal_par:$CALPAR, r_thresh:$RTHRESH, xmin:$XMIN, xmax:$XMAX, ymin:$YMIN, ymax:$YMAX, zlow:$ZLOW, zhigh:$ZHIGH, save_pfilt:0}"

# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_extrainfo.img"
# ATANCFILENAME=${BASEFILENAME}_${EXTENSION}
# SDEVFAC=2
# SIEVEFAC=10
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC, dwel_az_n:${DWELAZN[$SGE_TASK_ID-1]}, save_zero_hits:0, cal_dat:1}"

# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_extrainfo.img"
# ATANCFILENAME=${BASEFILENAME}_${EXTENSION}
# SDEVFAC=2
# SIEVEFAC=10
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_dn_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC, dwel_az_n:${DWELAZN[$SGE_TASK_ID-1]}, save_zero_hits:0, cal_dat:0}"

wait
