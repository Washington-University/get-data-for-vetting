#!/bin/bash

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"
BUILD_DIR_ROOT="/data/hcpdb/build_ssd/chpc/BUILD"
PROJECT="HCP_Staging"

DESTINATION_ROOT="/home/shared/NRG/hcp_shared/seedchange2"

DESTINATION_ORIG="${DESTINATION_ROOT}/orig"

subject_list=""
subject_list+=" 116423 "
subject_list+=" 127226 "
subject_list+=" 130114 "
subject_list+=" 130518 "
subject_list+=" 143830 " # 5
subject_list+=" 169040 "
subject_list+=" 185038 "
subject_list+=" 199554 "
subject_list+=" 329844 "
subject_list+=" 384448 " # 10
subject_list+=" 401422 "
subject_list+=" 688569 "
subject_list+=" 908860 "
subject_list+=" 959069 "
subject_list+=" 971160 " # 15

seed_list=""
seed_list+=" 4567 "
seed_list+=" 5678 "


# get original structurally preprocessed data

mkdir -p ${DESTINATION_ORIG}

for subject in ${subject_list} ; do

	echo ""
	echo "----- Getting original data for subject: ${subject} -----"
	echo ""
	mkdir -p ${DESTINATION_ORIG}/${subject}

	echo ""
	echo "     ----- Getting original MNINonLinear data for subject: ${subject} -----"
	echo ""
	rsync -av \
		${DATABASE_ARCHIVE_ROOT}/${PROJECT}/arc001/${subject}_3T/RESOURCES/Structural_preproc/MNINonLinear \
		${DESTINATION_ORIG}/${subject}

	echo ""
	echo "     ----- Getting original T1w data for subject: ${subject} -----"
	echo ""
	rsync -av \
		${DATABASE_ARCHIVE_ROOT}/${PROJECT}/arc001/${subject}_3T/RESOURCES/Structural_preproc/T1w \
		${DESTINATION_ORIG}/${subject}
		
	echo ""
	echo "     ----- Getting original T2w data for subject: ${subject} -----"
	echo ""
	rsync -av \
		${DATABASE_ARCHIVE_ROOT}/${PROJECT}/arc001/${subject}_3T/RESOURCES/Structural_preproc/T2w \
		${DESTINATION_ORIG}/${subject}
done

chmod 777 ${DESTINATION_ORIG}
pushd ${DESTINATION_ORIG}
chmod -R 777 *
popd

# get new structurally preprocessed data (with different random number generator seeds)

for subject in ${subject_list} ; do

	echo ""
	echo "----- Getting new data for subject: ${subject} -----"
	echo ""

	for seed in ${seed_list} ; do

		echo ""
		echo "----- Getting data for rng seed: ${seed} -----"
		echo ""
		destination_new=${DESTINATION_ROOT}/seed${seed}
		mkdir -p ${destination_new}
		
		rsync -av \
			${BUILD_DIR_ROOT}/${PROJECT}/StructuralPreprocHCP.Seed${seed}.${subject}/${subject} \
			${destination_new}

		chmod 777 ${destination_new}
		pushd ${destination_new}
		chmod -R 777 *
		popd
		
	done

done



