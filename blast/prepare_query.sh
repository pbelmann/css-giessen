#!/bin/bash

SWIFT_CSS=https://s3.computational.bio.uni-giessen.de/swift/v1/CSS

if [ x != x${1} ]; then
	echo "usage: ${0} <targetdir" 1>2&
       	exit 1
fi;

if [ ! -d  ${1} ]; then
	mkdir -p ${1}
fi

cd ${1}
curl ${SWIFt_CSS}/uniprot_sprot.fasta.gz > uniprot_sprot.fasta.gz
gunzip uniprot_sprot.fasta.gz
/vol/spool/css-giessen/scripts/split_fasta uniprot_sprot.fasta 5000

