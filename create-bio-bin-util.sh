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
# util directory
#
#################################

TARGET=util
if [ -d "/bio/bin/${TARGET}" ]; then
    echo "Removing existing directory /bio/bin/${TARGET}"
    rm -rf "/bio/bin/${TARGET}/"
fi

echo "Creating directory /bio/bin/${TARGET}"
mkdir "/bio/bin/${TARGET}"
cd "/bio/bin/${TARGET}"

#################################
#
# ch-hit
#
#################################
VERSION=4.8.1
NAME=cd-hit-v${VERSION}-2019-0228
WWW=https://github.com/weizhongli/cdhit

echo "################################################################################################"
echo "Fetching, unpacking and compiling ${NAME}..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."
echo "################################################################################################"

wget https://github.com/weizhongli/cdhit/releases/download/V${VERSION}/${NAME}.tar.gz
tar -xf $NAME.tar.gz

cd $NAME
make
cd ..

ln -s $NAME ch-hit

rm $NAME.tar.gz

#################################
#
# bedtools
#
#################################
VERSION=2.30.0
NAME=bedtools
WWW=https://github.com/arq5x/bedtools2

echo "################################################################################################"
echo "Fetching, unpacking and compiling ${NAME}..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."
echo "################################################################################################"


wget https://github.com/arq5x/bedtools2/releases/download/v${VERSION}/bedtools-${VERSION}.tar.gz
tar -xf bedtools-${VERSION}.tar.gz
cd bedtools2
make
cd ..
rm bedtools-${VERSION}.tar.gz

#################################
#
# pullseq
#
#################################
VERSION=1.0.2
NAME=pullseq_v${VERSION}_linux64
WWW=https://github.com/bcthomas/pullseq

echo "################################################################################################"
echo "Fetching, unpacking and compiling ${NAME}..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."
echo "################################################################################################"

wget https://github.com/bcthomas/pullseq/releases/download/${VERSION}/${NAME}.zip
unzip ${NAME}.zip
rm ${NAME}.zip

#################################
#
# nseg
#
#################################
VERSION=v1.0.1
NAME=nseg-1.0.1
WWW=https://github.com/jebrosen/nseg

echo "################################################################################################"
echo "Fetching, unpacking and compiling ${NAME}..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."
echo "################################################################################################"


wget https://github.com/jebrosen/nseg/archive/refs/tags/${VERSION}.tar.gz
tar -xf ${VERSION}.tar.gz
cd ${NAME}
make
cd ..
ln -s ${NAME}/nseg nseg
ln -s ${NAME}/nmerge nmerge
rm ${VERSION}.tar.gz
