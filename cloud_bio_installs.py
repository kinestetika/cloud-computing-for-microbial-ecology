import sys
import time
import subprocess
import argparse
import os
import re
import wget
from shutil import which
from pathlib import Path

COMMANDS = '''
#(cdhit) cd-hit 4.8.1 https://github.com/weizhongli/cdhit
wget https://github.com/weizhongli/cdhit/releases/download/V4.8.1/cd-hit-v4.8.1-2019-0228.tar.gz
tar -xf cd-hit-v4.8.1-2019-0228.tar.gz
cd cd-hit-v4.8.1-2019-0228
make
cd $PROGRAMS_ROOT
mv cd-hit-v4.8.1-2019-0228 cd-hit
rm cd-hit-v4.8.1-2019-0228.tar.gz

#(bedtools) annotateBed 2.30.0 https://github.com/arq5x/bedtools2
wget https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools-2.30.0.tar.gz
tar -xf bedtools-2.30.0.tar.gz
cd bedtools2
make
cd $PROGRAMS_ROOT
rm bedtools-2.30.0.tar.gz
#(pullseq) pullseq 1.0.2 https://github.com/bcthomas/pullseq
wget https://github.com/bcthomas/pullseq/releases/download/1.0.2/pullseq_v1.0.2_linux64.zip
unzip pullseq_v1.0.2_linux64.zip
rm pullseq_v1.0.2_linux64.zip

#(nseg) nseg 1.0.1 https://github.com/jebrosen/nseg
wget https://github.com/jebrosen/nseg/archive/refs/tags/v1.0.1.tar.gz
tar -xf v1.0.1.tar.gz
cd nseg-1.0.1
make
cd $PROGRAMS_ROOT
ln -sf nseg-1.0.1/nseg nseg
ln -sf nseg-1.0.1/nmerge nmerge
rm v1.0.1.tar.gz

#(gblocks) Gblocks 0.91b http://molevol.cmima.csic.es/castresana/Gblocks.html
wget http://molevol.cmima.csic.es/castresana/Gblocks/Gblocks_Linux64_0.91b.tar.Z
tar -xf Gblocks_Linux64_0.91b.tar.Z
ln -sf Gblocks_0.91b/Gblocks Gblocks
rm Gblocks_Linux64_0.91b.tar.Z

#(clustalo) clustalo 1.2.4 http://www.clustal.org/omega/
cd $PROGRAMS_ROOT
wget http://www.clustal.org/omega/clustalo-1.2.4-Ubuntu-x86_64
chmod a+x clustalo-1.2.4-Ubuntu-x86_64
ln -sf clustalo-1.2.4-Ubuntu-x86_64 clustalo

#(muscle) muscle 3.8.31 https://drive5.com/muscle
cd $PROGRAMS_ROOT
wget https://drive5.com/muscle/downloads3.8.31/muscle3.8.31_i86linux64.tar.gz
tar -xf muscle3.8.31_i86linux64.tar.gz
ln -sf muscle3.8.31_i86linux64 muscle
rm muscle3.8.31_i86linux64.tar.gz

#(muscle5) muscle5 5.1 https://drive5.com/muscle
cd $PROGRAMS_ROOT
wget https://github.com/rcedgar/muscle/releases/download/v5.1/muscle5.1.linux_intel64
chmod a+x muscle5.1.linux_intel64
ln -sf muscle5.1.linux_intel64 muscle5

#(RAxML) raxmlHPC-PTHREADS 8.2.12 https://github.com/stamatak/standard-RAxML
git clone https://github.com/stamatak/standard-RAxML.git
cd standard-RAxML
make -f Makefile.SSE3.PTHREADS.gcc
make -f Makefile.AVX.PTHREADS.gcc
make -f Makefile.PTHREADS.gcc
cd $PROGRAMS_ROOT
mv standard-RAxML raxml

#(fasttree) fasttree 2.1.11 https://microbesonline.org/fasttree
wget https://microbesonline.org/fasttree/FastTreeMP
chmod a+x FastTreeMP
ln -sf FastTreeMP fasttree
ln -sf FastTreeMP FastTree

#(pplacer) pplacer 1.1.alpha19 https://github.com/matsen/pplacer
wget https://github.com/matsen/pplacer/releases/download/v1.1.alpha19/pplacer-Linux-v1.1.alpha19.zip
unzip pplacer-Linux-v1.1.alpha19.zip
mv pplacer-Linux-v1.1.alpha19 pplacer
rm pplacer-Linux-v1.1.alpha19.zip

#(vsearch) vsearch 2.21.1 https://github.com/torognes/vsearch
wget https://github.com/torognes/vsearch/releases/download/v2.21.1/vsearch-2.21.1-linux-x86_64-static.tar.gz
tar -xf vsearch-2.21.1-linux-x86_64-static.tar.gz
ln -sf vsearch-2.21.1-linux-x86_64-static vsearch
rm vsearch-2.21.1-linux-x86_64-static.tar.gz

#(usearch) usearch 11.0.667 https://drive5.com/usearch/download.html
wget https://drive5.com/downloads/usearch11.0.667_i86linux32.gz
gunzip usearch11.0.667_i86linux32.gz
chmod a+x usearch11.0.667_i86linux32
ln -sf usearch11.0.667_i86linux32 usearch

#(hmmer-3) hmmsearch 3.3.2 http://hmmer.org
wget http://eddylab.org/software/hmmer/hmmer-3.3.2.tar.gz
tar -xf hmmer-3.3.2.tar.gz
cd hmmer-3.3.2
./configure --prefix=$PROGRAMS_ROOT/hmmer-3.3.2 
make
make install
cd easel
make install
cd $PROGRAMS_ROOT
mv hmmer-3.3.2 hmmer3
rm hmmer-3.3.2.tar.gz

#(hmmer-2) hmmsearch2 2.3.2 http://hmmer.org/
wget http://eddylab.org/software/hmmer/hmmer-2.3.2.tar.gz
tar -xf hmmer-2.3.2.tar.gz
cd hmmer-2.3.2
./configure 
make
cd src
mv hmmalign hmmalign2
mv hmmbuild hmmbuild2
mv hmmcalibrate hmmcalibrate2
mv hmmconvert hmmconvert2
mv hmmemit hmmemit2
mv hmmfetch hmmfetch2
mv hmmindex hmmindex2
mv hmmpfam hmmpfam2
mv hmmsearch hmmsearch2
cd $PROGRAMS_ROOT
mv hmmer-2.3.2 hmmer2
rm hmmer-2.3.2.tar.gz

#(diamond) diamond 2.0.14 https://github.com/bbuchfink/diamond
wget https://github.com/bbuchfink/diamond/releases/download/v2.0.14/diamond-linux64.tar.gz
tar -xf diamond-linux64.tar.gz
rm diamond-linux64.tar.gz

#(ncbi-blast) blastn 2.13.0 https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/
wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.13.0+-x64-linux.tar.gz
tar -xf ncbi-blast-2.13.0+-x64-linux.tar.gz
mv ncbi-blast-2.13.0+ ncbi-blast
rm ncbi-blast-2.13.0+-x64-linux.tar.gz

#(infernal) cmsearch 1.1.4 http://eddylab.org/infernal/
wget http://eddylab.org/infernal/infernal-1.1.4-linux-intel-gcc.tar.gz
tar -xf infernal-1.1.4-linux-intel-gcc.tar.gz
mv infernal-1.1.4-linux-intel-gcc infernal
rm infernal-1.1.4-linux-intel-gcc.tar.gz

#(phyloflash) phyloFlash.pl 3.4 https://github.com/HRGV/phyloFlash/
wget https://github.com/HRGV/phyloFlash/archive/refs/tags/pf3.4.tar.gz
tar -xf pf3.4.tar.gz
mv phyloFlash-pf3.4 phyloflash
rm pf3.4.tar.gz

#(uchime) uchime 4.2.40 https://drive5.com/uchime/uchime_download.html
wget https://drive5.com/uchime/uchime4.2.40_i86linux32
chmod a+x uchime4.2.40_i86linux32 
ln -sf uchime4.2.40_i86linux32 uchime

#(mothur) mothur 1.47.0 https://github.com/mothur/mothur/
wget https://github.com/mothur/mothur/releases/download/v.1.47.0/Mothur.linux_8_noReadline.zip
unzip Mothur.linux_8_noReadline.zip
rm Mothur.linux_8_noReadline.zip
rm -r __MACOSX

#(metaamp) metaamp 2 https://github.com/xiaoli-dong/metaamp
git clone https://github.com/xiaoli-dong/metaamp.git
mkdir metaamp/bin/programs
ln -sf /bio/bin/mothur metaamp/bin/programs/


#(mummer) mummer 4.0.0rc1 https://github.com/mummer4/mummer
wget https://github.com/mummer4/mummer/releases/download/v4.0.0rc1/mummer-4.0.0rc1.tar.gz
tar -xf mummer-4.0.0rc1.tar.gz
cd mummer-4.0.0rc1
./configure --prefix=$PROGRAMS_ROOT
make
make install
cd $PROGRAMS_ROOT
rm mummer-4.0.0rc1.tar.gz
#rm -rf mummer-4.0.0rc1

#(fastani) fastANI 1.33 https://github.com/ParBLiSS/FastANI
git clone https://github.com/ParBLiSS/FastANI.git
cd FastANI
sh bootstrap.sh
sh configure --prefix=$PROGRAMS_ROOT
make
cd $PROGRAMS_ROOT
ln -sf FastANI/fastANI fastANI

#(mash) mash 2.3 https://github.com/marbl/Mash
wget https://github.com/marbl/Mash/releases/download/v2.3/mash-Linux64-v2.3.tar
tar -xf mash-Linux64-v2.3.tar
rm mash-Linux64-v2.3.tar
ln -sf mash-Linux64-v2.3/mash mash

#(ANIcalculator) ANIcalculator 1 https://ani.jgi.doe.gov/html/anicalculator.php
wget https://ani.jgi.doe.gov/download_files/ANIcalculator_v1.tgz
tar -xf ANIcalculator_v1.tgz
rm ANIcalculator_v1.tgz
ln -sf ANIcalculator_v1/ANIcalculator ANIcalculator
ln -sf ANIcalculator_v1/nsimscan nsimscan

#(aragorn) aragorn 1.2.41 https://www.ansikte.se/ARAGORN/Downloads/
wget https://www.ansikte.se/ARAGORN/Downloads/aragorn1.2.41.c
gcc -O3 -ffast-math -finline-functions -o aragorn aragorn1.2.41.c
rm aragorn1.2.41.c

#(prodigal) prodigal 2.6.3 https://github.com/hyattpd/Prodigal
wget https://github.com/hyattpd/Prodigal/releases/download/v2.6.3/prodigal.linux
chmod a+x prodigal.linux 
ln -sf prodigal.linux prodigal

#(GlimmerHMM) glimmerhmm 3.0.4 https://ccb.jhu.edu/software/glimmerhmm/man.shtml
#wget https://ccb.jhu.edu/software/glimmerhmm/dl/GlimmerHMM-3.0.4.tar.gz
#tar -xf GlimmerHMM-3.0.4.tar.gz
#rm GlimmerHMM-3.0.4.tar.gz
#ln -sf GlimmerHMM/bin/glimmerhmm_linux_x86_64 glimmerhmm

#(tmhmm) tmhmm 2.0c https://services.healthtech.dtu.dk/software.php
cp /bio/downloads/tmhmm-2.0c.Linux.tar.gz $PROGRAMS_ROOT
tar -zxvf tmhmm-2.0c.Linux.tar.gz
sed -i -e s/\/usr\/local\/bin\/perl/\/usr\/bin\/perl/ tmhmm-2.0c/bin/tmhmm
sed -i -e s/\/usr\/local\/bin\/perl/\/usr\/bin\/perl/ tmhmm-2.0c/bin/tmhmmformat.pl
rm tmhmm-2.0c.Linux.tar.gz
mv tmhmm-2.0c tmhmm

#(crass) crass 1.0.1 https://github.com/ctSkennerton/crass
wget https://github.com/ctSkennerton/crass/archive/refs/tags/v1.0.1.tar.gz
tar -zxf v1.0.1.tar.gz
cd crass-1.0.1
./autogen.sh
./configure --enable-rendering
make
cd $PROGRAMS_ROOT
ln -sf crass-1.0.1/src/crass/ crass
rm v1.0.1.tar.gz

#(idba) idba 1.1.3 https://github.com/loneknightpy/idba
wget https://github.com/loneknightpy/idba/releases/download/1.1.3/idba-1.1.3.tar.gz
tar -xzf idba-1.1.3.tar.gz
cd idba-1.1.3
./configure
make
cd $PROGRAMS_ROOT
rm idba-1.1.3.tar.gz
ln -sf idba-1.1.3/bin idba

#(SPAdes) spades.py 3.15.4 https://github.com/ablab/spades 
wget http://cab.spbu.ru/files/release3.15.4/SPAdes-3.15.4-Linux.tar.gz
tar -xzf SPAdes-3.15.4-Linux.tar.gz
ln -sf SPAdes-3.15.4-Linux spades
rm SPAdes-3.15.4-Linux.tar.gz

#(megahit) megahit 1.2.9 https://github.com/voutcn/megahit
wget https://github.com/voutcn/megahit/releases/download/v1.2.9/MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
tar -zxvf MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz
mv MEGAHIT-1.2.9-Linux-x86_64-static megahit
rm MEGAHIT-1.2.9-Linux-x86_64-static.tar.gz

#(maxbin) run_MaxBin.pl 2.2.7 https://sourceforge.net/projects/maxbin2/
wget https://sourceforge.net/projects/maxbin2/files/latest/download
tar -zxf download
cd MaxBin-2.2.7/src
make
cd $PROGRAMS_ROOT
mv MaxBin-2.2.7 maxbin
rm download

#(fraggenescan) run_FragGeneScan.pl 1.31 https://sourceforge.net/projects/fraggenescan
wget https://sourceforge.net/projects/fraggenescan/files/latest/download
tar -zxf download
mv FragGeneScan1.31 fraggenescan
rm download

#(metabat) metabat 2.12.1 https://bitbucket.org/berkeleylab/metabat/downloads/
wget https://bitbucket.org/berkeleylab/metabat/downloads/metabat-static-binary-linux-x64_v2.12.1.tar.gz
tar -zxf metabat-static-binary-linux-x64_v2.12.1.tar.gz
rm metabat-static-binary-linux-x64_v2.12.1.tar.gz

#(guppy-cpu) guppy_basecaller 5.0.14 Oxford-Nanopore-community-website
cp /bio/downloads/ont-guppy-cpu_5.0.14_linux64.tar.gz .
tar -xf ont-guppy-cpu_5.0.14_linux64.tar.gz
rm ont-guppy-cpu_5.0.14_linux64.tar.gz

#(bcftools) bcftools 1.14 https://www.htslib.org/download/
wget https://github.com/samtools/bcftools/releases/download/1.14/bcftools-1.14.tar.bz2
tar -xf bcftools-1.14.tar.bz2
cd bcftools-1.14
./configure --prefix=$PROGRAMS_ROOT/bcftools-1.14
make
make install
cd $PROGRAMS_ROOT
mv bcftools-1.14 bcftools
rm bcftools-1.14.tar.bz2

#(samtools) samtools 1.14 https://www.htslib.org/download/
wget https://github.com/samtools/samtools/releases/download/1.14/samtools-1.14.tar.bz2
tar -xf samtools-1.14.tar.bz2
cd samtools-1.14
./configure --prefix=$PROGRAMS_ROOT/samtools-1.14
make
make install
cd $PROGRAMS_ROOT
mv samtools-1.14 samtools
rm samtools-1.14.tar.bz2

#(bowtie2) bowtie2 2.4.4 https://github.com/BenLangmead/bowtie2
wget https://github.com/BenLangmead/bowtie2/releases/download/v2.4.4/bowtie2-2.4.4-linux-x86_64.zip
unzip bowtie2-2.4.4-linux-x86_64.zip
mv bowtie2-2.4.4-linux-x86_64 bowtie2
rm bowtie2-2.4.4-linux-x86_64.zip

#(bowtie) bowtie 1.3.1 https://github.com/BenLangmead/bowtie
wget https://github.com/BenLangmead/bowtie/releases/download/v1.3.1/bowtie-1.3.1-linux-x86_64.zip
unzip bowtie-1.3.1-linux-x86_64.zip
mv bowtie-1.3.1-linux-x86_64 bowtie
rm bowtie-1.3.1-linux-x86_64.zip

#(bbmap) bbmap.sh 38.95 https://sourceforge.net/projects/bbmap
wget https://sourceforge.net/projects/bbmap/files/latest/download
tar -xf download
rm download

#(sratoolkit) test-sra 3.0.0 https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.0/sratoolkit.3.0.0-ubuntu64.tar.gz
tar -xf sratoolkit.3.0.0-ubuntu64.tar.gz
mv sratoolkit.3.0.0-ubuntu64 sratoolkit
rm sratoolkit.3.0.0-ubuntu64.tar.gz

#(fastqc) fastqc 0.11.9 https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
unzip fastqc_v0.11.9.zip
chmod a+x FastQC/fastqc
rm fastqc_v0.11.9.zip

#(minced) minced 0.4.2 https://github.com/ctSkennerton/minced
wget https://github.com/ctSkennerton/minced/archive/refs/tags/0.4.2.tar.gz
tar -xf 0.4.2.tar.gz
cd minced-0.4.2
make
cd $PROGRAMS_ROOT
mv minced-0.4.2 minced
rm 0.4.2.tar.gz

#(genometools) gt 1.6.2 http://genometools.org/tools/gt_ltrharvest.html
wget http://genometools.org/pub/binary_distributions/gt-1.6.2-Linux_x86_64-64bit-barebone.tar.gz
tar -xf gt-1.6.2-Linux_x86_64-64bit-barebone.tar.gz
mv gt-1.6.2-Linux_x86_64-64bit-barebone genometools
ln -sf genometools/bin
rm gt-1.6.2-Linux_x86_64-64bit-barebone.tar.gz

#(repeatscout) RepeatScout 1.0.5 http://bix.ucsd.edu/repeatscout/    
wget http://bix.ucsd.edu/repeatscout/RepeatScout-1.0.5.tar.gz
tar -xf RepeatScout-1.0.5.tar.gz
cd RepeatScout-1
make
cd $PROGRAMS_ROOT
mv RepeatScout-1 repeatscout
rm RepeatScout-1.0.5.tar.gz

#(tandem-repeat-finder) trf 4.09 https://tandem.bu.edu/trf/trf.html
wget https://github.com/Benson-Genomics-Lab/TRF/releases/download/v4.09.1/trf409.linux64
chmod a+x trf409.linux64
ln -sf trf409.linux64 trf

#(rmblast) rmblastn 2.11.0 http://www.repeatmasker.org/${NAME}+-x64-linux.tar.gz
wget http://www.repeatmasker.org/rmblast-2.11.0+-x64-linux.tar.gz
tar -xf rmblast-2.11.0+-x64-linux.tar.gz
mv rmblast-2.11.0 rmblast
rm rmblast-2.11.0+-x64-linux.tar.gz

#(repeatmasker) RepeatMasker 4.1.2-p1 http://www.repeatmasker.org/RepeatMasker/ 
wget http://www.repeatmasker.org/RepeatMasker/RepeatMasker-4.1.2-p1.tar.gz
tar -xf RepeatMasker-4.1.2-p1.tar.gz
cd RepeatMasker
#perl ./configure (INPUT NEEDED: /bio/bin/trf 2 /bio/bin/rmblast/bin Y 5
cd $PROGRAMS_ROOT
rm RepeatMasker-4.1.2-p1.tar.gz

#(dada2) R:dada2 1.18 https://benjjneb.github.io/dada2/index.html
mkdir r
Rscript -e "install.packages(c('genoPlotR', 'data.table', 'doMC', 'ggplot2', 'optparse', 'seqinr', 'tibble', 'BiocManager'), '$PROGRAMS_ROOT/r', repos='https://cran.rstudio.com')"
Rscript -e "BiocManager::install('dada2', lib = '$PROGRAMS_ROOT/r')"

#(DAStool) R:DASTool 1.1.3 https://github.com/cmks/DAS_Tool
wget https://github.com/cmks/DAS_Tool/archive/refs/tags/1.1.3.tar.gz
tar -zxf 1.1.3.tar.gz
R CMD INSTALL DAS_Tool-1.1.3/package/DASTool_1.1.3.tar.gz
mv DAS_Tool-1.1.3 DAS_Tool
cd DAS_Tool
unzip db.zip
cd $PROGRAMS_ROOT
rm 1.1.3.tar.gz

#(python) XXX XX XX
# python programs and modules
#python -m virtualenv python-env -p /bio/downloads/python
python -m virtualenv python-env
python-env/bin/python -m pip install --upgrade pip
python-env/bin/pip install --upgrade numpy
python-env/bin/pip install --upgrade matplotlib
python-env/bin/pip install --upgrade pysam
python-env/bin/pip install --upgrade checkm-genome
python-env/bin/pip install --upgrade cutadapt
python-env/bin/pip install --upgrade drep
python-env/bin/pip install --upgrade EukRep
python-env/bin/pip install --upgrade gtdbtk
python-env/bin/pip install --upgrade iRep
python-env/bin/pip install --upgrade calisp
python-env/bin/pip install https://github.com/RasmussenLab/vamb/archive/v3.0.3.zip
python-env/bin/pip install --upgrade scikit-learn imbalanced-learn pandas seaborn screed click mamba ruamel.yaml snakemake
python-env/bin/pip install --upgrade jupyter pyarrow build twine

cd python-env
git clone https://github.com/jiarong/VirSorter2.git
cd VirSorter2
$PROGRAMS_ROOT/python-env/bin/pip install -e .
cd ..
git clone https://github.com/fenderglass/Flye
cd Flye
$PROGRAMS_ROOT/python-env/bin/python setup.py install
cd ..
git clone https://github.com/BinPro/CONCOCT.git
cd CONCOCT
$PROGRAMS_ROOT/python-env/bin/pip install -r requirements.txt
$PROGRAMS_ROOT/python-env/bin/python setup.py install
cd ..
git clone https://github.com/mgtools/MinPath.git
cd MinPath
cp "MinPath.py" "MinPath.backup.py" && tail -n +2 "MinPath.py" > "MinPath.py.tmp" && mv "MinPath.py.tmp" "MinPath.py"
chmod a+x "MinPath.py"
cd ..
ln -sf MinPath/MinPath.py bin
wget https://dl.secondarymetabolites.org/releases/6.1.0/antismash-6.1.0.tar.gz
tar -xf antismash-6.1.0.tar.gz
rm antismash-6.1.0.tar.gz
$PROGRAMS_ROOT/python-env/bin/pip install --upgrade ./antismash-6.1.0
cp /bio/downloads/signalp-6.0e.fast.tar.gz .
tar -xf signalp-6.0e.fast.tar.gz
$PROGRAMS_ROOT/python-env/bin/pip install signalp6_fast/signalp-6-package

# (instrain)
###################
#python -m virtualenv instrain-env -p /bio/downloads/python
#source instrain-env/bin/activate
###################
#python -m pip install --upgrade instrain
#deactivate

# (perl) YYY YY Y
mkdir perl
cpanm --notest --local-lib-contained $PROGRAMS_ROOT/perl Time::Piece XML::Simple Digest::MD5 Bio::Perl Archive::Extract Bio::DB::EUtilities DBD::SQLite DBI File::Copy::Recursive HTML::Entities LWP::Protocol::https LWP::Simple FindBin JSON Number::Format Statistics::Descriptive File::Slurp File::Slurper MCE::Mutex threads YAML Thread::Queue Math::Utils

'''
PROFILE='''PATH=$PATH:$BIOINF_PREFIX
PATH=$PATH:$BIOINF_PREFIX/cd-hit
PATH=$PATH:$BIOINF_PREFIX/bedtools2/bin
PATH=$PATH:$BIOINF_PREFIX/raxml
PATH=$PATH:$BIOINF_PREFIX/pplacer
PATH=$PATH:$BIOINF_PREFIX/ncbi-blast/bin
PATH=$PATH:$BIOINF_PREFIX/hmmer3/bin
PATH=$PATH:$BIOINF_PREFIX/hmmer2/src/
PATH=$PATH:$BIOINF_PREFIX/vsearch/bin
PATH=$PATH:$BIOINF_PREFIX/infernal/binaries
PATH=$PATH:$BIOINF_PREFIX/mothur
PATH=$PATH:$BIOINF_PREFIX/phyloflash
PATH=$PATH:$BIOINF_PREFIX/bin
PATH=$PATH:$BIOINF_PREFIX/tmhmm/bin
PATH=$PATH:$BIOINF_PREFIX/megahit/bin
PATH=$PATH:$BIOINF_PREFIX/spades/bin
PATH=$PATH:$BIOINF_PREFIX/idba
PATH=$PATH:$BIOINF_PREFIX/crass
PATH=$PATH:$BIOINF_PREFIX/maxbin
PATH=$PATH:$BIOINF_PREFIX/fraggenescan
PATH=$PATH:$BIOINF_PREFIX/metabat
PATH=$PATH:$BIOINF_PREFIX/FastQC
PATH=$PATH:$BIOINF_PREFIX/sratoolkit/bin
PATH=$PATH:$BIOINF_PREFIX/bbmap
PATH=$PATH:$BIOINF_PREFIX/bowtie2
PATH=$PATH:$BIOINF_PREFIX/bowtie
PATH=$PATH:$BIOINF_PREFIX/samtools/bin
PATH=$PATH:$BIOINF_PREFIX/bcftools/bin
#PATH=$PATH:$BIOINF_PREFIX/ont-guppy/bin
PATH=$PATH:$BIOINF_PREFIX/ont-guppy-cpu/bin
PATH=$PATH:$BIOINF_PREFIX/repeatscout
PATH=$PATH:$BIOINF_PREFIX/minced
PATH=$PATH:$BIOINF_PREFIX/rmblast/bin
PATH=$PATH:$BIOINF_PREFIX/genometools/bin
PATH=$PATH:$BIOINF_PREFIX/RepeatMasker
PATH=$PATH:$BIOINF_PREFIX/DAS_Tool


PATH=$PATH:$BIOINF_PREFIX/perl/bin
export PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BIOINF_PREFIX/lib
#export MAFFT_BINARIES=$BIOINF_PREFIX/align/mafft-7.475-with-extensions/binaries
export GTDBTK_DATA_PATH=/bio/databases/gtdb/release202/
export PHYLOFLASH_DBHOME=/bio/databases/phyloflash138.1
export PERL5LIB=$BIOINF_PREFIX/perl:$BIOINF_PREFIX/perl/lib/perl5:$PERL5LIB
export R_LIBS=$BIOINF_PREFIX/r:$R_LIBS
'''

