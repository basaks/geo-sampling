# Buffer along Roads and then sample representatively
############################################################
Buffer_Sample <- function(cov_names, data_folder, shape_file, output_folder, no_samples, width){
  
source("install_import_packages.R")
required_packages <- c("raster","clhs","rgdal","moments","rgeos")
dummy <- install_import_packages(required_packages)


r <- raster(paste(data_folder,paste0(cov_names[1],".tif"), sep = "/"))
cov_stack <- stack(r)
for(i in 2:length(cov_names)){
  r <- raster(paste(data_folder,paste0(cov_names[i],".tif"), sep = "/"))
  cov_stack <- stack(cov_stack,r)
}

road_shapefile <- readOGR(dsn = data_folder, layer = shape_file, verbose = FALSE)
road_buff <- gBuffer(road_shapefile, byid = TRUE, width = width)
plot(road_buff)
dev.print(pdf, paste(output_folder,"Buffered_Roads.pdf",sep = "/"))


#Intersect one of the rasters to extract locations
road_extracted <- extract(r,road_buff, cellnumbers=TRUE)
df <- data.frame(road_extracted[1])
for(i in 2:length(road_extracted)) df <- rbind(df , data.frame(road_extracted[i]))
locations <- df[,1]

cov_intersected <- extract(cov_stack,locations)
df <- data.frame(cov_intersected)
#Convert to categorical
df$si_geol1 <- as.factor(df$si_geol1)

par(mfrow = c(3,1))

for (i in no_samples){  
  dsn_folder_cLHS = paste(output_folder, paste0("cLHS_", i,"points"), sep = "/")
  dir.create(dsn_folder_cLHS, recursive = TRUE)
  res <- clhs(df, size = i, iter = 5000, progress = FALSE, simple = FALSE )
  
  dsn_folder_RND = paste(output_folder, paste0("RND_", i,"points"), sep = "/")
  RND_samples <- sample(1:length(locations),i)
  
  #Save histograms in the folders
  for(i in 1:length(cov_names)){
    tmp_cov <- res$initial_object[[i]]
    if(!is.numeric(tmp_cov))  tmp_cov <- as.numeric(tmp_cov)
    hist(tmp_cov, main = paste("Original histogram of",cov_names[i]), xlab = paste("Mean:",mean(tmp_cov), ", Variance", var(tmp_cov)), freq = FALSE)
    tmp_cov <- res$sampled_data[[i]]
    if(!is.numeric(tmp_cov))  tmp_cov <- as.numeric(tmp_cov)
    hist(tmp_cov, main = paste("cLHS histogram of",cov_names[i]), xlab = paste("Mean:",mean(tmp_cov), ", Variance", var(tmp_cov)), freq = FALSE)
    tmp_cov <- res$initial_object[[i]][RND_samples]
    if(!is.numeric(tmp_cov))  tmp_cov <- as.numeric(tmp_cov)
    hist(tmp_cov, main = paste("RND histogram of",cov_names[i]), xlab = paste("Mean:",mean(tmp_cov), ", Variance", var(tmp_cov)), freq = FALSE)
    dev.print(pdf, paste(dsn_folder_cLHS, paste0(cov_names[i],".pdf"), sep = "/"))
  }
}

par(mfrow = c(1,1))
plot(res)

#df <- data.frame(rat15thk,tot15,modis4_te,si_geol1)
#df$si_geol1 <- as.factor(df$si_geol1)
#res <- clhs(df, size = no_samples, iter = 5000, progress = FALSE, simple = FALSE )
}
#cov_stack <- stack(rat15thk, tot15, modis4_te, si_geol1)