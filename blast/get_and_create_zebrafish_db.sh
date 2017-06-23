#!/bin/bash
SWIFT_CSS=https://s3.computational.bio.uni-giessen.de/swift/v1/CSS
if [ x = ${1}x ]; then
	echo "usage : $0 <targetdir>" 1>&2
	exit 1
fi

if [ ! -d ${1} ]; then
	mkdir -p ${1}
fi
cd ${1}
curl ${SWIFT_CSS}/zebrafish.1.protein.faa.gz > zebrafish.1.protein.faa.gz
gunzip zebrafish.1.protein.faa.gz
docker run -v ${1}:/data biocontainers/blast makeblastdb -in zebrafish.1.protein.faa -dbtype prot
