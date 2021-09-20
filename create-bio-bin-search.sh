#!/bin/sh

#################################
#
# Author: Marc Strous
# Copyright (c) Marc Strous
#
#################################

if ! command -v wget &> /dev/null 
then
    echo "program wget could not be found - make sure it is installed first"
    exit
fi

#################################
#
# search directory
#
#################################

TARGET=search
if [ -d "/bio/bin/${TARGET}" ]; then
    echo "Removing existing directory /bio/bin/${TARGET}"
    rm -rf "/bio/bin/${TARGET}/"
fi

echo "Creating directory /bio/bin/${TARGET}"
mkdir "/bio/bin/${TARGET}"
cd "/bio/bin/${TARGET}"

#################################
#
# vsearch
#
#################################
VERSION=2.18.0
NAME=vsearch-${VERSION}-linux-x86_64-static
WWW=https://github.com/torognes/vsearch

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/torognes/vsearch/releases/download/v${VERSION}/${NAME}.tar.gz
tar -xf ${NAME}.tar.gz
ln -s $NAME vsearch 

rm ${NAME}.tar.gz

#################################
#
# usearch
#
#################################
VERSION=11.0.667
NAME=usearch${VERSION}_i86linux32
WWW=https://drive5.com/usearch/download.html

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://drive5.com/downloads/${NAME}.gz
gunzip ${NAME}.gz
ln -s ${NAME} usearch

#################################
#
# hmmer
#
#################################
VERSION=3.3.2
NAME=hmmer-${VERSION}
WWW=http://hmmer.org/download.html

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget http://eddylab.org/software/hmmer/${NAME}.tar.gz
tar -xf ${NAME}.tar.gz
cd ${NAME}
./configure --prefix=/bio/bin/search/$NAME 
make
make install
cd easel; make install
cd ..
cd ..

ln -s ${NAME} hmmer
rm ${NAME}.tar.gz

#################################
#
# diamond
#
#################################
VERSION=2.0.11
NAME=diamond-${VERSION}+
WWW=https://github.com/bbuchfink/diamond

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/bbuchfink/diamond/releases/download/v${VERSION}/diamond-linux64.tar.gz
tar -xf diamond-linux64.tar.gz

rm diamond-linux64.tar.gz

#################################
#
# ncbi blast
#
#################################
VERSION=2.12.0
NAME=ncbi-blast-${VERSION}+
WWW=https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/${NAME}-x64-linux.tar.gz
tar -xf ${NAME}-x64-linux.tar.gz

ln -s ${NAME} blast
rm ${NAME}-x64-linux.tar.gz

