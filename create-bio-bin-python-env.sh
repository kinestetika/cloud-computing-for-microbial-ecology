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
    rm -r "/bio/bin/python-env/"
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
# leave the virtual environment
#
#################################

echo "Leaving virtual environment /bio/bin/python-env"
deactivate

