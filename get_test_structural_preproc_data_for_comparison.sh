#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
PROJECT="HCP_Staging"
DESTINATION_ROOT="/home/shared/NRG/hcp_shared/seedchange6"

subject_list=""
#subject_list+=" 116423 " #  1
subject_list+=" 127226 " #  2
#subject_list+=" 130114 " #  3
#subject_list+=" 143830 " #  4 
#subject_list+=" 169040 " #  5 
#subject_list+=" 185038 " #  6
#subject_list+=" 329844 " #  7
#subject_list+=" 401422 " #  8
#subject_list+=" 688569 " #  9
#subject_list+=" 908860 " # 10
#subject_list+=" 971160 " # 11

# get test structurally preprocessed data

for subject in ${subject_list} ; do

	echo ""
	echo "----- Getting test data for subject: ${subject} -----"
	echo ""


	for test_no in 1 2 3 4 5 ; do

		from_dir=${DATABASE_ARCHIVE_ROOT}/${PROJECT}/arc001/${subject}_3T/RESOURCES/Structural_preproc_test${test_no}
		to_dir=${DESTINATION_ROOT}/${subject}/test${test_no}/${subject}

		mkdir -p ${to_dir}
		
		rsync -av ${from_dir}/ ${to_dir}

		pushd ${to_dir}
		mv *.stderr ..
		mv *.stdout ..
		mv *.sh ..
		mv *.xml ..
		mv *.out ..
		mv *.starttime ..
		mv *.log ..
		popd

	done

done

pushd ${DESTINATION_ROOT}
chmod -R 777 *
popd

chmod 777 ${DESTINATION_ROOT}