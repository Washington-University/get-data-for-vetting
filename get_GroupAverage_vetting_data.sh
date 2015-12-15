#!/bin/bash

SOURCE_ROOT="/data/hcpdb/build_ssd/chpc/BUILD/CrossProject/"
SOURCE="${SOURCE_ROOT}/MakeGroupAverageDataset_1449257528/S900/"

DESTINATION="/home/shared/HCP/TimB/S900"

mkdir --parents --verbose ${DESTINATION}
rsync -rav ${SOURCE} ${DESTINATION}

chmod 777 ${DESTINATION}
pushd ${DESTINATION}
chmod -R 777 *
popd
