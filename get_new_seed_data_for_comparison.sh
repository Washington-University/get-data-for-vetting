#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
PROJECT="HCP_Staging"
DESTINATION_ROOT="/home/shared/NRG/hcp_shared/seedchange7"

subject_list=""
subject_list+=" 120010 " # 1
subject_list+=" 189652 " # 2
subject_list+=" 202820 " # 3
subject_list+=" 204218 " # 4
subject_list+=" 385046 " # 5
subject_list+=" 462139 " # 6
subject_list+=" 469961 " # 7
subject_list+=" 723141 " # 8
subject_list+=" 943862 " # 9

# get new structurally preprocessed data (with different random number generator seeds)

for subject in ${subject_list} ; do

	echo ""
	echo "----- Getting new data for subject: ${subject} -----"
	echo ""

	pushd ${DATABASE_ARCHIVE_ROOT}/${PROJECT}/arc001/${subject}_3T/RESOURCES
	seed_dirs=`ls -1d Structural_preproc_*`

	echo "seed_dirs: ${seed_dirs}"

	for seed_dir in ${seed_dirs} ; do

		echo ""
		echo "----- Getting data from: ${seed_dir} -----"
		echo ""

		#seed=${seed_dir##*_Seed}
		#echo "seed: ${seed}"

		destination=${DESTINATION_ROOT}/${subject}/${seed_dir}/${subject}

		mkdir -p ${destination}

		rsync -av \
			${DATABASE_ARCHIVE_ROOT}/${PROJECT}/arc001/${subject}_3T/RESOURCES/${seed_dir}/ \
			${destination}

		# rm -f ${destination}/*.out
		# rm -f ${destination}/*.starttime
		# rm -f ${destination}/*.xml
		# rm -f ${destination}/*.log
		# rm -f ${destination}/*.stderr
		# rm -f ${destination}/*.stdout
		# rm -f ${destination}/*.sh

		chmod 777 ${destination}
		pushd ${destination}
		chmod -R 777 *
		popd

	done

	popd

	chmod 777 ${DESTINATION_ROOT}
	pushd ${DESTINATION_ROOT}
	chmod -R 777 *
	popd

done

