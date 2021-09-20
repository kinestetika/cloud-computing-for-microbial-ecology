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

if ! command -v unzip &> /dev/null 
then
    echo "program unzip could not be found - make sure it is installed first"
    exit
fi

if ! command -v make &> /dev/null 
then
    echo "program make could not be found - make sure it is installed first"
    exit
fi

if [ -d "/bio/bin/analysis" ]; then
    echo "Removing existing directory /bio/bin/analysis"
    rm -rf "/bio/bin/analysis/"
fi

echo "Creating directory /bio/bin/analysis"
mkdir "/bio/bin/analysis"
cd "/bio/bin/analysis"

#################################
#
# mummer
#
#################################
VERSION=4.0.0rc1
NAME="mummer-${VERSION}"

echo "Fetching, unpacking and compiling mummer $VERSION"
echo "In case the version has changed, check out https://github.com/mummer4/mummer"

wget "https://github.com/mummer4/mummer/releases/download/v4.0.0rc1/${NAME}.tar.gz"
tar -zxvf "${NAME}.tar.gz"
cd "${NAME}"
./configure --prefix=/bio/bin/analysis
make
make install

cd ..
rm "${NAME}.tar.gz"
rm -r "${NAME}"

#################################
#
# fastANI
#
#################################
VERSION=1.33
NAME="fastANI-Linux64-v${VERSION}"

echo "Fetching, unpacking and compiling fastANI $VERSION"
echo "In case the version has changed, check out https://github.com/ParBLiSS/FastANI"

git clone https://github.com/ParBLiSS/FastANI.git
cd FastANI
./bootstrap.sh
./configure --prefix=/bio/bin/analysis
make
cd ..
ln -s FastANI/fastANI fastANI

#################################
#
# Mash
#
#################################
VERSION=2.3
NAME="mash-Linux64-v${VERSION}"

echo "Fetching and unpacking Mash $VERSION"
echo "In case the version has changed, check out https://github.com/marbl/Mash"

wget "https://github.com/marbl/Mash/releases/download/v2.3/${NAME}.tar"
tar -xvf "${NAME}.tar"
rm "${NAME}.tar"
ln -s "${NAME}/mash" mash

#################################
#
# ANIcalculator
#
#################################
VERSION=1
NAME="ANIcalculator_v${VERSION}"

echo "Fetching and unpacking ANIcalculator $VERSION"
echo "In case the version has changed, check out https://ani.jgi.doe.gov/html/anicalculator.php"

wget "https://ani.jgi.doe.gov/download_files/${NAME}.tgz"
tar -zxvf "${NAME}.tgz"
rm "${NAME}.tgz"
ln -s "${NAME}/ANIcalculator" ANIcalculator
ln -s "${NAME}/nsimscan" nsimscan
