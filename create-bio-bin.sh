#!/bin/sh

#################################
#
# Author: Marc Strous
# Copyright (c) Marc Strous
#
#################################

# create dirs and set permissions
if [ ! -d "/bio/bin" ]; then
    echo "Creating directory /bio/bin"
    mkdir -p "/bio/bin"
    chmod a+wx "/bio/bin"
else
    echo "Keeping existing /bio/bin directory"
    chmod a+wx "/bio/bin"
fi


#################################
#
# Profile
#
#################################
echo "Creating the profile file"

cat << "EOF" > /bio/bin/profile
export BIOINF_PREFIX=/bio/bin
PATH=$PATH:$BIOINF_PREFIX/align
PATH=$PATH:$BIOINF_PREFIX/align/mafft-bin
PATH=$PATH:$BIOINF_PREFIX/anaconda
PATH=$PATH:$BIOINF_PREFIX/analysis
PATH=$PATH:$BIOINF_PREFIX/analysis/bin
PATH=$PATH:$BIOINF_PREFIX/annotate/
PATH=$PATH:$BIOINF_PREFIX/annotate/prokka/bin
PATH=$PATH:$BIOINF_PREFIX/annotate/tmhmm/bin
PATH=$PATH:$BIOINF_PREFIX/assembly
PATH=$PATH:$BIOINF_PREFIX/assembly/megahit/bin
PATH=$PATH:$BIOINF_PREFIX/assembly/spades/bin
PATH=$PATH:$BIOINF_PREFIX/assembly/idba/bin
PATH=$PATH:$BIOINF_PREFIX/assembly/crass
PATH=$PATH:$BIOINF_PREFIX/binning
PATH=$PATH:$BIOINF_PREFIX/binning/metabat
PATH=$PATH:$BIOINF_PREFIX/binning/fraggenescan
PATH=$PATH:$BIOINF_PREFIX/binning/maxbin
PATH=$PATH:$BIOINF_PREFIX/binning/DAS_Tool
PATH=$PATH:$BIOINF_PREFIX/mapping/FastQC
PATH=$PATH:$BIOINF_PREFIX/mapping/sratoolkit/bin
PATH=$PATH:$BIOINF_PREFIX/mapping/bbmap
PATH=$PATH:$BIOINF_PREFIX/mapping/bowtie2
PATH=$PATH:$BIOINF_PREFIX/mapping/bowtie
PATH=$PATH:$BIOINF_PREFIX/mapping/samtools/bin
PATH=$PATH:$BIOINF_PREFIX/mapping/bcftools/bin
#PATH=$PATH:$BIOINF_PREFIX/mapping/ont-guppy/bin
PATH=$PATH:$BIOINF_PREFIX/mapping/ont-guppy-cpu/bin
PATH=$PATH:$BIOINF_PREFIX/annotate
PATH=$PATH:$BIOINF_PREFIX/repeats
PATH=$PATH:$BIOINF_PREFIX/repeats/repeatscout
PATH=$PATH:$BIOINF_PREFIX/repeats/minced
PATH=$PATH:$BIOINF_PREFIX/repeats/RepeatMasker
#PATH=$PATH:$BIOINF_PREFIX/repeats/RepeatModeler
#PATH=$PATH:$BIOINF_PREFIX/repeats/recon
PATH=$PATH:$BIOINF_PREFIX/ribosomal
PATH=$PATH:$BIOINF_PREFIX/ribosomal/mothur
PATH=$PATH:$BIOINF_PREFIX/ribosomal/rRNAFinder/bin
PATH=$PATH:$BIOINF_PREFIX/ribosomal/metaamp/bin
PATH=$PATH:$BIOINF_PREFIX/ribosomal/phyloflash
PATH=$PATH:$BIOINF_PREFIX/search
PATH=$PATH:$BIOINF_PREFIX/search/blast/bin
PATH=$PATH:$BIOINF_PREFIX/search/hmmer/bin
PATH=$PATH:$BIOINF_PREFIX/search/hmmer-2.3.2/src/
PATH=$PATH:$BIOINF_PREFIX/search/vsearch/bin
PATH=$PATH:$BIOINF_PREFIX/search/infernal/binaries
PATH=$PATH:$BIOINF_PREFIX/trees
PATH=$PATH:$BIOINF_PREFIX/trees/raxml
PATH=$PATH:$BIOINF_PREFIX/trees/pplacer
PATH=$PATH:$BIOINF_PREFIX/util
PATH=$PATH:$BIOINF_PREFIX/util/cd-hit
PATH=$PATH:$BIOINF_PREFIX/util/bedtools/bin
PATH=$PATH:$BIOINF_PREFIX/ribosomal/mothur
PATH=$PATH:$BIOINF_PREFIX/ribosomal/metaamp/bin
PATH=$PATH:$BIOINF_PREFIX/perl/bin
export PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BIOINF_PREFIX/analysis/mummer/lib
#export MAFFT_BINARIES=$BIOINF_PREFIX/align/mafft-7.475-with-extensions/binaries
export GTDBTK_DATA_PATH=/bio/databases/gtdb/release202/
export PHYLOFLASH_DBHOME=/bio/databases/phyloflash138.1
export PERL5LIB=/bio/bin/perl:/bio/bin/perl/lib/perl5:$PERL5LIB
export R_LIBS=/bio/bin/r:$R_LIBS
EOF

chmod a+w /bio/bin/profile

#################################
#
# Instructions on prerequisite packages
#
#################################

echo "Before you continue, you will need to install some packages using your linux distro's package manager (e.g. apt)."
echo "On arch:"
echo "pacman -S gnuplot cpanminus fig2dev boost zip unzip python-pip python-virtualenv python-h5py tk curl r gawk jre-openjdk ruby cuda cairo pango gsl jdk-openjdk graphviz xerces-c pigz git glpk ncurses"
