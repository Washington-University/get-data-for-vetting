#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
DESTINATION="/home/shared/HCP/TimB/DiffusionRepolVetting"

source ../xnat_pbs_jobs/GetHcpDataUtils/GetHcpDataUtils.sh

project="HCP_900"
subjects=""
subjects+=" 100206 "

mkdir -p ${DESTINATION}

for subject in ${subjects} ; do

	cd ${DESTINATION}
	mkdir -p ${subject}

	rsync -av ${DATABASE_ARCHIVE_ROOT}/${project}/arc001/${subject}_3T/RESOURCES/Diffusion_preproc_repol/ ${DESTINATION}/${subject}

	chmod 777 ${DESTINATION}/${subject}
	pushd ${DESTINATION}/${subject}
	chmod -R 777 *
	popd
done

