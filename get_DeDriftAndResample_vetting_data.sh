#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
DESTINATION="/home/shared/HCP/TimB/MSMAllDeDriftAndResample_NEW"

source ../xnat_pbs_jobs/GetHcpDataUtils/GetHcpDataUtils.sh

subject_list=""
subject_list+=" 100307 "
subject_list+=" 111716 "
subject_list+=" 114924 "
subject_list+=" 120212 "
subject_list+=" 128632 "
#subject_list+=" 130922 "
#subject_list+=" 136833 "
#subject_list+=" 153429 "
#subject_list+=" 163432 "
#subject_list+=" 194140 "
#subject_list+=" 198451 "
#subject_list+=" 199150 "
#subject_list+=" 200614 "
#subject_list+=" 205725 "
#subject_list+=" 210617 "
#subject_list+=" 211215 "
#subject_list+=" 285446 "
#subject_list+=" 441939 "
#subject_list+=" 545345 "
#subject_list+=" 559053 "
#subject_list+=" 567052 "
#subject_list+=" 586460 "
#subject_list+=" 627549 "
#subject_list+=" 702133 "
#subject_list+=" 861456 "
#subject_list+=" 887373 "
#subject_list+=" 889579 "
#subject_list+=" 932554 "

mkdir --parents --verbose ${DESTINATION}

# Get group average drift data

get_hcp_msm_group_average_drift_data "${DATABASE_ARCHIVE_ROOT}" "HCP_Staging" "${DESTINATION}"

for subject in ${subject_list} ; do
	session="${subject}_3T"

	get_hcp_struct_preproc_data "${DATABASE_ARCHIVE_ROOT}" "HCP_500" "${subject}" "${session}" "${DESTINATION}"

	scans=""
	scans+="rfMRI_REST1_LR "
	scans+="rfMRI_REST1_RL "
	scans+="rfMRI_REST2_LR "
	scans+="rfMRI_REST2_RL "

	for scan in ${scans} ; do
		
		get_hcp_func_preproc_data "${DATABASE_ARCHIVE_ROOT}" "HCP_500" "${subject}" "${subject}_3T" "${scan}" "${DESTINATION}"
		
		get_hcp_fix_proc_data "${DATABASE_ARCHIVE_ROOT}" "HCP_500" "${subject}" "${subject}_3T" "${scan}" "${DESTINATION}"
		
		get_hcp_postfix_data "${DATABASE_ARCHIVE_ROOT}" "HCP_500" "${subject}" "${subject}_3T" "${scan}" "${DESTINATION}"
		
	done

	get_hcp_msm_all_registration_data "${DATABASE_ARCHIVE_ROOT}" "HCP_500" "${subject}" "${session}" "${DESTINATION}"

	get_hcp_resampled_and_dedrifted_data "${DATABASE_ARCHIVE_ROOT}" "HCP_500" "${subject}" "${session}" "${DESTINATION}"

done

chmod 777 ${DESTINATION}
pushd ${DESTINATION}
chmod -R 777 *

keep_list="${subject_list} DeDriftingGroup"
files=`ls`
for file in ${files} ; do
	if [[ "${keep_list}" == *${file}* ]] ; then
		echo "${file} in keep list"
	else
		rm -rf ${file}
	fi
done

popd
