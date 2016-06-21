#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
DESTINATION="/home/shared/NRG/hcp_shared/IcaFix7T"

source ../xnat_pbs_jobs/GetHcpDataUtils/GetHcpDataUtils.sh

subjects=""
subjects+=" 102311 "

mkdir -p ${DESTINATION}

for subject in ${subjects} ; do

	get_hcp_struct_preproc_data "/data/hcpdb/archive" "HCP_500" "${subject}" "${subject}_3T" "${DESTINATION}"

	scans=""
	scans+="rfMRI_REST1_PA:rfMRI_REST1_7T_PA "
	scans+="rfMRI_REST2_AP:rfMRI_REST2_7T_AP "
	scans+="rfMRI_REST3_PA:rfMRI_REST3_7T_PA "
	scans+="rfMRI_REST4_AP:rfMRI_REST4_7T_AP "
	scans+="tfMRI_MOVIE1_AP:tfMRI_MOVIE1_7T_AP "
	scans+="tfMRI_MOVIE2_PA:tfMRI_MOVIE2_7T_PA "
	scans+="tfMRI_MOVIE3_PA:tfMRI_MOVIE3_7T_PA "
	#scans+="tfMRI_MOVIE4_AP:tfMRI_MOVIE4_7T_AP "

	for scan_spec in ${scans} ; do
		
		scan=${scan_spec%%:*}
		echo "scan: ${scan}"
		full_scan=${scan_spec##*:}
		echo "full_scan: ${full_scan}"

		rsync_cmd=""
		rsync_cmd+="rsync -av "
		rsync_cmd+=" /data/hcpdb/archive/HCP_Staging_7T/arc001/${subject}_7T/RESOURCES/${scan}_PostFix/MNINonLinear/Results/${full_scan}/*"
		rsync_cmd+=" ${DESTINATION}/${subject}/MNINonLinear/Results/${full_scan}"

		echo "rsync_cmd: ${rsync_cmd}"
		${rsync_cmd}

	done

done

chmod 777 ${DESTINATION}
pushd ${DESTINATION}
chmod -R 777 *
popd
