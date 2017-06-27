#!/bin/bash

SCRATCHDIR=/vol/scratch/kraken
SPOOLDIR=/vol/spool/kraken

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


cd $SCRATCHDIRA

## Download Fastq File
echo "Downloading FASTQ File to $SCRATCHDIR..."


cd ${SPOOLDIR}

OUTFILE="${SPOOLDIR}/${OUTNAME}.out"
REPORTFILE="${SPOOLDIR}/${OUTNAME}.report"

## run kraken
echo "running kraken:"



## create reports
echo "creating Kraken report"

# cleanup
rm -f ${SCRATCHDIR}/${INFILE}

