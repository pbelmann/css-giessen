#!/bin/bash

# script to download the Mini-Kraken database to /vol/scratch"

echo "Start downloading and extracting database..."
mkdir -p /vol/scratch/kraken_db
wget -qO- https://openstack.cebitec.uni-bielefeld.de:8080/swift/v1/eMed/krakendb/minikraken.tgz | tar xzv --strip 1  -C  /vol/scratch/kraken_db
echo "done downloading and extracting database."
