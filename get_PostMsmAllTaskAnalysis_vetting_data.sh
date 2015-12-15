#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
DESTINATION="/home/shared/HCP/TimB/PostMsmAllTaskAnalysisVetting"

source ../xnat_pbs_jobs/GetHcpDataUtils/GetHcpDataUtils.sh

subject_list=""
subject_list+=" 100307 "
subject_list+=" 111716 "
subject_list+=" 114924 "
subject_list+=" 120212 "
subject_list+=" 128632 "
subject_list+=" 130922 "
subject_list+=" 136833 "
subject_list+=" 153429 "

mkdir -p ${DESTINATION}

for subject in ${subject_list} ; do
	session="${subject}_3T"

	get_hcp_struct_preproc_data "${DATABASE_ARCHIVE_ROOT}" "HCP_500" "${subject}" "${session}" "${DESTINATION}"

	get_hcp_resampled_and_dedrifted_data "${DATABASE_ARCHIVE_ROOT}" "HCP_500" "${subject}" "${session}" "${DESTINATION}"

	for task in EMOTION GAMBLING LANGUAGE MOTOR RELATIONAL SOCIAL WM ; do
		scan=tfMRI_${task}
		get_hcp_post_msmall_task_analysis_data "${DATABASE_ARCHIVE_ROOT}" "HCP_500" "${subject}" "${session}" "${scan}" "${DESTINATION}"
	done
	
done

chmod 777 ${DESTINATION}
pushd ${DESTINATION}
chmod -R 777 *
popd