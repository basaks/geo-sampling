covariate_file = "sirsam_covariates_Cr.txt"#
sirsam_data = "/home/masoud/GA_data/GA-cover2"; # Where your input data exist
#sirsam_data = "/short/ge3/jrw547/GA-cover2"
shapefile_name = "geochem_sites" # Traget points
exp_folder = "."   # Output folder
no_samples = 50 # Number of output samples. Try different values or for example use seq(20,50,10) to have 20 30 40 50 sampled points

source("sample_clhs.R")
sample_clhs(covariate_file, sirsam_data, shapefile_name, exp_folder, no_samples)

#width = 0.005 # Buffer size
#road_shapefile_name = "Roads_Sir_Sam"  # Line segments
#source("Buffer_Sample.R")
#Buffer_Sample(covariate_names, sirsam_data, road_shapefile_name, exp_folder, no_samples, width)
