#!/bin/bash

# Extracts a subset of the Gutenberg files, based on a checksum competition, and then cleans them up using cleanup.sh
# Note that cleanup.sh is guaranteed to make some modification to every file, which has the side-effect of randomising the resulting hashes

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SRC=$1
DST=$2
NUM=$3

for code in zho spa ar hin por ben rus jpn lah jav kor deu fra tel mar tur urd vie tam ita fas msa; do
  ${DIR}/../checksum_competition.sh ${SRC}/${code} ${DST}/${code} ${NUM}
  for file in ${DST}/${code}/*.txt; do ${DIR}/cleanup.sh ${file}; done
done
