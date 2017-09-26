#Extract raster cells that are touched by a road
############################################################
all_packages <- installed.packages()
all_packages <- all_packages[,"Package"]

required_packages <- c("raster","sp")

#install -> import the requirements
for(i in length(required_packages)) 
  if(!is.element(required_packages[i],  all_packages))
    install.packages(required_packages[i])
dummy <- lapply(required_packages,library,character.only=TRUE,quietly = TRUE)

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
