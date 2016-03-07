#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=72:00:00
#$ -N dwel-wf-processing-hf20140421
#$ -V
#$ -m ae
#$ -t 1-10

# a switch to decide whether to delete large intermediate files. 
# 1: delete files; other values: keep files
DELINTM=0
if [ $DELINTM -eq 1 ]
then
    echo "will delete intermediate files"
fi

HDF5FILES=( \
"/projectnb/echidna/lidar/Data_2014HF0421/center/waveform_2014-04-21-09-59.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0421/east/waveform_2014-04-21-14-34.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0421/north/waveform_2014-04-21-13-21.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0421/south/waveform_2014-04-21-15-54.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0421/west/waveform_2014-04-21-11-15.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0421/center/waveform_2014-04-21-09-59.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0421/east/waveform_2014-04-21-14-34.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0421/north/waveform_2014-04-21-13-21.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0421/south/waveform_2014-04-21-15-54.hdf5" \
"/projectnb/echidna/lidar/Data_2014HF0421/west/waveform_2014-04-21-11-15.hdf5" \
)

CONFIGFILES=( \
"/projectnb/echidna/lidar/Data_2014HF0421/center/config_2014-04-21-10-00-30.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0421/east/config_2014-04-21-14-35-04.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0421/north/config_2014-04-21-13-21-46.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0421/south/config_2014-04-21-15-54-17.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0421/west/config_2014-04-21-11-15-58.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0421/center/config_2014-04-21-10-00-30.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0421/east/config_2014-04-21-14-35-04.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0421/north/config_2014-04-21-13-21-46.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0421/south/config_2014-04-21-15-54-17.cfg" \
"/projectnb/echidna/lidar/Data_2014HF0421/west/config_2014-04-21-11-15-58.cfg" \
)

CUBEFILES=( \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140421/HFHD20140421-C/HFHD_20140421_C_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140421/HFHD20140421-E/HFHD_20140421_E_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140421/HFHD20140421-N/HFHD_20140421_N_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140421/HFHD20140421-S/HFHD_20140421_S_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140421/HFHD20140421-W/HFHD_20140421_W_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140421/HFHD20140421-C/HFHD_20140421_C_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140421/HFHD20140421-E/HFHD_20140421_E_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140421/HFHD20140421-N/HFHD_20140421_N_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140421/HFHD20140421-S/HFHD_20140421_S_1548_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/HF2014/Hardwood20140421/HFHD20140421-W/HFHD_20140421_W_1548_cube.img" \
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
1.32 1.52 1.41 1.39 1.35 \
1.32 1.52 1.41 1.39 1.35 \
)

DWELAZN=( \
31.48 \
297.42 \
165.2 \
233.77 \
339.09 \
31.48 \
297.42 \
165.2 \
233.77 \
339.09 \
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
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel2cube_cmd_nsf, '${HDF5FILES[$SGE_TASK_ID-1]}', '${CONFIGFILES[$SGE_TASK_ID-1]}', '${CUBEFILES[$SGE_TASK_ID-1]}', ${WL[$SGE_TASK_ID-1]}, ${WLLABEL[$SGE_TASK_ID-1]}, ${INSHEIGHTS[$SGE_TASK_ID-1]}, 2.5, 2.0, err_flag, nadirshift=208080"

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

# CALPAR = "[c0, c1, c2, c3, c4, b]"
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
