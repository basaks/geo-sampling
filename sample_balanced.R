#Intersect rasters with target points and then sample representatively
############################################################
sample_balanced <- function(covariate_file, data_folder, shape_file, output_folder, no_samples){
  source("install_import_packages.R")
  required_packages <- c("raster","BalancedSampling","rgdal","moments")
  dummy <- install_import_packages(required_packages)
  
  source("Read_Covariates.R")
  cov_stack <- Read_Covariates(covariate_file,data_folder)
  
  S <- readOGR(dsn = data_folder, layer = shape_file, verbose = FALSE)
  print(paste(shape_file,"with",as.character(length(S$SampleID)),"points was read. Intersecting that with the input covariates."))
  #Intersect the covariates with the target locations
  cov_intersected <- extract(cov_stack, S)
  df <- data.frame(cov_intersected)
  
  print("Categorical covariates (if any) will be removed for blanaced sampling.")
  #Remove categorical (if any)
  len1 <- length(cov_stack@layers)
  i <- 1
  j <- 1
  while(i <= len1){ 
    if(cov_stack@layers[[j]]@data@isfactor){
      df[,i] <- NULL
      len1 <- len1 - 1
    }
    else{
      i <- i + 1
    }
    j <- j + 1
  }
  df <- as.matrix(df)
  #df <- df[1:100,]
  N = NROW(df); # population size
  for (i in no_samples){
    p = rep(i/N,N); # inclusion probabilities
    #X = cbind(p , df)
    dsn_folder_balanced = paste(output_folder, paste0("Balanced_", i,"points"), sep = "/")
    dir.create(dsn_folder_balanced, recursive = TRUE)
    print(paste("Running Balanced Sampling to sample", as.character(i),"points. Check", dsn_folder_balanced,"for results when finished."))
    index_samples <- NULL
    while(length(index_samples) != i){
      index_samples = lpm1(p,df)
      if(any(index_samples == 0))
        index_samples <- NULL
    }
    S_Balanced <- S[index_samples,]
    writeOGR(S_Balanced, dsn = dsn_folder_balanced, layer = paste(shape_file, as.character(i), "Balanced", sep = "_"), driver = "ESRI Shapefile", overwrite_layer = TRUE)
    
    dsn_folder_RND = paste(output_folder, paste0("RND_", i,"points"), sep = "/")
    dir.create(dsn_folder_RND, recursive = TRUE)
    print(paste("Randomly sampling", as.character(i),"points. Check", dsn_folder_RND,"for results."))
    RND_samples <- sample(1:nrow(S),i)
    S_RND <- S[RND_samples,]
    writeOGR(S_RND, dsn = dsn_folder_RND, layer = paste(shape_file, as.character(i), "RND", sep = "_"), driver = "ESRI Shapefile", overwrite_layer = TRUE)
  }
}
