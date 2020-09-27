#!/usr/bin/env bash

PROJECT_DIR="$(dirname $(realpath ${0}))/.."
MY_TMPDIR="${PROJECT_DIR}/tmpdata"

# Using one MODIS product file as template to ensure accurate projection
# parameters
sinu_proj="$(gdalinfo -json -proj4 HDF4_EOS:EOS_GRID:"${PROJECT_DIR}/ancdata/MCD43A3.A2020221.h04v10.006.2020230051022.hdf":MOD_Grid_BRDF:BRDF_Albedo_Band_Mandatory_Quality_Band1 | jq -r .coordinateSystem.proj4)"

amsr2_in_files=($(find "${PROJECT_DIR}/lprm-amsr2-ds-d-soilm3" \
    -regextype sed -regex '.*[0-9]\{14\}.nc4'))
amsr2_out_dir="${PROJECT_DIR}/lprm-amsr2-ds-d-soilm3-modis-sinu"

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

for ((i=0; i<${#amsr2_in_files[@]}; i++)); do
    in_file=${amsr2_in_files[$i]}
#    out_file="${amsr2_out_dir}/$(basename ${in_file} ".nc4")_modis_sinu.tif"
    cur_outdir=${amsr2_out_dir}/$(basename ${in_file} ".nc4")
    if [[ ! -d ${cur_outdir} ]]; then
        mkdir -p ${cur_outdir}
    fi

    in_t_file=${amsr2_in_files[$i]/'.nc4'/'_transpose.nc4'}
    # ncpdq --ovr -4 -a Latitude,Longitude ${in_file} ${in_t_file}
    in_file=${in_t_file}

    subds_arr=($(gdalinfo ${in_file} \
        | grep -E "SUBDATASET_[0-9]*_NAME=NETCDF:.*:soil_moisture" \
        | tr -d [:blank:] | cut -d"=" -f2))
    subds_arr=(${subds_arr[@]} $(gdalinfo ${in_file} \
        | grep -E "SUBDATASET_[0-9]*_NAME=NETCDF:.*:mask" \
        | tr -d [:blank:] | cut -d"=" -f2))
    nds=${#subds_arr[@]}
    
    tmpfile_arr=()
    ds_name_arr=()
    ndv_arr=()
    dtype_arr=()
    for ((j=0; j<${#subds_arr[@]}; j++)); do
        ndv=$(rio info -b 1 ${subds_arr[$j]} | jq .nodata | tail -n 1)
        ndv_arr=(${ndv_arr[@]} ${ndv})
        dtype=$(gdalinfo -json ${subds_arr[$j]} | jq -r '.bands[0].type' | tail -n 1)
        dtype_arr=(${dtype_arr[@]} ${dtype})

        ds_name=$(echo ${subds_arr[$j]} | cut -d":" -f2-3 \
            | sed 's#.nc4":#_#' | tr -d "\"") 
        ds_name="$(basename ${ds_name})"
        tmpfile="${MY_TMPDIR}/${ds_name}.tif"
        gdal_translate -of GTiff \
            -a_srs "$(gdalinfo ${subds_arr[$j]} | grep SRS | cut -d'=' -f2)" \
            ${subds_arr[$j]} "${tmpfile}" 
        tmpfile_arr=(${tmpfile_arr[@]} ${tmpfile})
        ds_name_arr=(${ds_name_arr[@]} ${ds_name})
    done

    # QA filtering, only use QA==0, best quality
    tmpfile_qm_arr=()
    for ((j=0; j<$((nds-1)); j++)); do
        cur_ofile=${tmpfile_arr[$j]/%.tif/_qa_masked.tif}
        gdal_calc.py -A ${tmpfile_arr[$j]} -B ${tmpfile_arr[$((nds-1))]} \
            --overwrite --format=GTiff --outfile=${cur_ofile} \
            --NoDataValue=${ndv_arr[$j]} --type=${dtype_arr[$j]} \
            --calc="A*(B==0)+${ndv_arr[$j]}*(B!=0)"
        tmpfile_qm_arr=(${tmpfile_qm_arr[@]} ${cur_ofile})
    done

    for ((j=0; j<${#tmpfile_qm_arr[@]}; j++)); do
        gdalwarp -overwrite -of GTiff \
            -t_srs "${sinu_proj}" -tr 15000 15000 \
            -r bilinear \
            ${tmpfile_qm_arr[$j]} "${cur_outdir}/$(basename ${tmpfile_qm_arr[$j]})"
    done
    
    for ((j=0; j<${#tmpfile_arr[@]}; j++)); do
        rm -f ${tmpfile_arr[$j]}* 
    done
    for ((j=0; j<${#tmpfile_qm_arr[@]}; j++)); do
        rm -f ${tmpfile_qm_arr[$j]}* 
    done
done
