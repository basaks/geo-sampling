# Buffer along Roads and then sample representatively
############################################################
Buffer_Sample <- function(covariate_list, data_folder, shape_file, output_folder, no_samples, width, existing_model = NULL){
  
source("install_import_packages.R")
source("show_save_statistics.R")
source("Read_Covariates.R")
  
#import the requirements 
required_packages <- c("raster","clhs","rgdal","moments","rgeos")
dummy <- install_import_packages(required_packages)

#Read only one covaraite file for some statistics
all_cov_files <- Parse_Text(covariate_list)
r <- raster(all_cov_files[1,])

road_shapefile <- readOGR(dsn = data_folder, layer = shape_file, verbose = FALSE)
road_buff <- gBuffer(road_shapefile, byid = TRUE, width = width)

#dev.print(pdf, paste(output_folder,"Buffered_Roads.pdf",sep = "/"))

road_filename <- paste(output_folder,paste0("roads_Buffer_",as.character(width)),sep = "/")
if(!file.exists(road_filename)){
  print("Extracting points along the roads. This might take a few minutes. Points are saved for later use.")
  #Intersect one of the rasters to extract locations
  road_extracted <- extract(r,road_buff, cellnumbers=TRUE)
  dput(road_extracted,road_filename)
} else{
  print(paste("Using the pre-extracted points along the roads from", road_filename, sep = " "))
  road_extracted <- dget(road_filename)
}

#Extracting coordinates of the road (line) segments 
df <- data.frame(road_extracted[1])
for(i in 2:length(road_extracted)) df <- rbind(df , data.frame(road_extracted[i]))
locations <- df[,1]
print(paste("Total number of pixels is", as.character(r@ncols * r@nrows), ",", length(locations), "pixels extracted along the roads.", sep = " "))

#Reading the given covariates and intersecting with the road segments
df <- Read_Covariates(covariate_list, locations, existing_model)

r_coords <- coordinates(r)
r_coords <- r_coords[locations,]

# Sample and save the results
for (i in no_samples){  
  dsn_folder_cLHS = paste(output_folder, paste0("cLHS_", i,"points"), sep = "/")
  dir.create(dsn_folder_cLHS, recursive = TRUE)
  print(paste("Executing the cLHS to find", as.character(i), "points",sep = " "))
  res <- clhs(df, size = i, iter = 10000, progress = TRUE, simple = FALSE , weights = list(numeric = 1, factor = 1, correlation =1))
  
  RND_samples <- sample(1:length(locations),i)
  dummy <- show_save_statistics(colnames(df), res, RND_samples, dsn_folder_cLHS)
  
  pdf(paste(dsn_folder_cLHS,"Objective_Function.pdf", sep = '/'))
  plot(res)
  dev.off()
  
  pdf(paste(dsn_folder_cLHS,"Buffered_Roads.pdf", sep = '/'))
  plot(road_buff)
  points(r_coords[res$index_samples,], col = 'red')
  dev.off()
}
}
