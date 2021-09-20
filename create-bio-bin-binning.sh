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

if ! command -v R &> /dev/null 
then
    echo "program R could not be found - make sure it is installed first"
    exit
fi


#################################
#
# R packages
#
#################################
echo "Here we create local installation of R for all programs"
echo "This will take some time..."
read -p 'Do R modules need update or install (Y/n)?' INSTALL_R_MODULES

export R_LIBS=/bio/bin/r

case $INSTALL_R_MODULES in
n)
echo "No update needed"
;;
*)
cd /bio/bin
mkdir r
Rscript -e "install.packages(c('genoPlotR', 'data.table', 'doMC', 'ggplot2', 'optparse', 'seqinr', 'tibble', 'BiocManager'), repos='https://cran.rstudio.com')"
Rscript -e "BiocManager::install('dada2', lib = '/bio/bin/r')"
;;
esac


#################################
#
# binning directory
#
#################################

TARGET=binning
if [ -d "/bio/bin/${TARGET}" ]; then
    echo "Removing existing directory /bio/bin/${TARGET}"
    rm -rf "/bio/bin/${TARGET}/"
fi

echo "Creating directory /bio/bin/${TARGET}"
mkdir "/bio/bin/${TARGET}"
cd "/bio/bin/${TARGET}"

#################################
#
# DAStool
#
#################################
VERSION=1.1.3
NAME=DAS_Tool-${VERSION}
WWW=https://github.com/cmks/DAS_Tool

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://github.com/cmks/DAS_Tool/archive/refs/tags/${VERSION}.tar.gz
tar -zxf ${VERSION}.tar.gz

R CMD INSTALL ${NAME}/package/DASTool_${VERSION}.tar.gz
ln -s ${NAME} DAS_Tool

cd DAS_Tool
unzip db.zip
cd ..

rm ${VERSION}.tar.gz

#################################
#
# maxbin2
#
#################################
VERSION=2.2.7
NAME=MaxBin-${VERSION}
WWW=https://sourceforge.net/projects/maxbin2/

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://sourceforge.net/projects/maxbin2/files/latest/download
tar -zxf download
cd $NAME/src
make
cd ..
cd ..
ln -s $NAME maxbin
rm download

#################################
#
# fraggenescan
#
#################################
VERSION=1.31
NAME=metabat-static-binary-linux-x64_v${VERSION}
WWW=https://sourceforge.net/projects/fraggenescan

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://sourceforge.net/projects/fraggenescan/files/latest/download
tar -zxf download
ln -s FragGeneScan$VERSION fraggenescan
rm download

#################################
#
# metabat
#
#################################
VERSION=2.12.1
NAME=metabat-static-binary-linux-x64_v${VERSION}
WWW=https://bitbucket.org/berkeleylab/metabat/downloads/

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly"
echo "################################################################################################"

wget https://bitbucket.org/berkeleylab/metabat/downloads/${NAME}.tar.gz
tar -zxf ${NAME}.tar.gz
rm ${NAME}.tar.gz


