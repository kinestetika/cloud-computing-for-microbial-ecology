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

TARGET=assembly
if [ -d "/bio/bin/${TARGET}" ]; then
    echo "Removing existing directory /bio/bin/${TARGET}"
    rm -rf "/bio/bin/${TARGET}/"
fi

echo "Creating directory /bio/bin/${TARGET}"
mkdir "/bio/bin/${TARGET}"
cd "/bio/bin/${TARGET}"

#################################
#
# crass
#
#################################
VERSION=1.0.1
NAME=crass-${VERSION}
WWW=https://github.com/ctSkennerton/crass

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "crass requires xerces-c and graphviz, make sure these packages are installed or the compilation will fail."
echo "################################################################################################"

wget https://github.com/ctSkennerton/crass/archive/refs/tags/v${VERSION}.tar.gz

tar -zxf v${VERSION}.tar.gz
cd $NAME
./autogen.sh
./configure --enable-rendering
make

cd ..
ln -s "$NAME/src/crass/" crass
rm v${VERSION}.tar.gz

#################################
#
# idba
#
#################################
VERSION=1.1.3
NAME=idba-${VERSION}
WWW=https://github.com/loneknightpy/idba

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/loneknightpy/idba/releases/download/${VERSION}/${NAME}.tar.gz
tar -xzf ${NAME}.tar.gz
cd ${NAME}
./configure
make
rm ${NAME}.tar.gz
ln -s ${NAME}/bin idba

cd ..

#################################
#
# spades
#
#################################
VERSION=3.15.3
NAME=SPAdes-${VERSION}-Linux
WWW=https://github.com/ablab/spades

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget http://cab.spbu.ru/files/release${VERSION}/${NAME}.tar.gz
tar -xzf ${NAME}.tar.gz
ln -s $NAME spades
rm ${NAME}.tar.gz

#################################
#
# megahit
#
#################################
VERSION=1.2.9
NAME=MEGAHIT-${VERSION}-Linux-x86_64-static
WWW=https://github.com/voutcn/megahit

echo "################################################################################################"
echo "Fetching and unpacking megahit $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget "https://github.com/voutcn/megahit/releases/download/v${VERSION}/${NAME}.tar.gz"
tar -zxvf ${NAME}.tar.gz
ln -s $NAME megahit
rm ${NAME}.tar.gz
