# geo-sampling

A collection of geoscience based sampling tools.

## Environment 

R 3.4 version (later versions should be fine)

## Requirements

Required packages will be installed automatically, if not found.

## How To Use
Configurations are stored in "Run_Scripts.R" file. So, first make your changes (e.g. change the input pathes to your choice).

Currently the following functionalities are supported:

To see a demo of extracting raster cells that are touched by a road, run

source("WHERE YOU HAVE STORED THIS REPOSITORY/geo-sampling/Extract_demo_ex1.R", chdir = TRUE)

To see a demo of extracting raster cells that are located within a margin around roads, run

source("WHERE YOU HAVE STORED THIS REPOSITORY/geo-sampling/Extract_demo_ex2.R", chdir = TRUE)

To extract a handfull of points at the target locations, run

source("WHERE YOU HAVE STORED THIS REPOSITORY/geo-sampling/Run_Scripts.R", chdir = TRUE)

