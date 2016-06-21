#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
DESTINATION="/home/shared/NRG/hcp_shared/IcaFix7T" # yes, this is adding data to a set of ICAFIX 7T results
PROJECT="HCP_Staging_7T"

source ../xnat_pbs_jobs/GetHcpDataUtils/GetHcpDataUtils.sh

subject_list=""
subject_list+=" 102311 "

mkdir --parents --verbose ${DESTINATION}

for subject in ${subject_list} ; do

	from_dir=${DATABASE_ARCHIVE_ROOT}/${PROJECT}/arc001/${subject}_7T/RESOURCES/MSMAllDeDrift_HighRes/MNINonLinear
	to_dir=${DESTINATION}/${subject}/MNINonLinear
	rsync -av ${from_dir}/* ${to_dir}

	from_dir=${DATABASE_ARCHIVE_ROOT}/${PROJECT}/arc001/${subject}_7T/RESOURCES/MSMAllDeDrift_HighRes/T1w
	to_dir=${DESTINATION}/${subject}/T1w
	rsync -av ${from_dir}/* ${to_dir}
done

chmod 777 ${DESTINATION}
pushd ${DESTINATION}
chmod -R 777 *
popd
