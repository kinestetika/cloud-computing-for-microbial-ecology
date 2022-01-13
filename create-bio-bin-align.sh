#!/bin/sh

#################################
#
# Author: Marc Strous
# Copyright (c) Marc Strous
#
#################################

if [ -d "/bio/bin/align" ]; then
    echo "Removing existing directory /bio/bin/align"
    rm -r "/bio/bin/align/"
fi

echo "Creating directory /bio/bin/align"
mkdir "/bio/bin/align"
cd "/bio/bin/align"

#################################
#
# gblocks
#
#################################
VERSION=0.91b
NAME="Gblocks_Linux64_${VERSION}"

echo "Fetching and unpacking gblocks $VERSION"
echo "In case the version has changed, check out http://molevol.cmima.csic.es/castresana/Gblocks.html"

wget "http://molevol.cmima.csic.es/castresana/Gblocks/${NAME}.tar.Z"
tar -zxvf "${NAME}.tar.Z"
ln -s "Gblocks_${VERSION}/Gblocks" Gblocks
rm "${NAME}.tar.Z"

#################################
#
# clustalo
#
#################################
VERSION=1.2.4
NAME="clustalo-${VERSION}-Ubuntu-x86_64"

echo "Fetching and unpacking clustalo $VERSION"
echo "In case the version has changed, check out http://www.clustal.org/omega/"

wget "http://www.clustal.org/omega/$NAME"
ln -s $NAME "clustalo"
chmod a+x $NAME

#################################
#
# muscle
#
#################################
VERSION=3.8.31
NAME="muscle${VERSION}_i86linux64"

echo "Fetching and unpacking muscle $VERSION"
echo "In case the version has changed, check out https://www.drive5.com/muscle/downloads.htm"

wget "https://www.drive5.com/muscle/downloads${VERSION}/${NAME}.tar.gz"
tar -zxvf "$NAME.tar.gz"
ln -s $NAME "muscle"
rm "${NAME}.tar.gz"

#################################
#
# mafft
#
#################################
VERSION=7.490

echo "Fetching, unpacking and compiling mafft $VERSION"
echo "In case the version has changed, check out https://mafft.cbrc.jp/alignment/software/"

wget "https://mafft.cbrc.jp/alignment/software/mafft-${VERSION}-with-extensions-src.tgz"
tar -zxvf "mafft-${VERSION}-with-extensions-src.tgz"
cd "mafft-${VERSION}-with-extensions/core"

sed -i -e 's/PREFIX = \/usr\/local/PREFIX = \/bio\/bin\/align/g' Makefile
sed -i -e 's/BINDIR = $(PREFIX)\/bin/BINDIR = $(PREFIX)\/mafft-bin/g' Makefile

make
make install

cd "/bio/bin/align"
rm "mafft-${VERSION}-with-extensions-src.tgz"
rm -r "mafft-${VERSION}-with-extensions"