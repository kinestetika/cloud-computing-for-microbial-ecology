#!/bin/sh

#################################
#
# Author: Marc Strous
# Copyright (c) Marc Strous
#
#################################

#################################
#
# mapping directory
#
#################################

TARGET=mapping
if [ -d "/bio/bin/${TARGET}" ]; then
    echo "Removing existing directory /bio/bin/${TARGET}"
    rm -rf "/bio/bin/${TARGET}/"
fi

echo "Creating directory /bio/bin/${TARGET}"
mkdir "/bio/bin/${TARGET}"
cd "/bio/bin/${TARGET}"

#################################
#
# guppy
#
#################################
VERSION=5.0.14
NAME=ont-guppy_${VERSION}_linux64

echo "################################################################################################"
echo "$NAME needs to be downloaded manually from the Oxford Nanopore community website"
echo "Also note that you need to uncomment a line in /bio/bin/profile to switch between cpu and gpu guppy"
read -p 'To which directory have you downloaded the files (both for gpu and cpu)? ' DOWLOAD_DIR
echo "################################################################################################"

cp ${DOWLOAD_DIR}/ont-guppy* .

for file in *; do 
    if [ -f "$file" ]; then 
        tar -xf "$file"
        rm "$file"
    fi 
done

#################################
#
# bcftools
#
#################################
VERSION=1.13
NAME=bcftools-${VERSION}
WWW=https://www.htslib.org/download/

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/samtools/bcftools/releases/download/${VERSION}/${NAME}.tar.bz2
tar -xf ${NAME}.tar.bz2
cd $NAME
./configure --prefix=/bio/bin/mapping/$NAME
make
make install

cd ..
ln -s $NAME bcftools
rm ${NAME}.tar.bz2

#################################
#
# samtools
#
#################################
VERSION=1.14
NAME=samtools-${VERSION}
WWW=https://www.htslib.org/download/

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/samtools/samtools/releases/download/${VERSION}/${NAME}.tar.bz2
tar -xf ${NAME}.tar.bz2
cd $NAME
./configure --prefix=/bio/bin/mapping/$NAME
make
make install

cd ..
ln -s $NAME samtools
rm ${NAME}.tar.bz2

#################################
#
# bowtie2
#
#################################
VERSION=2.4.4
NAME=bowtie2-${VERSION}-linux-x86_64
WWW=https://github.com/BenLangmead/bowtie2

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/BenLangmead/bowtie2/releases/download/v${VERSION}/${NAME}.zip
unzip ${NAME}.zip
ln -s $NAME bowtie2
rm ${NAME}.zip

#################################
#
# bowtie
#
#################################
VERSION=1.3.1
NAME=bowtie-${VERSION}-linux-x86_64
WWW=https://github.com/BenLangmead/bowtie

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/BenLangmead/bowtie/releases/download/v${VERSION}/${NAME}.zip
unzip ${NAME}.zip
ln -s $NAME bowtie
rm ${NAME}.zip

#################################
#
# BBMap
#
#################################
VERSION=38.95
NAME=bbmap.${VERSION}-ubuntu64
WWW=https://sourceforge.net/projects/bbmap

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://sourceforge.net/projects/bbmap/files/latest/download
tar -xf download
rm download

#################################
#
# SRAtoolkit
#
#################################
VERSION=2.11.3
NAME=sratoolkit.${VERSION}-ubuntu64
WWW=https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${VERSION}/${NAME}.tar.gz
tar -xf ${NAME}.tar.gz
ln -s $NAME sratoolkit
rm ${NAME}.tar.gz

#################################
#
# fastQC
#
#################################
VERSION=0.11.9
NAME=fastqc_v${VERSION}
WWW=https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/${NAME}.zip
unzip ${NAME}.zip
chmod a+x FastQC/fastqc
rm ${NAME}.zip
