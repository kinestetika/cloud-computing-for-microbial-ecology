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
# repeats directory
#
#################################

TARGET=repeats
if [ -d "/bio/bin/${TARGET}" ]; then
    echo "Removing existing directory /bio/bin/${TARGET}"
    rm -rf "/bio/bin/${TARGET}/"
fi

echo "Creating directory /bio/bin/${TARGET}"
mkdir "/bio/bin/${TARGET}"
cd "/bio/bin/${TARGET}"

#################################
#
# minced
#
#################################
VERSION=0.4.2
NAME=minced-${VERSION}
WWW=https://github.com/ctSkennerton/minced

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/ctSkennerton/minced/archive/refs/tags/${VERSION}.tar.gz
tar -xf ${VERSION}.tar.gz

cd ${NAME}
make
cd ..

ln -s ${NAME} minced
rm ${VERSION}.tar.gz
