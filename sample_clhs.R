#Intersect rasters with target points and then sample representatively
############################################################
sample_clhs <- function(covariate_list, data_folder, shape_file, output_folder, no_samples){
  
  source("install_import_packages.R")
  source("Read_Covariates.R")
  
  required_packages <- c("raster","clhs","rgdal","moments")
  dummy <- install_import_packages(required_packages)
  
  S <- readOGR(dsn = data_folder, layer = shape_file, verbose = FALSE)
  print(paste(shape_file,"with",as.character(length(S$SampleID)),"points was read. Intersecting that with the input covariates."))
  
  df <- Read_Covariates(covariate_list , S)
  
  #  cov_intersected <- extract(cov_stack, S)
  #df <- data.frame(cov_intersected)
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
    
    dsn_folder_RND = paste(output_folder, paste0("RND_", i,"points"), sep = "/")
    dir.create(dsn_folder_RND, recursive = TRUE)
    print(paste("Randomly sampling", as.character(i),"points. Check", dsn_folder_RND,"for results."))
    RND_samples <- sample(1:nrow(S),i)
    S_RND <- S[RND_samples,]
    writeOGR(S_RND, dsn = dsn_folder_RND, layer = paste(shape_file, as.character(i), "RND", sep = "_"), driver = "ESRI Shapefile", overwrite_layer = TRUE)
    #plot(coordinates(ss), add=TRUE )
    
    pdf(paste(dsn_folder_cLHS,"Objective_Function.pdf", sep = '/'))
    plot(res)
    dev.off()
  }
}
#dev.print(pdf, paste(dsn_folder_cLHS, "cost.pdf", sep = "/"))
