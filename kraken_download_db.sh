#!/bin/bash

# script to download the Mini-Kraken database to /vol/scratch"

echo "Start downloading and extracting database..."
mkdir -p /vol/scratch/kraken_db
wget -qO- https://ccb.jhu.edu/software/kraken/dl/minikraken.tgz | tar xzv --strip 1  -C  /vol/scratch/kraken_db
echo "done downloading and extracting database."
