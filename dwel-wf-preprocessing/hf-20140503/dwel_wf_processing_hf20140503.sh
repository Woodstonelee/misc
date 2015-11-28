#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=72:00:00
#$ -N dwel-wf-processing-hf20140503
#$ -V
#$ -m ae
#$ -t 1-10

# a switch to decide whether to delete large intermediate files. 
# 1: delete files; other files: keep files
DELINTM=0
if [ $DELINTM -eq 1 ]
then
    echo "will delete intermediate files"
fi

HDF5FILES=( \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/C/waveform_2014-05-03-15-09.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/E/waveform_2014-05-03-16-33.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/N/waveform_2014-05-03-13-55.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/S/waveform_2014-05-03-17-37.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/W/waveform_2014-05-03-12-44.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/C/waveform_2014-05-03-15-09.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/E/waveform_2014-05-03-16-33.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/N/waveform_2014-05-03-13-55.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/S/waveform_2014-05-03-17-37.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/W/waveform_2014-05-03-12-44.hdf5" \
)

CONFIGFILES=( \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/C/config_2014-05-03-06-15-39.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/E/config_2014-05-03-07-39-41.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/N/config_2014-05-03-05-01-41.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/S/config_2014-05-03-08-41-44.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/W/config_2014-05-03-03-51-26.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/C/config_2014-05-03-06-15-39.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/E/config_2014-05-03-07-39-41.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/N/config_2014-05-03-05-01-41.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/S/config_2014-05-03-08-41-44.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0503/DWEL-HDF5/W/config_2014-05-03-03-51-26.cfg" \
)

CUBEFILES=( \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/HFHD20140503-C/HFHD_20140503_C_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/HFHD20140503-E/HFHD_20140503_E_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/HFHD20140503-N/HFHD_20140503_N_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/HFHD20140503-S/HFHD_20140503_S_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/HFHD20140503-W/HFHD_20140503_W_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/HFHD20140503-C/HFHD_20140503_C_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/HFHD20140503-E/HFHD_20140503_E_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/HFHD20140503-N/HFHD_20140503_N_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/HFHD20140503-S/HFHD_20140503_S_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140503/HFHD20140503-W/HFHD_20140503_W_1548_cube.img" \
)

WL=( \
  1548 1548 1548 1548 1548 \
  1064 1064 1064 1064 1064 \
)

WLLABEL=( \
  1064 1064 1064 1064 1064 \
  1548 1548 1548 1548 1548 \
)

INSHEIGHTS=( \
1.37 1.33 1.24 1.42 1.21 \
1.37 1.33 1.24 1.42 1.21 \
)

# DWELAZN=( \
# 341.61 \
# 137.15 \
# 199.31 \
# 315.74 \
# 41.67 \
# 341.61 \
# 137.15 \
# 199.31 \
# 315.74 \
# 41.67 \
# )

DWELAZN=( \
255.64 \
137.15 \
199.31 \
315.74 \
41.67 \
255.64 \
137.15 \
199.31 \
315.74 \
41.67 \
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
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel2cube_cmd_nsf, '${HDF5FILES[$SGE_TASK_ID-1]}', '${CONFIGFILES[$SGE_TASK_ID-1]}', '${CUBEFILES[$SGE_TASK_ID-1]}', ${WL[$SGE_TASK_ID-1]}, ${WLLABEL[$SGE_TASK_ID-1]}, ${INSHEIGHTS[$SGE_TASK_ID-1]}, 2.5, 2.0, err_flag, nadirshift=187225"

FILENAME=${CUBEFILES[$SGE_TASK_ID-1]}
# FILENAME=${CUBEFILES[0]}
BASEFILENAME=${FILENAME:0:${#FILENAME}-4}

EXTENSION="ancillary.img"
ANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="ancillary_at_project.img"
ANCATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_anc2at_nsf, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2at_nsf, '$ANCFILENAME', '$ANCATPROJFILENAME', 180, 2.0, 0, err_flag"

EXTENSION="ancillary_hs_project.img"
ANCHSPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_anc2hs_nsf, DWEL_Anc_File, DWEL_HS_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2hs_nsf, '$ANCFILENAME', '$ANCHSPROJFILENAME', 180, 2.0, 0, err_flag"

EXTENSION="bsfix.img"
BSFIXFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_baseline_sat_fix_cmd_nsf, DWELCubeFile, ancillaryfile_name, out_satfix_name, Casing_Range, get_info_stats, zen_tweak, err
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_baseline_sat_fix_cmd_nsf, '${CUBEFILES[$SGE_TASK_ID-1]}', '$ANCFILENAME', '$BSFIXFILENAME', [175, 180], 'lam', 1, 0, err_flag, /wire, settings={out_of_pulse:500}"

EXTENSION="bsfix_ancillary.img"
BSFIXANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc.img"
PULSEXCFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_swop_pulse_xc_nsf, inbsfixfile, inbsfixancfile, outxcfile, zen_tweak, ierr
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_swop_pulse_xc_nsf, '$BSFIXFILENAME', '$BSFIXANCFILENAME', '$PULSEXCFILENAME', 0, err_flag, /wire"

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
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_cube2at_nsf, '$XCUPDATEFILENAME', '$XCUPDATEANCFILENAME', '$ATPROJFILENAME', 117, $OUTRES, 0, err_flag, Overlap=1.0"

if [ $DELINTM -eq 1 ]
then
    rm -f $XCUPDATEFILENAME
    echo "Delete _pxc_update.img: $XCUPDATEFILENAME"
fi

# CALPAR="[c0, c1, c2, c3, c4, b]"
# if [ ${WLLABEL[$SGE_TASK_ID-1]} -eq 1064 ]
# then
#     CALPAR="[33447.964d0*0.984807753*17.376, 4796.420d0, 0.402d0, 37.056d0, 4796.420d0, 1.587d0]"
# fi

# if [ ${WLLABEL[$SGE_TASK_ID-1]} -eq 1548 ]
# then
#     CALPAR="[39463.981d0*0.984807753*7.391, 11200.689d0, 0.447d0, 37.530d0, 11200.689d0, 1.492d0]"
# fi

# calibration from simultaneous fitting of two wavelengths to minimize rho_app
# error and ndi varianace
if [ ${WLLABEL[$SGE_TASK_ID-1]} -eq 1064 ]
then
    CALPAR="[41814.061908d0*0.984807753*17.376,0.000071d0,0.383203d0,104574.246266d0,1.624433d0]"
fi
if [ ${WLLABEL[$SGE_TASK_ID-1]} -eq 1548 ]
then
    CALPAR="[88357.438795d0*0.984807753*7.3,0.000071d0,0.445864d0,104574.246266d0,1.670920d0]"
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
$IDL "!EXCEPT=2 & envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC, dwel_az_n:${DWELAZN[$SGE_TASK_ID-1]}, save_zero_hits:1, cal_dat:1, cal_par:$CALPAR, r_thresh:$RTHRESH, xmin:$XMIN, xmax:$XMAX, ymin:$YMIN, ymax:$YMAX, zlow:$ZLOW, zhigh:$ZHIGH, save_pfilt:0}"

# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_extrainfo.img"
# ATANCFILENAME=${BASEFILENAME}_${EXTENSION}
# SDEVFAC=2
# SIEVEFAC=2
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC, dwel_az_n:0, save_zero_hits:0, cal_dat:1}"

# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_extrainfo.img"
# ATANCFILENAME=${BASEFILENAME}_${EXTENSION}
# SDEVFAC=2
# SIEVEFAC=2
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_dn_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC, dwel_az_n:0, save_zero_hits:0, cal_dat:0}"

wait
