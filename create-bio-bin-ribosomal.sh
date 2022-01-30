#!/bin/sh

#################################
#
# Author: Marc Strous
# Copyright (c) Marc Strous
#
#################################

#################################
#
# ribosomal directory
#
#################################

TARGET=ribosomal
if [ -d "/bio/bin/${TARGET}" ]; then
    echo "Removing existing directory /bio/bin/${TARGET}"
    rm -rf "/bio/bin/${TARGET}/"
fi

echo "Creating directory /bio/bin/${TARGET}"
mkdir "/bio/bin/${TARGET}"
cd "/bio/bin/${TARGET}"

#################################
#
# phyloflash
#
#################################
VERSION=3.4
NAME=phyloflash
WWW=https://github.com/HRGV/phyloFlash/

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."
echo "################################################################################################"

wget https://github.com/HRGV/phyloFlash/archive/refs/tags/pf${VERSION}.tar.gz
tar -xf pf${VERSION}.tar.gz

ln -s phyloFlash-pf${VERSION} phyloflash

rm pf${VERSION}.tar.gz

#################################
#
# rRNAFinder
#
#################################
VERSION=1.1.0
NAME=rRNAFinder-v${VERSION}
WWW=https://github.com/xiaoli-dong/rRNAFinder

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."
echo "################################################################################################"

wget https://github.com/xiaoli-dong/rRNAFinder/archive/refs/tags/${NAME}.tar.gz
tar -xf $NAME.tar.gz

ln -s rRNAFinder-$NAME rRNAFinder

rm $NAME.tar.gz

#################################
#
# uchime
#
#################################
VERSION=4.2.40
NAME=uchime
WWW=https://drive5.com/uchime/uchime_download.html

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."
echo "################################################################################################"

wget https://drive5.com/uchime/uchime4.2.40_i86linux32
ln -s uchime4.2.40_i86linux32 uchime

#################################
#
# mothur
#
#################################
VERSION=1.47.0
NAME=Mothur.linux_8_noReadline
WWW=https://github.com/mothur/mothur/

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."
echo "################################################################################################"

wget https://github.com/mothur/mothur/releases/download/v${VERSION}/${NAME}.zip
unzip $NAME.zip
rm $NAME.zip
rm -r __MACOSX

#################################
#
# metaamp
#
#################################
VERSION=2
NAME=metaamp
WWW=https://github.com/xiaoli-dong/metaamp

echo "################################################################################################"
echo "Fetching, unpacking and compiling $NAME..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."
echo "################################################################################################"

git clone https://github.com/xiaoli-dong/${NAME}.git

mkdir metaamp/bin/programs
ln -s /bio/bin/ribosomal/mothur/ metaamp/bin/programs/

echo "Metaamp needs code edits to run. Best to do manually."
echo "In file get_diversity.pl, comment out the line $projDir =~ s/\/bin//;"
echo "In file global.pl,  comment out the line $projDir =~ s/\/bin//;"
echo "getOTUTaxonTable.relabund.pl, change line 96 to if(exists $table{"$prefix\_$otuid"}->{$sample} && $totals{$sample}>0){"