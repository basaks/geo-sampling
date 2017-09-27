#Extract raster cells that are within a pre-defined distance from roads
#######################################################################

source("install_import_packages.R")
required_packages <- c("raster","sp","rgeos")
dummy <- install_import_packages(required_packages)

#Some random roads
cds1 <- rbind(c(-15,-25), c(-15,35), c(25, 5), c(-15,-5))
cds2 <- rbind(c(-35,-35), c(35,35) , c(35,-25))
cds3 <- rbind(c(-15,5), c(5,25), c(45,5), c(15,-45))
lines <- spLines(cds1, cds2, cds3, crs='+proj=longlat +datum=WGS84')

# raster
r <- raster(ncols=50, nrows=50, xmn = -50 , xmx = 50 , ymn = -50 , ymx = 50, crs='+proj=longlat +datum=WGS84' )
values(r) <- 10 + sample(1:10, ncell(r), replace=TRUE)

#Buffering
lines_buffered <- gBuffer(lines, byid = TRUE, width = 3)
rextracted <- extract(r,lines_buffered, cellnumbers=TRUE)

df <- data.frame(rextracted[1])
for(i in 2:length(rextracted)) df <- rbind(df , data.frame(rextracted[i]))
locations <- df[,"cell"]

r[locations] <- 1
plot(r)
plot(lines, add=TRUE)

r_coords <- coordinates(r)
r_coords_extracted <- r_coords[locations,]
points(r_coords_extracted)
