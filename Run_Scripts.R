covariate_file = "/home/masoud/GA_data/GA-cover2/sirsam_covariates_Na.txt" #
sirsam_data = "/home/masoud/GA_data/GA-cover2"; # Where your input data exist
#sirsam_data = "/short/ge3/jrw547/GA-cover2"
exp_folder = "."   # Output folder
no_samples = c( 32 , 64) # Number of output samples. Try different values or for example use seq(20,50,10) to have 20 30 40 50 sampled points

source("Buffer_Sample.R")
source("sample_clhs.R")

#First scenario: Buffering along the roads and then sampling
width = 0.005 # Buffer size
road_shapefile_name = "Roads_Sir_Sam"  # Line segments
Buffer_Sample(covariate_file, sirsam_data, road_shapefile_name, exp_folder, no_samples, width)

#Second scenario: Sample when target points are available
shapefile_name = "geochem_sites" # geochem_sites_log Traget points
sample_clhs(covariate_file, sirsam_data, shapefile_name, exp_folder, no_samples)


#existing_model = "/home/masoud/Intenship/LHS/geo-sampling/sirsam_Na_original_prediction.tif"
#source("sample_clhs_existing_model.R")
#sample_clhs_existing_model(covariate_file, sirsam_data, shapefile_name, exp_folder, no_samples, existing_model)

#source("sample_balanced.R")
#sample_balanced(covariate_file, sirsam_data, shapefile_name, exp_folder, no_samples)


