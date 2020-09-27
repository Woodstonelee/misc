#!/usr/bin/env bash

PROJECT_DIR="$(dirname $(realpath ${0}))/.."
MY_TMPDIR="${PROJECT_DIR}/tmpdata"

# EASE2 projection parameters from https://nsidc.org/data/SPL3SMP/versions/6
ease2_proj="+proj=cea +lon_0=0 +lat_ts=30 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
ullr="-17367530.45 7314540.83 17367530.45 -7314540.83"
# Using one MODIS product file as template to ensure accurate projection
# parameters
sinu_proj="$(gdalinfo -json -proj4 HDF4_EOS:EOS_GRID:"${PROJECT_DIR}/ancdata/MCD43A3.A2020221.h04v10.006.2020230051022.hdf":MOD_Grid_BRDF:BRDF_Albedo_Band_Mandatory_Quality_Band1 | jq -r .coordinateSystem.proj4)"

smap_in_files=($(find "${PROJECT_DIR}/spl3smp" -name "*.h5"))
smap_out_dir="${PROJECT_DIR}/spl3smp-modis-sinu"

read -r -d '' PYCMD <<- EOF
import sys
from osgeo import gdal, gdalconst
gdal.AllRegister()

file = sys.argv[1]
band = int(sys.argv[2])
name = sys.argv[3]
ds = gdal.Open(file, gdalconst.GA_Update)
ds.GetRasterBand(band).SetDescription(name)
ds = None
EOF

