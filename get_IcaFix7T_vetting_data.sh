#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
DESTINATION_ROOT="/home/shared/NRG/hcp_shared/IcaFix7T"

project="HCP_Staging_7T"

subject_list=""
subject_list+=" 102311"

mkdir -p ${DESTINATION_ROOT}

for subject in ${subject_list} ; do

	session="${subject}_7T"

	mkdir -p ${DESTINATION_ROOT}/${subject}

	subject_resources_dir=${DATABASE_ARCHIVE_ROOT}/${project}/arc001/${session}/RESOURCES

	func_preproc_dirs=`ls -d ${subject_resources_dir}/{r,t}fMRI_{REST,MOVIE}*_preproc`
	echo " "
	echo "func_preproc_dirs: ${func_preproc_dirs}"
	echo " "

	for func_preproc_dir in ${func_preproc_dirs} ; do
		echo "func_preproc_dir: ${func_preproc_dir}"
		dest_dir=${DESTINATION_ROOT}/${subject}
		echo "dest_dir: ${dest_dir}"
		mkdir --parents ${dest_dir}

		copy_from="${func_preproc_dir}/*"
		copy_to="${dest_dir}"

		rsync_cmd="rsync -auv ${copy_from} ${copy_to}"
		echo "rsync_cmd: ${rsync_cmd}"
		${rsync_cmd}
	done

	fix_resource_dirs=`ls -d ${subject_resources_dir}/*FIX`

	echo " "
	echo "fix_resource_dirs: ${fix_resource_dirs}"
	echo " "

	for fix_resource_dir in ${fix_resource_dirs} ; do
		echo "fix_resource_dir: ${fix_resource_dir}"
		dest_dir=${DESTINATION_ROOT}/${subject}/MNINonLinear/Results
		echo "dest_dir: ${dest_dir}"
		mkdir --parents ${dest_dir}
		
		copy_from="${fix_resource_dir}/*"
		copy_to="${dest_dir}"

		rsync_cmd="rsync -auv ${copy_from} ${copy_to}"
		echo "rsync_cmd: ${rsync_cmd}"
		${rsync_cmd}
	done

done

find ${DESTINATION_ROOT} -name "*catalog.xml" -delete
find ${DESTINATION_ROOT} -name "*.starttime" -delete

chmod 777 ${DESTINATION_ROOT}
pushd ${DESTINATION_ROOT}
chmod -R 777 *
popd
