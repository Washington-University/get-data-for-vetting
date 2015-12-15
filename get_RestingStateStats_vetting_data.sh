#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
DESTINATION="/home/shared/HCP/TimB/RestingStateStatsVetting"

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

mkdir -p ${DESTINATION}

for subject in ${subject_list} ; do
	session="${subject}_3T"

	#get_hcp_struct_preproc_data "${DATABASE_ARCHIVE_ROOT}" "HCP_500" "${subject}" "${session}" "${DESTINATION}"

	for resting_state in rfMRI_REST1 rfMRI_REST2 ; do
		for direction in LR RL ; do
			scan=${resting_state}_${direction}
			get_hcp_resting_state_stats_data "${DATABASE_ARCHIVE_ROOT}" "HCP_500" "${subject}" "${session}" "${scan}" "${DESTINATION}"
		done
	done

done

chmod 777 ${DESTINATION}
pushd ${DESTINATION}
chmod -R 777 *
popd