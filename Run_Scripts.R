# A text file containing address of each input .tif covariate in one line (insert # in the begining of a line to exclude the covariate)
covariate_file = "/home/masoud/GA_data/GA-cover2/sirsam_covariates_Cr.txt" # For Sirsam dataset
#covariate_file = "/short/ge3/jrw547/GA-cover2/sirsam_covariates_Na.txt" # For Sirsam dataset (in NCI)
#covariate_file = "/g/data1a/ge3/john/jobs/national/geochem/RF_Wii/weathering_index_LHC.txt" # For national dataset

# Where your input data (covariates and shapefile) exist
sirsam_data = "/home/masoud/GA_data/GA-cover2"; 
#sirsam_data = "/short/ge3/jrw547/GA-cover2"
#national_data = "/g/data/ge3/covariates/Sites/geochem"

exp_folder = "."   # Output folder. Where you want to store the results
no_samples = c( 32 , 64) # Number of output samples. Try different values or for example use seq(20,50,10) to have 20 30 40 50 sampled points

source("Buffer_Sample.R")
source("sample_clhs.R")

#First scenario: Buffering along the roads and then sampling
width = 0.005 # Buffer size
road_shapefile_name = "Roads_Sir_Sam"  # Line segments
Buffer_Sample(covariate_file, sirsam_data, road_shapefile_name, exp_folder, no_samples, width)

#Second scenario: Sample when target points are available
shapefile_name = "geochem_sites" # Traget points shapefile. It should be without extension.
#shapefile_name = "NGSA_IM_TOS"  # For national dataset
sample_clhs(covariate_file, sirsam_data, shapefile_name, exp_folder, no_samples)

#Third scenario: Similar to the first scenario but with an existing model used for weighting the inputs
width = 0.005 # Buffer size
existing_model = "/home/masoud/GA_data/GA-cover2/sirsam_Na_original_prediction.tif"
road_shapefile_name = "Roads_Sir_Sam"  # Line segments
Buffer_Sample(covariate_file, sirsam_data, road_shapefile_name, exp_folder, no_samples, width, existing_model)

#Fourth scenario: Similar to the second scenario but with an existing model used for weighting the inputs
existing_model = "/home/masoud/GA_data/GA-cover2/sirsam_Na_original_prediction.tif"
shapefile_name = "geochem_sites" # geochem_sites_log Traget points
source("sample_clhs_existing_model.R")
sample_clhs(covariate_file, sirsam_data, shapefile_name, exp_folder, no_samples, existing_model)

#Balanced sampling. All covariates must be continues valued, no categorical
source("sample_balanced.R")
shapefile_name = "geochem_sites" # geochem_sites_log Traget points
sample_balanced(covariate_file, sirsam_data, shapefile_name, exp_folder, no_samples)

#LHS from a shapefile
sample_lhs_1D(sirsam_data, shapefile_name, exp_folder, no_samples)
