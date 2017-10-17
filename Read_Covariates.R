#Read input covariates from a text file and return a covstack
############################################################
Read_Covariates <- function(cov_file) {
  #all_cov <- read.table(paste(data_folder,cov_file, sep = "/"), header = FALSE)
  all_cov <- read.table(cov_file)
  print("Reading input covariates.")
  expected_CRS <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  print(paste("Expected CRS is", expected_CRS))
  num_categorical <- 0
  
  for(i in 1:length(all_cov$V1)){
    fname <- trimws(as.character(all_cov$V1[i]))
    print(fname)
    if(!startsWith(fname , "#")){
      r <- raster(fname)
      num_unique <- length(unique(r[]))
      # if a raster has unique values less than col*row / 10000 is assumed to be categorical
      if(num_unique < round((r@ncols * r@nrows) / 10000)){
        print("categorical")
        num_categorical <- num_categorical + 1
        r@data@isfactor
        r[] <- as.factor(r[])
        r@data@isfactor
      }
      #CRS check
      if(!compareCRS(expected_CRS,r@crs)){
        print(paste("CRS converted for",fname))
        r@crs <- expected_CRS
      }
      #Stack 
      if(i == 1)
        cov_stack <- stack(r)
      else
        cov_stack <- stack(cov_stack, r)
    }
  }
  print(paste(as.character(length(cov_stack@layers)) , "covariates were read out of which", as.character(num_categorical), "recognized as categorical covariates."))
  return(cov_stack)
}