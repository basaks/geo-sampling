#Intersect rasters with target points and then sample representatively
############################################################
sample_clhs <- function(covariate_file, data_folder, shape_file, output_folder, no_samples){
  
  source("install_import_packages.R")
  required_packages <- c("raster","clhs","rgdal","moments")
  dummy <- install_import_packages(required_packages)
  
  source("Read_Covariates.R")
  cov_stack <- Read_Covariates(covariate_file,data_folder)
  
  S <- readOGR(dsn = data_folder, layer = shape_file, verbose = FALSE)
  print(paste(shape_file,"with",as.character(length(S$SampleID)),"points was read. Intersecting that with the input covariates."))
  #Intersect the covariates with the target locations
  cov_intersected <- extract(cov_stack, S)
  df <- data.frame(cov_intersected)
  
  #Convert to categorical
  for(i in 1:length(cov_stack@layers)) 
    if(cov_stack@layers[[i]]@data@isfactor) 
      df[,i] <- as.factor(df[,i])
  
  #old_par <- par()
  
  for (i in no_samples){  
    #par(mfrow = c(3,1))
    dsn_folder_cLHS = paste(output_folder, paste0("cLHS_", i,"points"), sep = "/")
    dir.create(dsn_folder_cLHS, recursive = TRUE)
    print(paste("Running cLHS to sample", as.character(i),"points. Check", dsn_folder_cLHS,"for results when finished."))
    res <- clhs(df, size = i, iter = 10000, progress = TRUE, simple = FALSE , weights = list(numeric = 1, factor = 1, correlation =1))
    
    S_clhs <- S[res$index_samples,]
    #plot(coordinates(S_clhs))
    writeOGR(S_clhs, dsn = dsn_folder_cLHS, layer = paste(shape_file, as.character(i), "cLHS", sep = "_"), driver = "ESRI Shapefile", overwrite_layer = TRUE)
    
    #  dsn_folder_RND = paste(output_folder, paste0("RND_", i,"points"), sep = "/")
    #  RND_samples <- sample(1:nrow(S),i)
    #  S_RND <- S[RND_samples,]
    #  writeOGR(S_RND, dsn = dsn_folder_RND, layer = shape_file, driver = "ESRI Shapefile", overwrite_layer = TRUE)
    #plot(coordinates(ss), add=TRUE )
    
    #Save histograms in the folders
    # for(i in 1:length(cov_names)){
    #    pdf(paste(dsn_folder_cLHS, paste0(cov_names[i],".pdf"), sep = "/"))
    
    #    tmp_cov <- res$initial_object[[i]]
    #    if(!is.numeric(tmp_cov))  tmp_cov <- as.numeric(tmp_cov)
    #    hist(tmp_cov, main = paste("Original histogram of",cov_names[i]), xlab = paste("Mean:",mean(tmp_cov), ", Variance", var(tmp_cov)), freq = FALSE)
    #    tmp_cov <- res$sampled_data[[i]]
    #    if(!is.numeric(tmp_cov))  tmp_cov <- as.numeric(tmp_cov)
    #    hist(tmp_cov, main = paste("cLHS histogram of",cov_names[i]), xlab = paste("Mean:",mean(tmp_cov), ", Variance", var(tmp_cov)), freq = FALSE)
    #    tmp_cov <- res$initial_object[[i]][RND_samples]
    #    if(!is.numeric(tmp_cov))  tmp_cov <- as.numeric(tmp_cov)
    #    hist(tmp_cov, main = paste("RND histogram of",cov_names[i]), xlab = paste("Mean:",mean(tmp_cov), ", Variance", var(tmp_cov)), freq = FALSE)
    #dev.print(pdf, paste(dsn_folder_cLHS, paste0(cov_names[i],".pdf"), sep = "/"))
    #    dev.off()
    # }
  }
  par(mfrow = c(1,1))
  pdf("Objective Function.pdf")
  plot(res)
  dev.off()
}
#dev.print(pdf, paste(dsn_folder_cLHS, "cost.pdf", sep = "/"))
