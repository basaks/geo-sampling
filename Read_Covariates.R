#Parse the input text file containing covaraites
############################################################
Parse_Text <- function(cov_file) {
  all_cov <- read.table(cov_file)
  fnames <- c()
  for (i in 1:nrow(all_cov)){
    fname <- c(trimws(as.character(all_cov[, 1][i])), as.character(all_cov[, 2][i]))
    if (!startsWith(fname[1] , "#")){
      fnames <- rbind(fnames, fname)
    }
  }
  rownames(fnames) <- c()
  return(fnames)
}

#Read input covariates from a text file, intersect with targets or road buffer and return a data frame
############################################################
Read_Covariates <- function(cov_file, to_be_intersected = NULL, existing_model = NULL, downsample = NULL) {
 
  if(!is.null(existing_model)){
    previous_model <- raster(existing_model)
    tmp_w <- values(previous_model)
    tmp_w[is.na(tmp_w)] <- 0
    values(previous_model) <- tmp_w
    previous_model <- values(previous_model) / max(values(previous_model), na.rm = TRUE)
    print(paste("Existing prediction at" , existing_model, "will be used as weight."))
  }
    
  all_cov <- Parse_Text(cov_file)
  print("Reading input covariates.")


  # If shapefile intersection is available, reproject all rasters to
  # shapefile CRS. Otherwise take first raster CRS and reproject all
  # others to this CRS.
  if (!is.null(to_be_intersected)) {
      expected_CRS <- to_be_intersected@proj4string
      print(paste("Expected CRS is shapefile CRS", expected_CRS))
  } else {
      expected_CRS <- raster(all_cov[1, 1])@crs
      print(paste("Expected CRS is first raster CRS", expected_CRS))
  }

  
  rasters <- c()
  for(i in 1:nrow(all_cov)){
    fname <- all_cov[i, 1]
    r <- raster(fname)

    #CRS check
    if(!compareCRS(expected_CRS,r@crs)) {
      print(paste("CRS mismatch, reprojecting", fname, "to expected CRS"))
      r <- projectRaster(from=r, crs=expected_CRS)
    }

    is_categorical <- identical(all_cov[i, 2], 'c')
    if (is_categorical)
        r <- as.factor(r)

    rasters <- c(rasters, r)
  }

  raster_stack <- stack(rasters)

  # Apply weighting from previous model
  if (!is.null(existing_model)) {
    print(paste("Existing prediction at" , existing_model, "will be used as weight."))
    previous_model <- raster(existing_model)
    tmp_w <- values(previous_model)
    tmp_w[is.na(tmp_w)] <- 0
    values(previous_model) <- tmp_w
    previous_model <- values(previous_model) / max(values(previous_model), na.rm = TRUE)
    raster_stack <- raster_stack * previous_model
  }
 
  # Intersect with shapefile if available
  if (!is.null(to_be_intersected)) {
    print("Intersecting rasters with shapefile")
    raster_sp <- extract(raster_stack, to_be_intersected, df = TRUE)
  } else if (!is.null(downsample)) {
    print(paste("Downsampling rasters to", downsample, "points"))
    raster_sp <- sampleRegular(raster_stack, size = downsample, sp = TRUE)
  } else {
    raster_sp <- rasterToPoints(raster_stack, spatial = TRUE)
  }
    
  return(raster_sp)
}