VERSION = 0.0
START_TIME = time.monotonic()


def parse_arguments():
    parser = argparse.ArgumentParser(description='cloud_bio_installs. (C) Marc Strous 2022')
    parser.add_argument('--root', default="/bio/bin",  help='location where programs will be installed.')
    return parser.parse_args()


def format_runtime():
    runtime = time.monotonic() - START_TIME
    return f'[{int(runtime / 3600):02d}h:{int((runtime % 3600) / 60):02d}m:{int(runtime % 60):02d}s]'


def log(log_message):
    print(f'{format_runtime()} {log_message}')


def run_external(exec, test_str='', stdin=[]):
    final_exec = []
    e1 = exec.split('"')
    for i in range(len(e1)):
        if i % 2 == 0:
            final_exec.extend(e1[i].split())
        else:
            final_exec.append(e1[i])
    print(final_exec)
    success = False
    try:
        if len(stdin):
            print("$$$$INTERACTIVE")
            proc = subprocess.Popen(final_exec, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                    stdin=subprocess.PIPE,
                                    bufsize=1, universal_newlines=True)
            for line in stdin:
                print("$$$$" + line)
                proc.stdin.write(line)
                #outs, errs = proc.communicate(line, timeout=15)
                #print(outs)
                #print(errs)
        else:
            proc = subprocess.Popen(final_exec, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                    bufsize=1, universal_newlines=True)
            for line in proc.stdout:
                print(line.strip())
                if len(test_str) and test_str in line:
                    success = True
            for line in proc.stderr:
                print(line.strip())
                if "HTTP request sent, awaiting response... 404 Not Found" in line:
                    return success
                if "ln: failed to create symbolic link" in line:
                    return success
        return success or proc.returncode == 0
    except FileNotFoundError:
        return success

