sample_lhs_1D <- function(data_folder, shape_file, output_folder, no_samples){
  required_packages <- c("rgdal")
  dummy <- install_import_packages(required_packages)
  
  S <- readOGR(dsn = data_folder, layer = shape_file, verbose = FALSE)
  print(paste(shape_file,"with",as.character(nrow(S@coords)),"points was read."))
  
  my_data <- S$K_ppm_imp
  #Generate LHS samples [0,1]
  Quants <- (sample(no_samples) - runif(no_samples)) / no_samples
  samples <- quantile(my_data, Quants, type = 1)
  
  samplede_indexes = c(1:no_samples)
  #Finding indexes in input data
  for(i in 1:no_samples){
    tmp_diff = abs(samples[i] - my_data)
    samplede_indexes[i] <- which.min(tmp_diff)
  }
  new_data <- my_data[samplede_indexes]
  
  # plot(my_data, 1:length(my_data))
  # points(new_data,samplede_indexes, col = "red")
  
  new_S <- S[samplede_indexes,]
  #plot(coordinates(new_S))
  dsn_folder_LHS = paste(output_folder, paste0("LHS_", i,"points"), sep = "/")
  dir.create(dsn_folder_LHS, recursive = TRUE)
  
  writeOGR(new_S, dsn = dsn_folder_LHS, layer = paste(shape_file, as.character(i), "LHS", sep = "_"), driver = "ESRI Shapefile", overwrite_layer = TRUE)
}
  