#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
DESTINATION="/home/shared/NRG/hcp_shared/Diffusion7TVetting"

#source ../xnat_pbs_jobs/GetHcpDataUtils/GetHcpDataUtils.sh

project="HCP_Staging_7T"

subjects=""
subjects+=" 102311 "

mkdir -p ${DESTINATION}

for subject in ${subjects} ; do

	cd ${DESTINATION}
	mkdir -p ${subject}

	rsync -av ${DATABASE_ARCHIVE_ROOT}/${project}/arc001/${subject}_7T/RESOURCES/Diffusion_preproc/ ${DESTINATION}/${subject}

	chmod 777 ${DESTINATION}/${subject}
	pushd ${DESTINATION}/${subject}
	chmod -R 777 *
	popd
done

