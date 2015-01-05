#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=72:00:00
#$ -N dwel-wf-processing-hf20140919-20
#$ -V
#$ -m ae
#$ -t 1-22

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
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel2cube_cmd_nsf, '${HDF5FILES[$SGE_TASK_ID-1]}', '${CONFIGFILES[$SGE_TASK_ID-1]}', '${CUBEFILES[$SGE_TASK_ID-1]}', ${WL[$SGE_TASK_ID-1]}, ${WLLABEL[$SGE_TASK_ID-1]}, ${INSHEIGHTS[$SGE_TASK_ID-1]}, 2.5, 2.0, err_flag"

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
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_baseline_sat_fix_cmd_nsf, '${CUBEFILES[$SGE_TASK_ID-1]}', '$ANCFILENAME', '$BSFIXFILENAME', [175, 180], 1, 0, err_flag, /wire"

EXTENSION="bsfix_ancillary.img"
BSFIXANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pulsexc.img"
PULSEXCFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_swop_pulse_xc_nsf, inbsfixfile, inbsfixancfile, outxcfile, zen_tweak, ierr
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_swop_pulse_xc_nsf, '$BSFIXFILENAME', '$BSFIXANCFILENAME', '$PULSEXCFILENAME', 0, err_flag, /wire"

EXTENSION="bsfix_pulsexc_update.img"
XCUPDATEFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pulsexc_update_ancillary.img"
XCUPDATEANCFILENAME=${BASEFILENAME}_${EXTENSION}
OUTRES=2
EXTENSION="bsfix_pxc_update_atp"$OUTRES".img"
ATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_cube2at_nsf, DWEL_Cube_File, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_cube2at_nsf, '$XCUPDATEFILENAME', '$XCUPDATEANCFILENAME', '$ATPROJFILENAME', 117, $OUTRES, 0, err_flag, Overlap=1.0"
EXTENSION="bsfix_pxc_update_atp"$OUTRES"_extrainfo.img"
ATANCFILENAME=${BASEFILENAME}_${EXTENSION}
# SDEVFAC=2
# SIEVEFAC=2
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC}"
# SDEVFAC=2
# SIEVEFAC=6
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC}"
# SDEVFAC=2
# SIEVEFAC=8
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC}"
SDEVFAC=2
SIEVEFAC=10
EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC, cal_dat:1}"

# EXTENSION="bsfix_pulsexc_update.img"
# XCUPDATEFILENAME=${BASEFILENAME}_${EXTENSION}
# EXTENSION="bsfix_pulsexc_update_ancillary.img"
# XCUPDATEANCFILENAME=${BASEFILENAME}_${EXTENSION}
# OUTRES=4
# EXTENSION="bsfix_pxc_update_atp"$OUTRES".img"
# ATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_cube2at_nsf, DWEL_Cube_File, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# # $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_cube2at_nsf, '$XCUPDATEFILENAME', '$XCUPDATEANCFILENAME', '$ATPROJFILENAME', 117, $OUTRES, 0, err_flag, Overlap=1.0"
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_extrainfo.img"
# ATANCFILENAME=${BASEFILENAME}_${EXTENSION}
# SDEVFAC=2
# SIEVEFAC=2
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC}"
# SDEVFAC=2
# SIEVEFAC=6
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC}"
# SDEVFAC=2
# SIEVEFAC=8
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC}"
# SDEVFAC=2
# SIEVEFAC=10
# EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC}"

# EXTENSION="bsfix_pxc_update_atp4_extrainfo.img"
# ATANCFILENAME=${BASEFILENAME}_${EXTENSION}
# EXTENSION="bsfix_pxc_update_atp4_ptcl.txt"
# PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# # dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
# $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag"

# # EXTENSION="bsfix_pulsexc_update_ancillary_atp4.img"
# # ANCATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# # # dwel_anc2at_nsf, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# # $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2at_nsf, '$XCUPDATEANCFILENAME', '$ANCATPROJFILENAME', 117, 4.0, 0, err_flag"

# # EXTENSION="bsfix_pulsexc_update_ancillary_hsp4.img"
# # ANCHSPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# # # dwel_anc2hs_nsf, DWEL_Anc_File, DWEL_HS_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
# # $IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2hs_nsf, '$XCUPDATEANCFILENAME', '$ANCHSPROJFILENAME', 117, 4.0, 0, err_flag"

wait