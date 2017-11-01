# geo-sampling
  
A collection of geoscience based sampling tools.

## Environment 

R 3.4 (later versions should be fine)

## Requirements

Required packages will be installed automatically, if not found. Nevertheless, run this command in R to install prerequisites:
<br>
install.packages(c("raster","clhs","rgdal","moments","rgeos","BalancedSampling"))
<br> <br>
Also, run the script Run_NCI.sh for NCI support.

## How To Use
Configurations are stored in "Run_Scripts.R" file. So, first make your changes (e.g. change the input pathes to your choice).
<br> <br>
 
Currently the following functionalities are supported:

<a href="http://www.sciencedirect.com/science/article/pii/S009830040500292X"> conditioned Latin Hypercube Sampling (cLHS) </a>
<ul>
<li> To extract a handful of points at the target locations, or </li>
<li> To first extract points around given a buffer size and then extract a handful of points, 
</ul>
Un/comment relevant lines in the file Run_Scripts.R according to what functionality you want and then run
<br> <br>
cd "WHERE YOU HAVE STORED THIS REPOSITORY/geo-sampling
<br>
Rscript   Run_Scripts.R

<br> <br>
Check the output folder for results (new shapefile, statistics, etc).
