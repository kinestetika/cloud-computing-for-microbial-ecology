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
4. (done) Test installed programs.

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

# metaamp
1. mkdir metaamp
2. cd metaamp
3. wget https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.nr_v138.1.tgz
4. tar -xf silva.nr_v138.1.tgz
5. rm silva.nr_v138.1.tgz
6. ln -s silva.nr_v138_1.align silva.nr.fasta
7. ln -s silva.nr_v138_1.tax silva.nr.tax
8. ln -s /bio/databases/metaamp /bio/bin/ribosomal/metaamp/bin/database
9. cd ..

Metaamp needs code edits to run. Best to do manually:
1. In file get_diversity.pl, comment out the line $projDir =~ s/\/bin//;
2. In file global.pl,  comment out the line $projDir =~ s/\/bin//;
3. getOTUTaxonTable.relabund.pl, change line 96 to if(exists $table{"$prefix\_$otuid"}->{$sample} && $totals{$sample}>0){

# phyloflash
1. mkdir phyloflash
2. cd phyloflash
3. source /bio/bin/profile
4. phyloFlash_makedb.pl --remote
5. cd ..

# gtdbtk
1. mkdir gtdbtk
2. cd gtdbtk
3. wget https://data.gtdb.ecogenomic.org/releases/latest/auxillary_files/gtdbtk_data.tar.gz
4. tar -xf gtdbtk_data.tar.gz
5. rm gtdbtk_data.tar.gz
6. cd ..

# checkm
1. mkdir checkm
2. cd checkm
3. wget "https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz"
4. tar -xf checkm_data_2015_01_16.tar.gz
5. rm checkm_data_2015_01_16.tar.gz
6. cd ..
7. source /bio/bin/python-env/bin/activate
8. checkm data setRoot /bio/databases/checkm
9. deactivate

# virsorter
1. cd /bio/databases
2. wget https://osf.io/v46sc/download
3. tar -xf download
4. mv db virsorter
5. source /bio/bin/python-env/bin/activate
6. virsorter config --init-source --db-dir=./virsorter/
7. deactivate

# antismash
1. source /bio/bin/antismash-env/bin/activate
2. download-antismash-databases
3. deactivate
4. mkdir /bio/databases/antismash
5. cp -rf /bio/bin/antismash-env/lib/python3.10/site-packages/antismash/databases/* /bio/databases/antismash
6. rm -rf /bio/bin/antismash-env/lib/python3.10/site-packages/antismash/databases
7. ln -sf /bio/databases/antismash /bio/bin/antismash-env/lib/python3.10/site-packages/antismash/databases
8. To enable running antismash with python-env activated, create a file "antismash" in /bio/bin with the following content:

   #!/bin/sh  
   CURRENT_VIRTUAL_ENV=$VIRTUAL_ENV  
   source /bio/bin/antismash-env/bin/activate  
   antismash "$@"  
   deactivate  
   source $CURRENT_VIRTUAL_ENV/bin/activate

# repeatmasker
To configure repeatmasker:
1. source /bio/bin/profile if not already sourced
2. cd /bio/bin/repeatMasker
3. ./configure (accept all default options, set search engine to rmblast)

# BMGE
To complete installation:
1. cd /bio/bin/BMGE/src
2. echo Main-Class: BMGE > MANIFEST.MF
3. jar -cmvf MANIFEST.MF BMGE.jar BMGE.class bmge/*.class
4. rm MANIFEST.MF BMGE.class bmge/*.class
