#Extract raster cells that are touched by a road
############################################################
source("install_import_packages.R")
required_packages <- c("raster","sp")
dummy <- install_import_packages(required_packages)

#Simple road of two line segments
cds <- rbind(c(-35,-35), c(35,35) , c(35,-25))
lines <- spLines(cds)
  
# raster
r <- raster(ncols=10, nrows=10, xmn = -50 , xmx = 50 , ymn = -50 , ymx = 50 )
values(r) <- 10 + sample(1:10, ncell(r), replace=TRUE)
#values(r) <- 100:ncell(r)+100

rextracted <- extract(r,lines,cellnumbers=TRUE)
df <- data.frame(rextracted)
locations <- df[,1]

r[locations] <- 1
plot(r)
plot(lines, add=TRUE)


r_coords <- coordinates(r)
r_coords_extracted <- r_coords[locations,]
points(r_coords_extracted)

#dummy <- lapply(paste0("package:",required_packages),detach,unload=TRUE,character.only = TRUE)
