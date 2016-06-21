#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
DESTINATION_ROOT="/home/shared/NRG/hcp_shared/AddResolution7T"

subject_list=""
subject_list+=" HCP_500:102311"
subject_list+=" HCP_500:102816"
subject_list+=" HCP_500:105923"
subject_list+=" HCP_500:108323"
subject_list+=" HCP_900:100610"
subject_list+=" HCP_900:104416"
subject_list+=" HCP_900:114823"
subject_list+=" HCP_900:115017"
subject_list+=" HCP_Staging:126426"
subject_list+=" HCP_Staging:130114"
subject_list+=" HCP_Staging:130518"
subject_list+=" HCP_Staging:134627"

mkdir -p ${DESTINATION_ROOT}

for project_subject in ${subject_list} ; do

	project=${project_subject%%:*}
	subject=${project_subject##*:}

	session="${subject}_3T"

	mkdir -p ${DESTINATION_ROOT}/${subject}

	rsync -av \
		${DATABASE_ARCHIVE_ROOT}/${project}/arc001/${session}/RESOURCES/Structural_preproc_supplemental/MNINonLinear \
		${DESTINATION_ROOT}/${subject}

	rsync -av \
		${DATABASE_ARCHIVE_ROOT}/${project}/arc001/${session}/RESOURCES/Structural_preproc_supplemental/T1w \
		${DESTINATION_ROOT}/${subject}

done

chmod 777 ${DESTINATION_ROOT}
pushd ${DESTINATION_ROOT}
chmod -R 777 *
popd
