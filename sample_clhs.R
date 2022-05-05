#Intersect rasters with target points and then sample representatively
############################################################
sample_clhs <- function(covariate_list, output_folder, no_samples,
                        shapefile_name = NULL, existing_model = NULL, downsample = NULL) {
  
  source("install_import_packages.R")
  source("Read_Covariates.R")
  
  required_packages <- c("raster","clhs","rgdal","moments")
  dummy <- install_import_packages(required_packages)
  
  if (!is.null(shapefile_name)) {
    S <- readOGR(dsn = shapefile_name, verbose = FALSE)
  } else {
    S <- NULL
  }

  raster_sp <- Read_Covariates(covariate_list , S, existing_model, downsample)

  for (i in no_samples){  
    dsn_folder_cLHS = paste(output_folder, paste0("cLHS_", i,"points"), sep = "/")
    dir.create(dsn_folder_cLHS, recursive = TRUE)
    print(paste("Running cLHS to sample", as.character(i),"points. Check", 
                dsn_folder_cLHS,"for results when finished."))
    res <- clhs(raster_sp, size = i, iter = 10000, progress = TRUE, simple = FALSE , 
                weights = list(numeric = 1, factor = 1, correlation =1))
    S_clhs <- raster_sp[res$index_samples,]
    writeOGR(S_clhs, dsn = dsn_folder_cLHS, layer = "cLHS_output", 
             driver = "ESRI Shapefile", overwrite_layer = TRUE)
    dsn_folder_RND = paste(output_folder, paste0("RND_", i,"points"), sep = "/")
    dir.create(dsn_folder_RND, recursive = TRUE)
    print(paste("Randomly sampling", as.character(i),"points. Check", dsn_folder_RND,"for results."))
    RND_samples <- sample(1:nrow(raster_sp),i)
    S_RND <- raster_sp[RND_samples,]
    writeOGR(S_RND, dsn = dsn_folder_RND, layer = "RND_output", 
             driver = "ESRI Shapefile", overwrite_layer = TRUE)
    pdf(paste(dsn_folder_cLHS,"Objective_Function.pdf", sep = '/'))
    plot(res)
    dev.off()
  }

}