for ((i=0; i<${#smap_in_files[@]}; i++)); do
    in_file=${smap_in_files[$i]}
#    out_file="${smap_out_dir}/$(basename ${in_file} ".h5")_modis_sinu.tif"
    cur_outdir=${smap_out_dir}/$(basename ${in_file} ".h5")
    if [[ ! -d ${cur_outdir} ]]; then
        mkdir -p ${cur_outdir}
    fi
   
    subds_arr=($(gdalinfo ${in_file} \
        | grep -E "SUBDATASET_[0-9]*_NAME=HDF5:.*://Soil_Moisture_Retrieval_Data_.*/soil_moisture" \
        | tr -d [:blank:] | cut -d"=" -f2))
    subds_arr=(${subds_arr[@]} $(gdalinfo ${in_file} \
        | grep -E "SUBDATASET_[0-9]*_NAME=HDF5:.*://Soil_Moisture_Retrieval_Data_.*/retrieval_qual_flag" \
        | tr -d [:blank:] | cut -d"=" -f2))
    nds=${#subds_arr[@]}
   
    tmpfile_arr=()
    ds_name_arr=()
    ndv_arr=()
    vmax_arr=()
    vmin_arr=()
    dtype_arr=()
    for ((j=0; j<${#subds_arr[@]}; j++)); do
        ndv=$(gdalinfo -json ${subds_arr[$j]} \
            | jq -r '.bands[].metadata."" | with_entries(if(.key|test(".*_FillValue$")) then ({key:.key, value:.value}) else empty end) | to_entries | .[0].value' \
            | tr -d [:blank:])
        ndv_arr=(${ndv_arr[@]} ${ndv})
        vmax=$(gdalinfo -json ${subds_arr[$j]} \
            | jq -r '.bands[].metadata."" | with_entries(if(.key|test(".*valid_max$")) then ({key:.key, value:.value}) else empty end) | to_entries | .[0].value' \
            | tr -d [:blank:])
        vmax_arr=(${vmax_arr[@]} ${vmax})
        vmin=$(gdalinfo -json ${subds_arr[$j]} \
            | jq -r '.bands[].metadata."" | with_entries(if(.key|test(".*valid_min$")) then ({key:.key, value:.value}) else empty end) | to_entries | .[0].value' \
            | tr -d [:blank:])
        vmin_arr=(${vmin_arr[@]} ${vmin})

        dtype=$(gdalinfo -json ${subds_arr[$j]} | jq -r '.bands[0].type' | tail -n 1)
        dtype_arr=(${dtype_arr[@]} ${dtype})

        ds_name=$(echo ${subds_arr[$j]} | cut -d":" -f2-3 \
            | sed 's#.h5"://#_#' | tr -d "\"") 
        ds_name="${ds_name%/*}_${ds_name##*/}"
        ds_name="$(basename ${ds_name})"
        tmpfile="${MY_TMPDIR}/${ds_name}.tif"
        if [[ ${ndv} != "null" ]]; then
            ndv_opt="-a_nodata ${ndv}"
        else
            ndv_opt=""
        fi

        gdal_translate -of GTiff -a_ullr ${ullr} -a_srs "${ease2_proj}" \
            ${ndv_opt} \
            ${subds_arr[$j]} "${tmpfile}" 
        tmpfile_arr=(${tmpfile_arr[@]} ${tmpfile})
        ds_name_arr=(${ds_name_arr[@]} ${ds_name})
    done
    
    # Extract the bit 0 value for QA flag of Recommended Quality
    for ((j=$((nds-2)); j<${nds}; j++)); do
        cur_ofile=${tmpfile_arr[$j]/%.tif/_bit0.tif}
        basename ${tmpfile_arr[$j]} ".tif" | grep -q -E ".*pm$" && qa_pm_file=${cur_ofile}
        basename ${tmpfile_arr[$j]} ".tif" | grep -q -E ".*pm$" || qa_am_file=${cur_ofile}
        if [[ ${ndv_arr[$j]} != "null" ]]; then
            ndv_opt="--NoDataValue=${ndv_arr[$j]}"
        else
            ndv_opt=""
        fi
        gdal_calc.py -A ${tmpfile_arr[$j]} \
            --overwrite --format=GTiff --outfile=${cur_ofile} \
            ${ndv_opt} --type=${dtype_arr[$j]} \
            --calc="bitwise_and(A, 1)"
    done

    # Filtering by QA and valid_max and valid_min
    tmpfile_qm_arr=()
    for ((j=0; j<$((nds-2)); j++)); do
        cur_ofile=${tmpfile_arr[$j]/%.tif/_qa_masked.tif}
        basename ${tmpfile_arr[$j]} ".tif" | grep -q -E ".*pm$" && qa_file=${qa_pm_file}
        basename ${tmpfile_arr[$j]} ".tif" | grep -q -E ".*pm$" || qa_file=${qa_am_file}
        gdal_calc.py -A ${tmpfile_arr[$j]} -B ${qa_file} \
            --overwrite --format=GTiff --outfile=${cur_ofile} \
            --NoDataValue=${ndv_arr[$j]} --type=${dtype_arr[$j]} \
            --calc="((B==0)*(A>=${vmin_arr[$j]})*(A<=${vmax_arr[$j]}))*A+(1-(B==0)*(A>=${vmin_arr[$j]})*(A<=${vmax_arr[$j]}))*${ndv_arr[$j]}"
        tmpfile_qm_arr=(${tmpfile_qm_arr[@]} ${cur_ofile})
    done

    for ((j=0; j<${#tmpfile_qm_arr[@]}; j++)); do
        tmpfile=$(mktemp -p ${MY_TMPDIR} --suffix ".tif")
        # Here we align with AMSR2's Sinusoidal grids
        gdalwarp -overwrite -of GTiff \
            -t_srs "${sinu_proj}" -tr 15000 15000 \
            -r bilinear \
            ${tmpfile_qm_arr[$j]} ${tmpfile}
        gdalwarp -overwrite -of GTiff \
            -r bilinear \
            -te -20015109.016 -10002445.662 20004890.984 10007554.338 \
            ${tmpfile} "${cur_outdir}/$(basename ${tmpfile_qm_arr[$j]})"
        rm -f ${tmpfile}
    done

    for ((j=0; j<${#tmpfile_arr[@]}; j++)); do
        rm -f ${tmpfile_arr[$j]}* 
    done
    for ((j=0; j<${#tmpfile_qm_arr[@]}; j++)); do
        rm -f ${tmpfile_qm_arr[$j]}* 
    done
    rm -f ${qa_am_file} ${qa_pm_file}
done
