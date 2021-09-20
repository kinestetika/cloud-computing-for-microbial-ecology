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
# trees directory
#
#################################

TARGET=trees
if [ -d "/bio/bin/${TARGET}" ]; then
    echo "Removing existing directory /bio/bin/${TARGET}"
    rm -rf "/bio/bin/${TARGET}/"
fi

echo "Creating directory /bio/bin/${TARGET}"
mkdir "/bio/bin/${TARGET}"
cd "/bio/bin/${TARGET}"

#################################
#
# RAxML
#
#################################
VERSION=8.2.12
NAME=standard-RAxML
WWW=https://github.com/stamatak/standard-RAxML

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."
echo "Note that we compile three versions, including AVX for processors <1-2y and SSE3 for processors <4y."
echo "################################################################################################"

git clone https://github.com/stamatak/standard-RAxML.git
cd standard-RAxML
make -f Makefile.SSE3.PTHREADS.gcc
make -f Makefile.AVX.PTHREADS.gcc
make -f Makefile.PTHREADS.gcc
rm *.o
cd ..
ln -s standard-RAxML raxml

#################################
#
# FastTree
#
#################################
VERSION=2.1.11
NAME=FastTree-${VERSION}
WWW=https://microbesonline.org/fasttree/#Install

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://microbesonline.org/fasttree/FastTreeMP
ln -s FastTreeMP fasttree
ln -s FastTreeMP FastTree

#################################
#
# pplacer
#
#################################
VERSION=v1.1.alpha19
NAME=pplacer-Linux-${VERSION}
WWW=https://github.com/matsen/pplacer

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/matsen/pplacer/releases/download/${VERSION}/${NAME}.zip

unzip ${NAME}.zip
echo $NAME
ln -s $NAME pplacer
rm ${NAME}.zip