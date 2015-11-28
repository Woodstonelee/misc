#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=72:00:00
#$ -N dwel-wf-processing-hfhd20150819
#$ -V
#$ -m ae
#$ -t 1-10

# a switch to decide whether to delete large intermediate files. 
# 1: delete files; 0: keep files
DELINTM=1
if [ $DELINTM -eq 1 ]
then
    echo "will delete intermediate files"
fi

HDF5FILES=( \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C/waveform_2015-08-19-10-18.hdf5" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C/waveform_2015-08-19-10-18.hdf5" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-2/waveform_2015-08-19-13-30.hdf5" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-2/waveform_2015-08-19-13-30.hdf5" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-3/waveform_2015-08-19-14-37.hdf5" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-3/waveform_2015-08-19-14-37.hdf5" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-E/waveform_2015-08-19-12-01.hdf5" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-E/waveform_2015-08-19-12-01.hdf5" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-4/waveform_2015-08-19-15-51.hdf5" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-4/waveform_2015-08-19-15-51.hdf5" \
)

CONFIGFILES=( \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C/config_2015-08-19-10-18.cfg" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C/config_2015-08-19-10-18.cfg" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-2/config_2015-08-19-13-29-56.cfg" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-2/config_2015-08-19-13-29-56.cfg" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-3/config_2015-08-19-14-36-22.cfg" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-3/config_2015-08-19-14-36-22.cfg" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-E/config_2015-08-19-12-00-25.cfg" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-E/config_2015-08-19-12-00-25.cfg" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-4/config_2015-08-19-15-50-26.cfg" \
"/projectnb/echidna/lidar/Data_2015HF0818-0821/HFHD20150819-C-4/config_2015-08-19-15-50-26.cfg" \
)

CUBEFILES=( \
"/projectnb/echidna/lidar/DWEL_Processing/HF2015/HFHD20150819/HFHD20150819-C/HFHD_20150819_C_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2015/HFHD20150819/HFHD20150819-C/HFHD_20150819_C_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2015/HFHD20150819/HFHD20150819-C-2/HFHD_20150819_C_2_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2015/HFHD20150819/HFHD20150819-C-2/HFHD_20150819_C_2_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2015/HFHD20150819/HFHD20150819-C-3/HFHD_20150819_C_3_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2015/HFHD20150819/HFHD20150819-C-3/HFHD_20150819_C_3_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2015/HFHD20150819/HFHD20150819-E/HFHD_20150819_E_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2015/HFHD20150819/HFHD20150819-E/HFHD_20150819_E_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2015/HFHD20150819/HFHD20150819-C-4/HFHD_20150819_C_4_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2015/HFHD20150819/HFHD20150819-C-4/HFHD_20150819_C_4_1548_cube.img" \
)

WL=( \
  1548 1064 \
  1548 1064 \
  1548 1064 \
  1548 1064 \
  1548 1064 \
)

WLLABEL=( \
  1064 1548 \
  1064 1548 \
  1064 1548 \
  1064 1548 \
  1064 1548 \
)

INSHEIGHTS=( \
  1.5 1.5 \
  1.2 1.2 \
  1.2 1.2 \
  1.03 1.03 \
  1.2 1.2 \
)

DWELAZN=( \
 0.0 0.0 \
 0.0 0.0 \
 0.0 0.0 \
 0.0 0.0 \
 0.0 0.0 \
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
$IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel2cube_cmd_nsf, '${HDF5FILES[$SGE_TASK_ID-1]}', '${CONFIGFILES[$SGE_TASK_ID-1]}', '${CUBEFILES[$SGE_TASK_ID-1]}', ${WL[$SGE_TASK_ID-1]}, ${WLLABEL[$SGE_TASK_ID-1]}, ${INSHEIGHTS[$SGE_TASK_ID-1]}, 2.5, 2.0, err_flag"

FILENAME=${CUBEFILES[$SGE_TASK_ID-1]}
# FILENAME=${CUBEFILES[0]}
BASEFILENAME=${FILENAME:0:${#FILENAME}-4}

EXTENSION="ancillary.img"
ANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="ancillary_at_project.img"
ANCATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_anc2at_nsf, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
$IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2at_nsf, '$ANCFILENAME', '$ANCATPROJFILENAME', 180, 2.0, 0, err_flag"

EXTENSION="ancillary_hs_project.img"
ANCHSPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_anc2hs_nsf, DWEL_Anc_File, DWEL_HS_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2hs_nsf, '$ANCFILENAME', '$ANCHSPROJFILENAME', 180, 2.0, 0, err_flag"

EXTENSION="bsfix.img"
BSFIXFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_baseline_sat_fix_cmd_nsf, DWELCubeFile, ancillaryfile_name, out_satfix_name, Casing_Range, get_info_stats, zen_tweak, err
$IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_baseline_sat_fix_cmd_nsf, '${CUBEFILES[$SGE_TASK_ID-1]}', '$ANCFILENAME', '$BSFIXFILENAME', [175, 180], 'lam', 1, 0, err_flag, settings={out_of_pulse:400}"

EXTENSION="bsfix_ancillary.img"
BSFIXANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc.img"
PULSEXCFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_swop_pulse_xc_nsf, inbsfixfile, inbsfixancfile, outxcfile, zen_tweak, ierr
$IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_swop_pulse_xc_nsf, '$BSFIXFILENAME', '$BSFIXANCFILENAME', '$PULSEXCFILENAME', 0, err_flag"

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
$IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_cube2at_nsf, '$XCUPDATEFILENAME', '$XCUPDATEANCFILENAME', '$ATPROJFILENAME', 117, $OUTRES, 0, err_flag"

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
$IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC, dwel_az_n:${DWELAZN[$SGE_TASK_ID-1]}, save_zero_hits:1, cal_dat:0, cal_par:$CALPAR, r_thresh:$RTHRESH, xmin:$XMIN, xmax:$XMAX, ymin:$YMIN, ymax:$YMAX, zlow:$ZLOW, zhigh:$ZHIGH, save_pfilt:0}"

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
