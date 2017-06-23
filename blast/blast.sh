#!/bin/bash


if [ x = ${1}x -o y = ${2}y -o z = ${3}z ]; then
	echo "usage : ${0} <sequencedir> <dbdir> <resultdir> <prefix>" 1>&2
	exit 1;
fi

mkdir -p ${1}/results

docker run -v ${1}:/input -v ${2}:/data  -v ${3}:/output biocontainers/blast blastp -query /input/${3}.${SGE_TASK_ID} -db zebrafish.1.protein.faa -out /output/result.txt.${SGE_TASK_ID}
