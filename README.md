# Cloud-Computing-for-Microbial-Ecology
Development of Cloud Compute Images for Microbial Ecology

# Why cloud computing?
Cloud computing offers many advantages for processing metagenomics data:
1. No need to purchase and maintain expensive local compute infrastructure. This is especially important for small groups with limited budgets.
2. No scheduler. No queue. Saves costs and time while debugging pipelines and code.
3. Compute images for cloud community can be a community resource, saving time installing and updating software and databases.
4. Reproducibility. Others can replicate your compute environment exactly by re-using your image.
5. Infinite scalability enabling you to address bigger questions. 
6. Rapid access to NCBI data, but this only applies to Google Cloud and Amazon Web Services.

# Status
1. (done) Create a custom arch linux image on gcloud. Check out this [wiki](https://github.com/kinestetika/cloud-computing-for-microbial-ecology/wiki/Installing-the-Operating-System) page.
2. (done) Install programs and databases. See wiki - Check out this [wiki](https://github.com/kinestetika/cloud-computing-for-microbial-ecology/wiki/Scope-and-List-of-Programs) page.
3. (done) Share images with microbial ecology community. Check out this [wiki](https://github.com/kinestetika/cloud-computing-for-microbial-ecology/wiki/Firing-up-your-own-Cloud-Server) page.
4. (in progress) Test and benchmark installed programs.
5. (in progress) Explore other cloud providers, such as AWS and UpCloud.

You can use the python script "cloud_bio_installs.py" to install a set of programs I find useful. Most installations will likely work
out of the box. The script depends on the python module "wget".
If you just want to install a few programs, you can also just have a look at the shell commands in the script and copy/run
those that you need. To run the script:

>python -m pip install --upgrade wget
>python path/to/cloud_bio_installs.py --root [path_to_where_you_want_the_programs_to_be - default: /bio/bin]

Before you attempt to run the installed programs:

>source [path_to_where_you_installed_the_programs]/profile

And before running python programs:
>source [path_to_where_you_want_the_programs_to_be]/python-env/bin/activate

You will also need databases. To install those:

if [ ! -d /bio/databases ]
then
    sudo mkdir /bio/databases
    sudo chmod -R a+wX /bio/databases
fi

cd /bio/databases

#################################
#
# metaamp
#
#################################
VERSION=138_1
NAME="mothur silva database for metaamp"
WWW=https://mothur.org/wiki/silva_reference_files/

echo "Fetching and unpacking $NAME $VERSION"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."

mkdir metaamp
cd metaamp

wget https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.nr_v${VERSION}.tgz
tar -xf silva.nr_v${VERSION}.tgz
rm silva.nr_v${VERSION}.tgz

ln -s silva.nr_v138_1.align silva.nr.fasta
ln -s silva.nr_v138_1.tax silva.nr.tax
ln -s /bio/databases/metaamp /bio/bin/ribosomal/metaamp/bin/database

# Metaamp needs code edits to run. Best to do manually.
# In file get_diversity.pl, comment out the line $projDir =~ s/\/bin//;
# In file global.pl,  comment out the line $projDir =~ s/\/bin//;
# getOTUTaxonTable.relabund.pl, change line 96 to if(exists $table{"$prefix\_$otuid"}->{$sample} && $totals{$sample}>0){

cd ..

#################################
#
# phyloflash
#
#################################
VERSION=138.1

echo "Setting up database for phyloflash for Silva release ${VERSION}"

mkdir phyloflash
cd phyloflash

source /bio/bin/profile

phyloFlash_makedb.pl --remote

cd ..

export PHYLOFLASH_DBHOME=/bio/databases/phyloflash/${VERSION}

sed -i -e 's/export PHYLOFLASH_DBHOME=\/bio\/databases\/phyloflash\/.+/export PHYLOFLASH_DBHOME=/bio\/databases\/phyloflash\/${VERSION}/' /bio/bin/profile

#################################
#
# gtdbtk
#
#################################
VERSION=release202
NAME="gtdbtk_data"
WWW=https://ecogenomics.github.io/GTDBTk/installing/index.html#gtdb-tk-reference-data

echo "Fetching and unpacking $NAME $VERSION"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."

mkdir gtdbtk
cd gtdbtk

wget "https://data.gtdb.ecogenomic.org/releases/latest/auxillary_files/${NAME}.tar.gz"
tar -xf "${NAME}.tar.gz"
rm "${NAME}.tar.gz"
cd ..

export GTDBTK_DATA_PATH=/bio/databases/gtdbtk/${VERSION}

sed -i -e 's/export GTDBTK_DATA_PATH=\/bio\/databases\/gtdbtk\/.+/export GTDBTK_DATA_PATH=\/bio\/databases\/gtdbtk\/${VERSION}/' /bio/bin/profile

#################################
#
# checkm
#
#################################
VERSION=2015_01_16
NAME="checkm_data_${VERSION}"
WWW=https://github.com/Ecogenomics/CheckM/wiki/Installation#how-to-install-checkm

echo "Fetching and unpacking $NAME"
echo "In case this is no longer the latest version, check out ${WWW}, and edit this script accordingly."

mkdir checkm
cd checkm
wget "https://data.ace.uq.edu.au/public/CheckM_databases/${NAME}.tar.gz"
tar -xf "${NAME}.tar.gz"
rm "${NAME}.tar.gz"
cd ..

source /bio/bin/python-env/bin/activate
checkm data setRoot /bio/databases/checkm
deactivate


#################################
#
# virsorter
#
#################################
cd /bio/databases
wget https://osf.io/v46sc/download
tar -xf download
mv db virsorter
source /bio/bin/python-env/bin/activate
virsorter config --init-source --db-dir=./virsorter/
deactivate

#################################
#
# antismash
#
#################################

source /bio/bin/python-env/bin/activate
download-antismash-databases
deactivate

# Note that antismash databases get installed at: /bio/bin/python-env/lib/python3.10/site-packages/antismash/databases/
