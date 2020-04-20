# geo-sampling
A collection of geoscience based sampling tools.

## Environment 
Minimum R version: 3.4

Has been tested on R 3.6, later versions may also work.

## Requirements
Required system packages:
- GDAL
- PROJ

Required R packages:
- raster
- clhs
- rgdal
- moments
- rgeos
- BalancedSampling

## Installation
If R packages are not installed, geo-sampling will attempt to install required R packages from CRAN.

Otherwise, they can be installed using:

`install.packages(c('raster, 'clhs', 'rgdal', 'moments', 'rgeos', 'BalancedSampling'))`

There are also some scripts to assist with installing on Gadi (NCI) and Ubuntu 18.04.

*Note: at time of writing, cLHS is not available on CRAN. It will have to be downloaded and 
installed manually. See the installation scripts for details on how to do this.*

### Gadi:
By default, R libraries will be installed to your home directory on the NCI. In some cases,
such as if you want other people to be able to submit jobs using your geo-sampling installation, 
you may wish to install the R libraries to a g/data directory. To do this, set the desired R library 
path by setting the `R_LIBS` environment variable:

`export R_LIBS="/path/to/R/library`

To install, run:

`./gadi_install.sh`

### Ubuntu 18.04
The Ubuntu scripts installs required system packages (GDAL, PROJ) and R packages. Installing 
system packages requires sudo privileges, so this script may request your unix password.

By default, R libraries will be installed to the R user library directory 
(`"$HOME/R/x86_64-pc-linux-gnu-library/3.4/"`). If you wish to install to a different directory,
you can modify the `LIB_PATH` variable on line 15 of the installation script.

To install, run:

`./ubuntu1804_install.sh`

## How To Use
Configurations are stored in "Run_Scripts.R" file. So, first make your changes (e.g. change the input pathes to your choice).
 
Currently the following functionalities are supported:

<a href="http://www.sciencedirect.com/science/article/pii/S009830040500292X"> conditioned Latin Hypercube Sampling (cLHS) </a>
- To extract a handful of points at the target locations, </li>
- To first extract points around given a buffer size and then extract a handful of points, </li>
- The above scenarios with an existing model to weight the inputs. </li>

Comment or uncomment relevant lines in the file `Run_Scripts.R` according to what functionality you 
want and then from within the `geo-sampling` directory, run:

`Rscript Run_Scripts.R`

Once complete, check the output folder for results.

For more detailed instructions, see: <a href="https://github.com/GeoscienceAustralia/geo-sampling/blob/master/GeoSampling_Walkthrough.pdf"> walkthrough </a>

### Gadi
When running on the NCI, you also need to load the required modules and set up your R library path
before running a job. These can be loaded with the following commands:

```
module load R/3.6.1
module load gdal/3.0.2
module load proj/6.2.1
```

The `Run_NCI.sh` script will assist with this, and can be used as a template for submitting jobs.
Make sure you set the `R_LIBS` variable in the script to the directory where you installed your
libraries on the NCI!
