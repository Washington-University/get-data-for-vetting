#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
DESTINATION="/home/shared/HCP/TimB/PostFixVetting"

source ../xnat_pbs_jobs/GetHcpDataUtils/GetHcpDataUtils.sh

subjects=""
subjects+=" 100307 "
subjects+=" 100408 "
subjects+=" 101006 "
subjects+=" 101107 "
subjects+=" 101309 "
#subjects+=" 101410 "
subjects+=" 101915 "
subjects+=" 102008 "
subjects+=" 102311 "
subjects+=" 102816 "

mkdir -p ${DESTINATION}

for subject in ${subjects} ; do

	get_hcp_struct_preproc_data "/data/hcpdb/archive" "HCP_500" "${subject}" "${subject}_3T" "${DESTINATION}"

	scans=""
	scans+="rfMRI_REST1_LR "
	scans+="rfMRI_REST1_RL "
	scans+="rfMRI_REST2_LR "
	scans+="rfMRI_REST2_RL "

	for scan in ${scans} ; do
		
		get_hcp_func_preproc_data "/data/hcpdb/archive" "HCP_500" "${subject}" "${subject}_3T" "${scan}" "${DESTINATION}"
		
		get_hcp_fix_proc_data "/data/hcpdb/archive" "HCP_500" "${subject}" "${subject}_3T" "${scan}" "${DESTINATION}"
		
		get_hcp_postfix_data "/data/hcpdb/archive" "HCP_500" "${subject}" "${subject}_3T" "${scan}" "${DESTINATION}"
		
	done

done

chmod 777 ${DESTINATION}
pushd ${DESTINATION}
chmod -R 777 *
popd
