#!/bin/bash

SCRATCHDIR=/vol/scratch/kraken
SPOOLDIR=/vol/spool/kraken

mkdir -p $SCRATCHDIR

mkdir -p $SPOOLDIR

if [ $# -ne 2 ]
  then
    echo
    echo "Usage: kraken_pipeline.sh INFILE OUTNAME"
    echo
    echo "Reportfile will be written to $SPOOLDIR/OUTNAME.report"
    echo
    exit 0;
fi

INFILE=$1
OUTNAME=$2

OUTFILE="${SPOOLDIR}/${OUTNAME}.out"

cd $SCRATCHDIRA

## Download Fastq File
echo "Downloading FASTQ File to $SCRATCHDIR..."
wget -qO- "https://openstack.cebitec.uni-bielefeld.de:8080/swift/v1/eMed/${INFILE}" | tar xjO | cat > $OUTFILE

cd ${SPOOLDIR}

#OUTFILE="${SPOOLDIR}/${OUTNAME}.out"
REPORTFILE="${SPOOLDIR}/${OUTNAME}.report"

## run kraken
echo "running kraken:"
docker run -v "/vol/scratch:/vol/scratch"  -v "/vol/spool:/vol/spool" --entrypoint="/usr/local/bin/kraken" quay.io/biocontainers/kraken:1.0--pl5.22.0_0  kraken --db /vol/scratch/kraken_db  --fastq-input $OUTFILE  --output $REPORTFILE
