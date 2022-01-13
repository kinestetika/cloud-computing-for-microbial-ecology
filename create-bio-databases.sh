#!/bin/sh

#################################
#
# Author: Marc Strous
# Copyright (c) Marc Strous
#
#################################

if [ ! -d /bio/databases ]
then
    sudo mkdir /bio/databases
    sudo chmod -R a+wX /bio/databases
fi

cd /bio/databases

#################################
#
# metaamp
#
#################################
VERSION=138_1
NAME="mothur silva database for metaamp"
WWW=https://mothur.org/wiki/silva_reference_files/

echo "Fetching and unpacking $NAME $VERSION"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."

mkdir metaamp
cd metaamp

wget https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.nr_v${VERSION}.tgz
tar -xf silva.nr_v${VERSION}.tgz
rm silva.nr_v${VERSION}.tgz

ln -s silva.nr_v138_1.align silva.nr.fasta
ln -s silva.nr_v138_1.tax silva.nr.tax
ln -s /bio/databases/metaamp /bio/bin/ribosomal/metaamp/bin/database

cd ..

#################################
#
# phyloflash
#
#################################
VERSION=138.1

echo "Setting up database for phyloflash for Silva release ${VERSION}"

mkdir phyloflash
cd phyloflash

source /bio/bin/profile

phyloFlash_makedb.pl --remote

cd ..

export PHYLOFLASH_DBHOME=/bio/databases/phyloflash/${VERSION}

sed -i -e 's/export PHYLOFLASH_DBHOME=\/bio\/databases\/phyloflash\/.+/export PHYLOFLASH_DBHOME=/bio\/databases\/phyloflash\/${VERSION}/' /bio/bin/profile

#################################
#
# gtdbtk
#
#################################
VERSION=release202
NAME="gtdbtk_data"
WWW=https://ecogenomics.github.io/GTDBTk/installing/index.html#gtdb-tk-reference-data

echo "Fetching and unpacking $NAME $VERSION"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."

mkdir gtdbtk
cd gtdbtk

wget "https://data.gtdb.ecogenomic.org/releases/latest/auxillary_files/${NAME}.tar.gz"
tar -xf "${NAME}.tar.gz"
rm "${NAME}.tar.gz"
cd ..

export GTDBTK_DATA_PATH=/bio/databases/gtdbtk/${VERSION}

sed -i -e 's/export GTDBTK_DATA_PATH=\/bio\/databases\/gtdbtk\/.+/export GTDBTK_DATA_PATH=\/bio\/databases\/gtdbtk\/${VERSION}/' /bio/bin/profile

#################################
#
# checkm
#
#################################
VERSION=2015_01_16
NAME="checkm_data_${VERSION}"
WWW=https://github.com/Ecogenomics/CheckM/wiki/Installation#how-to-install-checkm

echo "Fetching and unpacking $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."

mkdir checkm
cd checkm
wget "https://data.ace.uq.edu.au/public/CheckM_databases/${NAME}.tar.gz"
tar -xf "${NAME}.tar.gz"
rm "${NAME}.tar.gz"
cd ..

source /bio/bin/python-env/bin/activate
checkm data setRoot /bio/databases/checkm
deactivate


#################################
#
# virsorter
#
#################################
cd /bio/databases
wget https://osf.io/v46sc/download
tar -xf download
mv db virsorter
source /bio/bin/python-env/bin/activate
virsorter config --init-source --db-dir=./virsorter/
deactivate


