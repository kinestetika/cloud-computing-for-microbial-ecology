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
# genome tools
#
#################################

VERSION=1.5.10
NAME=gt-${VERSION}-Linux_x86_64-64bit-barebone
WWW=http://genometools.org/tools/gt_ltrharvest.html

echo "################################################################################################"
echo "Fetching and installing $NAME (includes LTR harvest)"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"


wget http://genometools.org/pub/binary_distributions/${NAME}.tar.gz
tar -xf ${NAME}.tar.gz
ln -s ${NAME}/bin/gt gt
rm ${NAME}.tar.gz

#################################
#
# repeatscout
#
#################################

VERSION=1.0.5
NAME=RepeatScout-${VERSION}
WWW=http://bix.ucsd.edu/repeatscout/

echo "################################################################################################"
echo "Fetching and installing $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget http://bix.ucsd.edu/repeatscout/${NAME}.tar.gz
tar -xf ${NAME}.tar.gz
cd RepeatScout-1
make
cd ..
ln -s RepeatScout-1 repeatscout
rm ${NAME}.tar.gz

#################################
#
# tandem repeat finder
#
#################################
VERSION=v4.09.1
NAME=trf409
WWW=https://tandem.bu.edu/trf/trf.html

echo "################################################################################################"
echo "Fetching and installing ${NAME} ${VERSION}, tandem repeat finder"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/Benson-Genomics-Lab/TRF/releases/download/${VERSION}/${NAME}.linux64
chmod "a+x" ${NAME}.linux64
ln -s ${NAME}.linux64 trf

#################################
#
# rmblast
#
#################################
VERSION=2.11.0
NAME=rmblast-${VERSION}
WWW=http://www.repeatmasker.org/RepeatMasker/

echo "################################################################################################"
echo "Fetching and installing ${NAME}..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget http://www.repeatmasker.org/${NAME}+-x64-linux.tar.gz
tar -xf ${NAME}+-x64-linux.tar.gz
ln -s rmblast-2.11.0 rmblast
rm ${NAME}+-x64-linux.tar.gz


#################################
#
# repeatmasker
#
#################################
VERSION=4.1.2-p1
NAME=RepeatMasker-${VERSION}
WWW=http://www.repeatmasker.org/RepeatMasker/

echo "################################################################################################"
echo "Fetching and installing ${NAME}..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "During configuration, you will be asked for a search engine. Choose RMBlast. The path to the"
echo "RMBlast directory is /bio/bin/repeats/rmblast/bin/."
echo "################################################################################################"
read -p 'Continue?' CONTINUE

wget http://www.repeatmasker.org/RepeatMasker/${NAME}.tar.gz
tar -xf ${NAME}.tar.gz
cd RepeatMasker
perl ./configure
cd ..

rm ${NAME}.tar.gz

#################################
#
# minced
#
#################################
VERSION=0.4.2
NAME=minced-${VERSION}
WWW=https://github.com/ctSkennerton/minced

echo "################################################################################################"
echo "Fetching, unpacking and compiling ${NAME}"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/ctSkennerton/minced/archive/refs/tags/${VERSION}.tar.gz
tar -xf ${VERSION}.tar.gz

cd ${NAME}
make
cd ..

ln -s ${NAME} minced
rm ${VERSION}.tar.gz