def create_folders(program_root):
    dir = Path(program_root)
    dir.mkdir(exist_ok=True)
    #for p in "align analysis annotate assembly binning mapping repeats ribosomal search trees util".split():
    #    dir = Path(program_root, p)
    #    dir.mkdir(exist_ok=True)


def create_and_activate_profile(program_root):
    profile_file = Path(program_root, 'profile')
    with open(profile_file, "w") as profile_handle:
        profile_handle.write(f'export BIOINF_PREFIX={program_root}\n')
        profile_handle.write(PROFILE)
    for line in PROFILE.split():
        if line.startswith('PATH='):
            os.environ["PATH"] += ':' + line.replace('PATH=$PATH:$BIOINF_PREFIX', program_root)
    os.environ["LD_LIBRARY_PATH"] = os.path.join(program_root, "analysis", "mummer", "lib")
    os.environ["PERL5LIB"] = f'{os.path.join(program_root, "perl")}:{os.path.join(program_root, "perl", "lib", "perl5")}'
    os.environ["R_LIBS"] = os.path.join(program_root, "r")
    # print(os.environ["PATH"])
    os.chdir(program_root)


def install_programs_run_cmds(program_root):
    cmd_re = re.compile('#\((.+?)\)')
    input_re = re.compile('#INPUT')
    cmd = None
    cmd_already_installed = False
    for line in COMMANDS.split("\n"):
        if not line:
            continue
        if 'END' == line:
            break
        if line.startswith("############"):
            cmd = None
            cmd_already_installed = False
        line = line.replace("$PROGRAMS_ROOT", program_root)
        cmd_match = cmd_re.match(line)
        if cmd_match:
            cmd = cmd_match.group(1)
            cmd_already_installed = False
            words = line.split()
            log(f'Now installing \"{cmd}\" version {words[2]}')
            log(f'  (In case of problems or a new version: {words[3]}')
            log(f'  checking if {words[1]} is available...')
            if words[1].startswith("R:"):
                words[1] = words[1][2:]
                if run_external('Rscript -e installed.packages()', words[1]):
                    cmd_already_installed = True
                    log('  ok! (Already installed and functioning, skipping install)')
            elif which(words[1]) is not None:
                cmd_already_installed = True
                log('  ok! (Already installed and functioning, skipping install)')
            continue
        elif cmd_already_installed:
            continue
        elif line.startswith("#"):
            continue
        elif line.startswith('cd'):
            new_dir = line.split()[1]
            log(f'Now entering dir "{new_dir}"')
            os.chdir(new_dir)
            continue
        elif line.startswith('wget'):
            url = line.split()[1]
            log(f'  Fetching "{url}"')
            wget.download(url, url.split('/')[-1])
            continue
        log(f'  while installing {cmd}: "{line}"')
        input_match = input_re.search(line)
        if input_match:
            print(input_match.end())
            input = line[input_match.end()+1:].split(" ")
            line = line[:input_match.start()]
            print(line)
            print(input)
            run_external(line, stdin=input)
        else:
            run_external(line)
