#!/usr/bin/env bash

exit_on_failure() {
    if [[ $1 != 0 ]]
    then
        echo $2
        exit 1
    fi
}

echo "This script assists with installing 'geo-sampling' on Ubuntu"\
     "18.04. It will install GDAL, PROJ and R, and required R packages,"\
     "onto your system."

LIB_PATH="$HOME/R/x86_64-pc-linux-gnu-library/3.6/"

echo "Using '$LIB_PATH' as R library path. If this is incorrect, change"\
     "'LIB_PATH' in this script."

if [[ ! -d "$LIB_PATH" ]] 
then
    echo "R library path '$LIB_PATH' does not exist. Please create it or"\
         "ensure the directory is correct."
    exit 0
fi

read -p "Continue? (y|Y)" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Installing GDAL, PROJ and R... (this requires sudo privileges)"
    sudo apt-get update
    sudo apt-get install gdal-bin libgdal-dev libproj-dev r-base

    echo "Installing R packages..."

    CUR_DIR=`pwd`

    echo "Installing 'raster', 'moments', 'rgeos', 'BalancedSampling', 'ggplot2', 'reshape2', 'plyr', 'scales'"
    R --slave -e "install.packages(c('raster', 'moments', 'rgeos', 'BalancedSampling', 'ggplot2', 'reshape2', 'plyr', 'scales'), lib='$LIB_PATH')"
    exit_on_failure $? "Could not install R packages."

    echo "'clhs' is not available on CRAN (at time of writing - 14/04/2020)."\
         "Need to download CLHS from archive and install from local package."
    cd /tmp
    curl -O https://cran.r-project.org/src/contrib/Archive/clhs/clhs_0.7-2.tar.gz
    tar -zxf clhs_0.7-2.tar.gz
    R --slave -e "install.packages('/tmp/clhs', repos=NULL, type='source', lib='$LIB_PATH')"
    RET=$?
    rm -r clhs
    rm clhs_0.7-2.tar.gz
    exit_on_failure $RET "Could not install 'clhs'"

    echo "Latest versions of 'rgdal' are not compatible with R 3.4.4"\
         "(Ubuntu 18.04 default version). Need to download rgdal 1.4.4"\
         "from archive and install from local package."
    curl -O https://cran.r-project.org/src/contrib/Archive/rgdal/rgdal_1.4-4.tar.gz
    tar -zxf rgdal_1.4-4.tar.gz
    R --slave -e "install.packages('/tmp/rgdal', repos=NULL, type='source', lib='$LIB_PATH')"
    RET=$?
    rm -r rgdal
    rm rgdal_1.4-4.tar.gz
    exit_on_failure $RET "Could not install 'rgdal'"

    
    echo "Installation complete. See 'Run_Scripts.R' for examples on using 'geo-sampling'."
    cd $CUR_DIR
fi
