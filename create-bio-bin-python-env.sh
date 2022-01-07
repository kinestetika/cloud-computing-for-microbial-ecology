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

if ! command -v pip3 &> /dev/null 
then
    echo "python module/program pip could not be found - make sure it is installed first"
    exit
fi

if [ $(pip list | grep virtualenv | wc -l) -lt 1 ]
then
    echo "python module virtualenv needs to be installed first. For example:"
    echo "python3 -m pip install --user -U virtualenv"
    exit
fi

if [ -d "/bio/bin/python-env" ]; then
    echo "Removing existing directory /bio/bin/python-env"
    rm -rf "/bio/bin/python-env/"
fi

#################################
#
# create and enter the virtual environment
#
#################################

cd "/bio/bin"

if [ ! -d "/bio/bin/python-env" ]; then
    echo "Creating python virtual environment as /bio/bin/python-env"
    python -m virtualenv python-env
fi

source python-env/bin/activate

#################################
#
# install the python modules/programs
#
#################################

pip3 install --upgrade numpy
pip3 install --upgrade matplotlib
pip3 install --upgrade pysam
pip3 install --upgrade checkm-genome
pip3 install --upgrade cutadapt
pip3 install --upgrade drep
pip3 install --upgrade EukRep
pip3 install --upgrade gtdbtk
pip3 install --upgrade instrain
pip3 install --upgrade iRep
pip3 install --upgrade calisp
pip3 install https://github.com/RasmussenLab/vamb/archive/3.0.3.zip
pip3 install --upgrade scikit-learn imbalanced-learn pandas seaborn screed click mamba ruamel.yaml snakemake
pip3 install --upgrade jupyter pandas pyarrow


cd python-env

git clone https://github.com/jiarong/VirSorter2.git
cd VirSorter2
pip install -e
cd ..

git clone https://github.com/fenderglass/Flye
cd Flye
python setup.py install
cd ..

git clone https://github.com/BinPro/CONCOCT.git
cd CONCOCT
pip install -r requirements.txt
python setup.py install
cd ..

git clone https://github.com/mgtools/MinPath.git
cd MinPath
cp "MinPath.py" "MinPath.backup.py" && tail -n +2 "MinPath.py" > "MinPath.py.tmp" && mv "MinPath.py.tmp" "MinPath.py"
chmod a+x "MinPath.py"
cd ..
ln -s MinPath/MinPath.py bin

#################################
#
# install antismash
#
#################################
VERSION=6.0.0
NAME=antismash-${VERSION}
WWW=https://docs.antismash.secondarymetabolites.org/install/

echo "################################################################################################"
echo "Fetching, unpacking and compiling ${NAME} in python environment..."
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."
echo "################################################################################################"

wget https://dl.secondarymetabolites.org/releases/${VERSION}/${NAME}.tar.gz
tar -xf ${VERSION}/${NAME}.tar.gz
rm ${NAME}.tar.gz
pip install ./${NAME}

#################################
#
# install signalp
#
#################################
SIGNALP_VERSION=6.0e

echo "Installation of signalp $SIGNALP_VERSION..."
echo "For signalp (and tmhmm), go to https://services.healthtech.dtu.dk/software.php"
echo "for agreeing to licences and download. Download the two programs to a directory."
echo "If versions have change you need to change this script."

read -p 'Do you wish to install signalp (Y/n)?' INSTALL_SIGNALP
case $INSTALL_SIGNALP in n)
echo "Skipping install of signalp..."
;;
*)
read -p 'To which directory have you downloaded signalp? ' DOWLOAD_DIR
echo "Installing signalp into the python environment..." 

cp "$DOWLOAD_DIR/signalp-${SIGNALP_VERSION}.fast.tar.gz" .
tar -xf signalp-${SIGNALP_VERSION}.fast.tar.gz

pip install signalp6_fast/signalp-6-package
;;
esac
#################################
#
# leave the virtual environment
#
#################################

echo "Leaving virtual environment /bio/bin/python-env"
deactivate

