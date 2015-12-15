#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
PROJECT_LIST="HCP_500 HCP_900"
DESTINATION_ROOT="/home/shared/HCP/TimB/RestingMovementData/900subject"

#mkdir --parents --verbose ${DESTINATION}

for project in ${PROJECT_LIST} ; do

	echo -e "Working on project: ${project}"

	project_archive="${DATABASE_ARCHIVE_ROOT}/${project}/arc001"
	session_dir_list=`find ${project_archive} -maxdepth 1 -name "*3T"`

	for session_dir in ${session_dir_list} ; do
		echo -e "\tWorking with session_dir: ${session_dir}"

		subject_session=${session_dir##*/}
		echo -e "\tsubject_session: ${subject_session}"

		subject=${subject_session/_3T/}
		echo -e "\tsubject: ${subject}"

		rest_preproc_resource_list=`find ${session_dir}/RESOURCES -maxdepth 1 -name "rfMRI*preproc"`

		for rest_preproc_resource in ${rest_preproc_resource_list} ; do
			echo -e "\t\tWorking with resource: ${rest_preproc_resource}"

			files=`find ${rest_preproc_resource}/MNINonLinear/Results -name "Movement_RelativeRMS_mean.txt"`

			for file in ${files} ; do
				echo -e "\t\t\tFile: ${file}"

				scan=${file##*MNINonLinear\/Results\/}
				scan=${scan%%/*}

				destination=${DESTINATION_ROOT}/${subject}/MNINonLinear/Results/${scan}
				mkdir --parents ${destination}
				rsync -av ${file} ${destination}

			done

		done

	done

done

chmod 777 ${DESTINATION_ROOT}
pushd ${DESTINATION_ROOT}
chmod -R 777 *
popd
