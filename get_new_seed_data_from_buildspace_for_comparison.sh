#!/bin/bash


BUILD_DIR_ROOT="/data/hcpdb/build_ssd/chpc/BUILD"
PROJECT="HCP_Staging"

SOURCE_ROOT="${BUILD_DIR_ROOT}/${PROJECT}"
DESTINATION_ROOT="/home/shared/NRG/hcp_shared/seedchange3"

subject_list=""
subject_list+=" 127226 " #  1
subject_list+=" 130114 " #  2
subject_list+=" 143830 " #  3 
subject_list+=" 169040 " #  4
subject_list+=" 185038 " #  5
subject_list+=" 329844 " #  6
#subject_list+=" 401422 " #  7
subject_list+=" 908860 " #  8
subject_list+=" 971160 " #  9
subject_list+=" 688569 " #  10, 11, 12
subject_list+=" 116423 " #  13, 14, 15, 16, 17, 18

for subject in ${subject_list} ; do
	#echo "Working on subject: ${subject}"

	struct_preproc_source_dirs=`ls -d ${SOURCE_ROOT}/StructuralPreprocHCP.${subject}*`

	for source_dir in ${struct_preproc_source_dirs} ; do
		#echo "Getting data from source directory: ${source_dir}"

		seed=${source_dir##*Seed}
		seed=${seed%%.*}
		#echo "seed: ${seed}"

		brainsize=${source_dir##*Brainsize}
		brainsize=${brainsize%%.*}
		if [[ "${brainsize:0:1}" == "/" ]]; then
			brainsize=""
		fi
		#echo "brainsize: ${brainsize}"

		destination_dir="${DESTINATION_ROOT}/${subject}/"

		if [ ! -z "${seed}" ]; then
			destination_dir+="seed${seed}"
			if [ ! -z "${brainsize}" ]; then
				destination_dir+="_brainsize${brainsize}"
			fi
		else
			if [ ! -z "${brainsize}" ]; then
				destination_dir+="brainsize${brainsize}"
			fi
		fi

		seed_print=${seed}
		if [ -z "${seed_print}" ]; then 
			seed_print="   "
		fi

		brainsize_print=${brainsize}
		if [ -z "${brainsize_print}" ]; then 
			brainsize_print="   "
		fi

		echo "subject: ${subject}; seed: ${seed_print}; brainsize: ${brainsize_print}; destination_dir: ${destination_dir}"

		mkdir -p ${destination_dir}

		rsync -av \
			${source_dir}/ \
			${destination_dir}

		chmod 777 ${destination_dir}
		pushd ${destination_dir}
		chmod -R 777 *
		popd

	done

done

pushd ${DESTINATION_ROOT}
chmod 777 *
popd
