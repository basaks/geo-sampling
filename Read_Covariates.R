#Parse the input text file containing covaraites
############################################################
Parse_Text <- function(cov_file) {
  all_cov <- read.table(cov_file)
  fnames <- c()
  for (i in 1:nrow(all_cov)){
    fname <- c(trimws(as.character(all_cov[, 1][i])), as.character(all_cov[, 2][i]))
    if (!startsWith(fname[1] , "#")){
      fnames <- rbind(fnames,fname)
    }
  }
  rownames(fnames) <- c()
  return(fnames)
}

#Read input covariates from a text file, intersect with targets or road buffer and return a data frame
############################################################
Read_Covariates <- function(cov_file, to_be_intersected, existing_model = NULL) {
 
  if(!is.null(existing_model)){
    previous_model <- raster(existing_model)
    tmp_w <- values(previous_model)
    tmp_w[is.na(tmp_w)] <- 0
    values(previous_model) <- tmp_w
    previous_model <- values(previous_model) / max(values(previous_model), na.rm = TRUE)
    print(paste("Existing prediction at" , existing_model, "will be used as weight."))
  }
    
  all_cov <- Parse_Text(cov_file)
  print(all_cov)
  print("Reading input covariates.")

  expected_CRS <- to_be_intersected@proj4string
  print(paste("Shapefile CRS is", expected_CRS))
  
  for(i in 1:nrow(all_cov)){
    fname <- all_cov[i, 1]
    r <- raster(fname)

    #CRS check
    if(!compareCRS(expected_CRS,r@crs)){
      print(paste("CRS mismatch, reprojecting", fname, "to shapefile CRS"))
      r <- projectRaster(from=r, crs=expected_CRS)
    }

    # Apply weighting from previous model
    # TODO: apply to post-intersected values, more efficient
    # TODO: row-by-row
    if (!is.null(existing_model))
        values(cov_intersected) <- values(cov_intersected) * previous_model

    #Intersect the covariates with the target locations
    cov_intersected <- data.frame(extract(r, to_be_intersected))

    colnames(cov_intersected) <- r@data@names
    if(i == 1)
      df <- data.frame(cov_intersected)
    else
      df <- cbind.data.frame(df,cov_intersected)

    is_categorical <- identical(all_cov[i, 2], 'c')
    if (is_categorical)
      df[,i] <- as.factor(df[,i])
    
  }


  return(df)
}