#        print(line)


def main():
    args = parse_arguments()
    log(f'This script installs a suite of bio-informatics software on a linux (cloud) compute. Version {VERSION}')
    log('Before you continue:')
    log('[1] you will need to install some packages using your linux distro\'s package manager (e.g. apt). On arch:')
    log('pacman -S gnuplot cpanminus fig2dev boost zip unzip python-pip python-virtualenv python-h5py tk curl '
        'r gawk jre-openjdk ruby cuda cairo pango gsl jdk-openjdk graphviz xerces-c pigz git glpk ncurses')
    log('[2] Some program require manual downloads: signalp, tmhmm and guppy. First create the folder "/bio/bin/downloads"'
        '. Then, download these programs and place them in that folder. Also, if you need a non standard python version,'
        'compile it and place the python executable in that folder. Otherwise, create a symlink to the standard python'
        'executable. Normally ln -s /usr/bin/python /bio/bin/downloads/python')
    log('[3] Run "cpan" and accept all default options. Login and logout.')
    log('After completing [1] - [3], you are ready to run this script.')
    #response = input('Ready to proceed (Y/N)?')
    #if not response in 'yY':
    #    exit(0)

    create_folders(args.root)
    create_and_activate_profile(args.root)
    install_programs_run_cmds(args.root)
    log("Done.")

if __name__ == "__main__":
    main()