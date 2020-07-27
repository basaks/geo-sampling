#!/bin/bash
#PBS -P ge3
#PBS -q normal
#PBS -l walltime=02:00:00,mem=190GB,ncpus=1,jobfs=100GB
#PBS -l storage=gdata/ge3
#PBS -l wd
#PBS -j oe

module load R/3.6.1
module load gdal/3.0.2
module load proj/6.2.1

# If you've installed your R libs somewhere other than the default
# $HOME/R directory, set that directory here:
# export R_LIBS=

Rscript Run_Scripts.R
