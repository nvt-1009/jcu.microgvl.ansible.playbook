# jcu.microgvl.ansible.playbook
[![DOI](https://zenodo.org/badge/78711504.svg)](https://zenodo.org/badge/latestdoi/78711504)

This is an Ansible script to install 16S tools to GALAXY in Genomics Virtual Laboratory(GVL). This GVL is deployed on Nectar infrastructure. see link https://nectar.org.au/?portfolio=genomics-virtual-lab.

```
GVL information:
Microbial GVL version: 0.11-1
Build date: 2016-05-26T05:24:31Z
```

```
Ubuntu:
Distributor ID: Ubuntu
Description:    Ubuntu 14.04.5 LTS
Release:        14.04
Codename:       trusty
```

The tutorial data can be found here:  [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.800651.svg)](https://doi.org/10.5281/zenodo.800651)

```
FragGeneScan is available through the link below
http://omics.informatics.indiana.edu/FragGeneScan/
```

How to Install:
---------------
1. obtain PEAR tool from the author (see instruction below)
2. git clone https://github.com/QFAB-Bioinformatics/jcu.microgvl.ansible.playbook
3. move the binary PEAR tarball to dictory jcu.microgvl.ansible.playbook/roles/jcu/files
4. edit file jcu.microgvl.ansible.playbook/roles/jcu/tasks/modify_galaxy.xml to replace the PEAR tarball filename by the new PEAR tarball filename
5. go back to the directory where the jcu.microgvl.ansible.playbook is cloned
6. ansible-playbook -vvv playbook.yml

Note: The latest PEAR tool should be a binary release. if not, installation is required.

```
    ____  _____    _    ____
   |  _ \| ____|  / \  |  _ \
   | |_) |  _|   / _ \ | |_) |
   |  __/| |___ / ___ \|  _ <
   |_|   |_____/_/   \_\_| \_\

```


....Paired-End reAd mergeR....

```
Authors: Jiajie Zhang, Kassian Kobert, Tomas Flouri, Alexandros Stamatakis

License: Creative Commons license
                with
Attribution-NonCommercial-ShareAlike 3.0 Unported
```
Introduction:
-------------
PEAR  assembles  Illumina paired-end reads if the DNA fragment sizes are smaller
than  twice  the length of reads. PEAR can assemble 95% of reads with 35-bp mean
overlap  with  a  false-positive rate of 0.004. PEAR also works with multiplexed
data  sets  where  the  true  underlying  DNA  fragment size varies. PEAR has an
extremely low false-positive rate of 0.0003 on data sets where no overlap exists
between  the  two  reads (i.e. when DNA fragment sizes are larger than twice the
read length).

For more information, requests and bug-reports visit our website at 

                http://www.exelixis-lab.org/web/software/pear

How to compile:
---------------
1. git clone https://github.com/xflouris/PEAR.git
2. cd PEAR
3. make
4. make install

How to run self-tests:
----------------------
1. Make sure you have python 2.4 (or newer) installed
2. Go to the "test" folder
3. type: ./test.py

This  will run PEAR on several simulated data sets with various options to check
if the newly compiled program works properly.

How to use:
-----------
PEAR  can  robustly  assemble most of the data sets with default parameters. The
basic command to run PEAR is

  ./pear -f forward_read.fastq -r reverse_read.fastq -o output_prefix

The forward_read file usually has "R1" in the name, and the reverse_read
file usually has "R2" in the name.

Output files:
-------------
PEAR produces 4 output files:

1. output_prefix.assembled.fastq - the assembled pairs
2. output_prefix.unassembled.forward.fastq - unassembled forward reads
3. output_prefix.unassembled.reverse.fastq - unassembled reverse reads
4. output_prefix.dicarded.fastq  - reads which did not meet criteria specified in options

Advanced usage:
---------------

For further options and fine-tuning type
  
  ./pear -h  

Important information:
----------------------
1. The input files must be in FASTQ format
2. PEAR  does not check the paired-end reads names. PEAR assumes that the reads
in  both files are in the same flowcell position if they appear on the same line
number.  Therefore,  the  validity  of  the  input  files  is  left  as  a  user
responsibility.

How to cite:
------------
J. Zhang, K. Kobert, T. Flouri, A. Stamatakis. PEAR: A fast and accurate Illimuna Paired-End reAd mergeR
