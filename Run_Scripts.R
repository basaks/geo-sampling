source("Buffer_Sample.R")
source("sample_clhs.R")

# A text file of format:

    # /path/to/tif1.tif c
    # /path/to/tif2.tif n

# Where 'c' indicates categorical covariate and 'n' indicates numerical covariate
# Insert '#' at the begining of a line to exclude the covariate
covariate_list = "/path/to/list.txt"

# Output folder. Results will be written to shapefiles in this directory.
exp_folder = "."

# Number of output samples. For example use 'c(20,40,60)' to produce 20, 40 and 60 samples in their
# shapefiles.
n_samples = c( 32, 64 ) 

# Tested workflows (comment out the calls to 'sample_clhs' that you don't want):

# Peform cLHS sampling on covariates without any intersection or downsampling
sample_clhs(covariate_list, exp_folder, n_samples)

# Intersect covariate stack with shapefile points and sample the intersected data
shapefile_dir = "/path/to/shapefile/directory"
shapefile_name = "name_of_shapefile" # Without extension.
sample_clhs(covariate_list, exp_folder, n_samples, shapefile_dir=shapefile_dir, shapefile_name=shapefile_name)

# Downsample the covariates before sampling, in this case downsample covariates to 500 points
# Note downsampling and shapefile intersection are not compatible
sample_clhs(covariate_list, exp_folder, n_samples, downsample = 500)

# Use a previous model as weighting
# Compatible with all the above workflows
existing_model = '/path/to/model.tif'
sample_clhs(covariate_list, exp_folder, n_samples, existing_model=existing_model)

# Please note below workflows haven't been tested recently:
# input_data = shapefile_dir

#First scenario: Buffering along the roads and then sampling
#width = 0.005 # Buffer size
#road_shapefile_name = "Roads_Sir_Sam"  # Line segments
#Buffer_Sample(covariate_list, input_data, road_shapefile_name, exp_folder, n_samples, width)

#Second scenario: Sample when target points are available
# sample_clhs(covariate_list, exp_folder, n_samples)
# sample_clhs(covariate_list, exp_folder, n_samples, downsample=5)
# sample_clhs(covariate_list, exp_folder, n_samples, shapefile_dir=shapefile_dir, shapefile_name=shapefile_name)

#Third scenario: Similar to the first scenario but with an existing model used for weighting the inputs
#width = 0.005 # Buffer size
#existing_model = "./sirsam_Na_original_prediction.tif"
#road_shapefile_name = "Roads_Sir_Sam"  # Line segments
#Buffer_Sample(covariate_list, input_data, road_shapefile_name, exp_folder, n_samples, width, existing_model)

#Fourth scenario: Similar to the second scenario but with an existing model used for weighting the inputs
#existing_model = "./sirsam_Na_original_prediction.tif"
#shapefile_name = "geochem_sites" # geochem_sites_log Traget points
#sample_clhs(covariate_list, input_data, shapefile_name, exp_folder, n_samples, existing_model)

#Balanced sampling. All covariates must be continues valued, no categorical
#source("sample_balanced.R")
#shapefile_name = "geochem_sites" # geochem_sites_log Traget points
#sample_balanced(covariate_list, input_data, shapefile_name, exp_folder, n_samples)

#LHS from a shapefile
#sample_lhs_1D(input_data, shapefile_name, exp_folder, n_samples)
