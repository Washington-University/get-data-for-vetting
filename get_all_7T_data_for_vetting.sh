#!/bin/bash

set -e

DATABASE_ARCHIVE_ROOT="/data/hcpdb/archive"

PROJECT="HCP_Staging_7T"
TESLA_SPEC="7T"

REF_PROJECT="HCP_500"
REF_TESLA_SPEC="3T"

DESTINATION_ROOT="/home/shared/HCP/TimB/All7T"

mkdir --parents --verbose ${DESTINATION_ROOT}

subject_list=""
subject_list+=" 109123 "

for subject in ${subject_list} ; do
	echo ""
	echo "subject: ${subject}"
	echo ""

	subject_ref_resources_dir=${DATABASE_ARCHIVE_ROOT}/${REF_PROJECT}/arc001/${subject}_${REF_TESLA_SPEC}/RESOURCES
	subject_resources_dir=${DATABASE_ARCHIVE_ROOT}/${PROJECT}/arc001/${subject}_${TESLA_SPEC}/RESOURCES

	# structural unprocessed
    t1_dirs=`ls -1d ${subject_ref_resources_dir}/T1w_MPR*_unproc`
	for t1_dir in ${t1_dirs} ; do
		echo "t1_dir: ${t1_dir}"

		scan_dir=${t1_dir##*/}
		scan_dir=${scan_dir%_unproc}

		dest=${DESTINATION_ROOT}/${subject}/unprocessed/3T/${scan_dir}
		mkdir --parents --verbose ${dest}
		
		rsync -aLv ${t1_dir}/* ${dest}
	done

    t2_dirs=`ls -1d ${subject_ref_resources_dir}/T2w_SPC*_unproc`
	for t2_dir in ${t2_dirs} ; do
		echo "t2_dir: ${t2_dir}"

		scan_dir=${t2_dir##*/}
		scan_dir=${scan_dir%_unproc}

		dest=${DESTINATION_ROOT}/${subject}/unprocessed/3T/${scan_dir}
		mkdir --parents --verbose ${dest}
		
		rsync -aLv ${t2_dir}/* ${dest}
	done

	# structurally preprocessed

	struc_preproc_dirs=`ls -1d ${subject_ref_resources_dir}/Structural_preproc`
	echo "struc_preproc_dirs: ${struc_preproc_dirs}"

	for struct_dir in ${struc_preproc_dirs} ; do
		echo "struct_dir: ${struct_dir}"

		dest=${DESTINATION_ROOT}/${subject}/MNINonLinear
		mkdir --parents --verbose ${dest}
		rsync -aLv ${struct_dir}/MNINonLinear/* ${dest}

		dest=${DESTINATION_ROOT}/${subject}/T1w
		mkdir --parents --verbose ${dest}
		rsync -aLv ${struct_dir}/T1w ${dest}

		dest=${DESTINATION_ROOT}/${subject}/T2w
		mkdir --parents --verbose ${dest}
		rsync -aLv ${struct_dir}/T2w ${dest}
	done

	# supplemental structurally preprocessed

	struc_preproc_dirs=`ls -1d ${subject_ref_resources_dir}/Structural_preproc_supplemental`
	echo "struc_preproc_dirs: ${struc_preproc_dirs}"

	for struct_dir in ${struc_preproc_dirs} ; do
		echo "struct_dir: ${struct_dir}"

		dest=${DESTINATION_ROOT}/${subject}/MNINonLinear
		mkdir --parents --verbose ${dest}
		rsync -aLv ${struct_dir}/MNINonLinear/* ${dest}

		dest=${DESTINATION_ROOT}/${subject}/T1w
		mkdir --parents --verbose ${dest}
		rsync -aLv ${struct_dir}/T1w ${dest}
	done

	# functional unprocessed
	unproc_dirs=`ls -1d ${subject_resources_dir}/*fMRI*_unproc`
	
	for unproc_dir in ${unproc_dirs} ; do
		echo "  unproc_dir: ${unproc_dir}"

		scan_dir=${unproc_dir##*/}
		scan_dir=${scan_dir%_unproc}

		dest=${DESTINATION_ROOT}/${subject}/unprocessed/7T/${scan_dir}
		mkdir --parents --verbose ${dest}

		rsync -aLv ${unproc_dir}/* ${dest}
	done
	
	# functionally preprocessed
	preproc_dirs=`ls -1d ${subject_resources_dir}/*fMRI*_preproc`

	for preproc_dir in ${preproc_dirs} ; do
		echo "  preproc_dir: ${preproc_dir}"

		scan_dir=${preproc_dir##*/}
		scan_dir=${scan_dir%_preproc}

		scan_without_pe_dir=${scan_dir%_*}
		pe_dir=${scan_dir##*_}

		long_scan_name=${scan_without_pe_dir}_7T_${pe_dir}
		echo "  long_scan_name: ${long_scan_name}"

		dest=${DESTINATION_ROOT}/${subject}/MNINonLinear
		mkdir --parents --verbose ${dest}
		rsync -aLv ${preproc_dir}/MNINonLinear/* ${dest}

		dest=${DESTINATION_ROOT}/${subject}/T1w
		mkdir --parents --verbose ${dest}
		rsync -aLv ${preproc_dir}/T1w/* ${dest}

		dest=${DESTINATION_ROOT}/${subject}/${long_scan_name}
		mkdir --parents --verbose ${dest}
		rsync -aLv ${preproc_dir}/${long_scan_name}/* ${dest}

	done
	
	# FIX processed
	fix_dirs=`ls -1d ${subject_resources_dir}/*_FIX`

	for fix_dir in ${fix_dirs} ; do
		echo "  fix_dir: ${fix_dir}"

		scan_dir=${fix_dir##*/}
		scan_dir=${scan_dir%_FIX}

		scan_without_pe_dir=${scan_dir%_*}
		pe_dir=${scan_dir##*_}
		long_scan_name=${scan_without_pe_dir}_7T_${pe_dir}
		echo "  long_scan_name: ${long_scan_name}"

		dest=${DESTINATION_ROOT}/${subject}/MNINonLinear/Results/${long_scan_name}
		mkdir --parents --verbose ${dest} 
		rsync -aLv ${fix_dir}/${long_scan_name}/* ${dest}
	done

	# PostFix
	postfix_dirs=`ls -1d ${subject_resources_dir}/*_PostFix`

	for postfix_dir in ${postfix_dirs} ; do
		echo "  postfix_dir: ${postfix_dir}"

		scan_dir=${postfix_dir##*/}
		scan_dir=${scan_dir%_PostFix}

		scan_without_pe_dir=${scan_dir%_*}
		pe_dir=${scan_dir##*_}
		long_scan_name=${scan_without_pe_dir}_7T_${pe_dir}
		echo "  long_scan_name: ${long_scan_name}"

		dest=${DESTINATION_ROOT}/${subject}/MNINonLinear/Results/${long_scan_name}
		mkdir --parents --verbose ${dest} 
		rsync -aLv ${postfix_dir}/MNINonLinear/Results/${long_scan_name}/* ${dest}
	done

	# "regular" and "high res" DeDrift and Resample
	dedrift_dirs=`ls -1d ${subject_resources_dir}/MSMAllDeDrift*`

	for dedrift_dir in ${dedrift_dirs} ; do
		echo "  dedrift_dir: ${dedrift_dir}"

		dest=${DESTINATION_ROOT}/${subject}/MNINonLinear
		mkdir --parents --verbose ${dest}
		rsync_cmd="rsync -aLv ${dedrift_dir}/MNINonLinear/* ${dest}"
		echo "rsync_cmd: ${rsync_cmd}"
		${rsync_cmd}

		dest=${DESTINATION_ROOT}/${subject}/T1w
		mkdir --parents --verbose ${dest}
		rsync_cmd="rsync -aLv ${dedrift_dir}/T1w/* ${dest}"
		echo "rsync_cmd: ${rsync_cmd}"
		${rsync_cmd}

	done
done

echo "done copying files"
echo "opening up permissions"

chmod 777 ${DESTINATION_ROOT}
pushd ${DESTINATION_ROOT}
chmod -R 777 *
popd
