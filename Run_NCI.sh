module unload intel-fc intel-cc
module load intel-fc/16.0.3.210
module load intel-cc/16.0.3.210
module load gdal/2.1.3
module load  proj/4.8.0
module load geos/3.5.0

module load  R/3.4.0
Rscript Run_Scripts.R
#R --vanilla  output


