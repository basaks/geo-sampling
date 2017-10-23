# Buffer along Roads and then sample representatively
############################################################
Buffer_Sample <- function(covariate_file, data_folder, shape_file, output_folder, no_samples, width){

source("show_save_statistics.R")
source("install_import_packages.R")
source("Read_Covariates.R")
  
required_packages <- c("raster","clhs","rgdal","moments","rgeos")
dummy <- install_import_packages(required_packages)

#Read only one covaraite file for some statistics
all_cov_files <- Parse_Text(covariate_file)
r <- raster(all_cov[1,])

road_shapefile <- readOGR(dsn = data_folder, layer = shape_file, verbose = FALSE)
road_buff <- gBuffer(road_shapefile, byid = TRUE, width = width)
pdf("Buffered_Roads.pdf")
plot(road_buff)
dev.off()  
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

df <- data.frame(road_extracted[1])
for(i in 2:length(road_extracted)) df <- rbind(df , data.frame(road_extracted[i]))
locations <- df[,1]
print(paste("Total number of pixels is", as.character(r@ncols * r@nrows), ",", length(locations), "pixels extracted along the roads.", sep = " "))


df <- Read_Covariates(covariate_file, locations)

# cov_intersected <- extract(cov_stack,locations)
# df <- data.frame(cov_intersected)
# 
# #Convert to categorical
# for(i in 1:length(cov_stack@layers)) 
#   if(cov_stack@layers[[i]]@data@isfactor) 
#     df[,i] <- as.factor(df[,i])

for (i in no_samples){  
  dsn_folder_cLHS = paste(output_folder, paste0("cLHS_", i,"points"), sep = "/")
  dir.create(dsn_folder_cLHS, recursive = TRUE)
  print(paste("Executing the cLHS to find", as.character(i), "points",sep = " "))
  res <- clhs(df, size = i, iter = 10000, progress = TRUE, simple = FALSE , weights = list(numeric = 1, factor = 1, correlation =1))
  
  RND_samples <- sample(1:length(locations),i)
  dummy <- show_save_statistics(cov_names, res, RND_samples, dsn_folder_cLHS)
}

pdf("Objective Function.pdf")
plot(res)
dev.off()
}
