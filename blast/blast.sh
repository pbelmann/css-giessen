#!/bin/bash


if [ x = ${1}x -o y = ${2}y -o z = ${3}z ]; then
	echo "usage : ${0} <datadir> <dbdir> <prefix>" 1>&2
	exit 1;
fi

mkdir -p ${1}/results

docker run -v ${1}:/data -v ${2}:/db biocontainers/blast blastp -query ${4}.${SGE_TASK_ID} -db /db/zebrafish.1.protein.faa -out results/result.txt.${SGE_TASK_ID}
