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

if ! command -v cpanm &> /dev/null 
then
    echo "program cpanm (cpanminus could not be found - make sure it is installed first"
    exit
fi

if ! command -v gcc &> /dev/null 
then
    echo "program gcc could not be found - make sure it is installed first"
    exit
fi

#################################
#
# perl modules
#
#################################

echo "Here we create local installation of perl modules needed for all programs"
echo "This will take some time..."
echo "Before you continue, make sure to first run /usr/bin/core_perl/cpan"
echo "Accept all default options. Logout and login and re-run this script..."
read -p 'Do perl modules need update or install (Y/n)?' INSTALL_PERL_MODULES

case $INSTALL_PERL_MODULES in
n)
echo "No update needed"
;;
*)
cpanm --force --local-lib-contained /bio/bin/perl \
Time::Piece \
XML::Simple \
Digest::MD5 \
Bio::Perl \
Archive::Extract \
Bio::DB::EUtilities \
DBD::SQLite \
DBI \
File::Copy::Recursive \
HTML::Entities \
LWP::Protocol::https \
SWISS::Entry \
SWISS::KW \
LWP::Simple \
FindBin \
JSON \
Number::Format \
Statistics::Descriptive \
File::Slurp \
File::Slurper \
MCE::Mutex \
threads \
YAML \
Thread::Queue \
Math::Utils

wget https://sourceforge.net/projects/swissknife/files/latest/download
tar -zxf download
cd swissknife_1.80
perl Makefile.PL cloud
rm -rf /bio/bin/perl/lib/perl5
cp -r lib/SWISS /bio/bin/perl/lib/perl5
cd ..
rm download

;;
esac

#################################
#
# annotation folder
#
#################################
if [ -d "/bio/bin/annotate" ]; then
    echo "Removing existing directory /bio/bin/annotate"
    rm -rf "/bio/bin/annotate/"
fi

echo "Creating directory /bio/bin/annotate"
mkdir "/bio/bin/annotate"
cd "/bio/bin/annotate"

#################################
#
# signalp and tmhmm
#
#################################
SIGNALP_VERSION=6.0
TMHMM_VERSION=2.0c

echo "Installing signalp $SIGNALP_VERSION and tmhmm TMHMM_VERSION..."
echo "For, tmhmmm and signalp need, go to https://services.healthtech.dtu.dk/software.php"
echo "If versions have change you need to change this script."
echo "for agreeing to licences and download. Download the two programs to a directory." 
read -p 'To which directory have you downloaded? ' DOWLOAD_DIR
cp "$DOWLOAD_DIR/tmhmm-${TMHMM_VERSION}.Linux.tar.gz" "/bio/bin/annotate"
cp "$DOWLOAD_DIR/signalp-${SIGNALP_VERSION}.fast.tar.gz" "/bio/bin/annotate"

cd "/bio/bin/annotate"

tar -zxvf tmhmm-${TMHMM_VERSION}.Linux.tar.gz
sed -i -e 's/\/usr\/local\/bin\/perl/\/usr\/bin\/perl/' "tmhmm-${TMHMM_VERSION}/bin/tmhmm"
sed -i -e 's/\/usr\/local\/bin\/perl/\/usr\/bin\/perl/' "tmhmm-${TMHMM_VERSION}/bin/tmhmmformat.pl"
rm tmhmm-${TMHMM_VERSION}.Linux.tar.gz
ln -s "tmhmm-${TMHMM_VERSION}" tmhmm

echo "Installing signalp into the python environment (previously created by create-bio-bin-python-env.sh)." 

tar -zxvf signalp-${SIGNALP_VERSION}.fast.tar.gz
source /bio/bin/python-env/bin/activate
pip install signalp6_fast/signalp-6-package
deactivate

#################################
#
# prokka
#
#################################
VERSION=1.14.5

echo "Fetching and unpacking prokka $VERSION"
echo "In case the version has changed, check out https://github.com/tseemann/prokka and edit this script."

git clone https://github.com/tseemann/prokka

#################################
#
# aragorn
#
#################################
VERSION=1.2.41
NAME="aragorn${VERSION}.c"

echo "Fetching, unpacking and compiling aragorn $VERSION"
echo "In case the version has changed, check out https://www.ansikte.se/ARAGORN/Downloads/ and edit this script."

wget "https://www.ansikte.se/ARAGORN/Downloads/$NAME"
gcc -O3 -ffast-math -finline-functions -o aragorn $NAME

#################################
#
# prodigal
#
#################################
VERSION=2.6.3

echo "Fetching, unpacking and compiling prodigal $VERSION"
echo "In case the version has changed, check out https://github.com/hyattpd/Prodigal and edit this script."

wget "https://github.com/hyattpd/Prodigal/releases/download/v${VERSION}/prodigal.linux"
ln -s prodigal.linux prodigal



