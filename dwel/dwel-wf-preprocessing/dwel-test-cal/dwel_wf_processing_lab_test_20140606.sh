#!/bin/bash
#$ -pe omp 4
#$ -l mem_total=8
#$ -l h_rt=24:00:00
#$ -N dwel-wf-processing-lab-test-20140606
#$ -V
#$ -m ae
#$ -t 1-2

HDF5FILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/NSF_DWEL_testscan/waveform_2014-06-06-14-54.hdf5" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/NSF_DWEL_testscan/waveform_2014-06-06-14-54.hdf5" \
)

CONFIGFILES=( \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/config_2010-01-05-09-42-00.cfg" \
"/projectnb/echidna/lidar/Data_DWEL_TestCal/config_2010-01-05-09-42-00.cfg" \
)

CUBEFILES=( \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/NSF-DWEL-Test-201406/waveform_2014-06-06-14-54_1064_cube.img" \
"/projectnb/echidna/lidar/DWEL_Processing/DWEL_TestCal/NSF-DWEL-Test-201406/waveform_2014-06-06-14-54_1548_cube.img" \
)

WL=( \
  1548 \
  1064 \
)

WLLABEL=( \
  1064 \
  1548 \
)

INSHEIGHTS=( \
  1 \
  1 \
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
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel2cube_cmd_nsf, '${HDF5FILES[$SGE_TASK_ID-1]}', '${CONFIGFILES[$SGE_TASK_ID-1]}', '${CUBEFILES[$SGE_TASK_ID-1]}', ${WL[$SGE_TASK_ID-1]}, ${WLLABEL[$SGE_TASK_ID-1]}, ${INSHEIGHTS[$SGE_TASK_ID-1]}, 2.5, 2.0, err_flag"

FILENAME=${CUBEFILES[$SGE_TASK_ID-1]}
# FILENAME=${CUBEFILES[0]}
BASEFILENAME=${FILENAME:0:${#FILENAME}-4}

EXTENSION="ancillary.img"
ANCFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="ancillary_at_project.img"
ANCATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_anc2at_nsf, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_anc2at_nsf, '$ANCFILENAME', '$ANCATPROJFILENAME', 180, 2.0, 0, err_flag"

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
EXTENSION="bsfix_pxc.img"
PULSEXCFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_swop_pulse_xc_nsf, inbsfixfile, inbsfixancfile, outxcfile, zen_tweak, ierr
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_swop_pulse_xc_nsf, '$BSFIXFILENAME', '$BSFIXANCFILENAME', '$PULSEXCFILENAME', 0, err_flag, /wire"

EXTENSION="bsfix_pxc_update.img"
XCUPDATEFILENAME=${BASEFILENAME}_${EXTENSION}
EXTENSION="bsfix_pxc_update_ancillary.img"
XCUPDATEANCFILENAME=${BASEFILENAME}_${EXTENSION}
OUTRES=2
EXTENSION="bsfix_pxc_update_atp"$OUTRES".img"
ATPROJFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_cube2at_nsf, DWEL_Cube_File, DWEL_Anc_File, DWEL_AT_File, Max_Zenith_Angle, output_resolution, zen_tweak, err, Overlap=overlap
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_cube2at_nsf, '$XCUPDATEFILENAME', '$XCUPDATEANCFILENAME', '$ATPROJFILENAME', 117, $OUTRES, 0, err_flag, Overlap=1.0"
EXTENSION="bsfix_pxc_update_atp"$OUTRES"_extrainfo.img"
ATANCFILENAME=${BASEFILENAME}_${EXTENSION}

SDEVFAC=2
SIEVEFAC=10
EXTENSION="bsfix_pxc_update_atp"$OUTRES"_sdfac"$SDEVFAC"_sievefac"$SIEVEFAC"_ptcl.txt"
PTCLFILENAME=${BASEFILENAME}_${EXTENSION}
# dwel_get_point_cloud, infile, ancfile, outfile, err, Settings=settings
$IDL "envi, /restore_base_save_files & envi_batch_init, /no_status_window & dwel_get_point_cloud, '$ATPROJFILENAME', '$ATANCFILENAME', '$PTCLFILENAME', err_flag, Settings={sdevfac:$SDEVFAC, sievefac:$SIEVEFAC, cal_dat:1}"

wait