cds1 <- rbind(c(-15,-25), c(-15,35), c(25, 5), c(-15,-5))
cds2 <- rbind(c(-35,-35), c(35,35) , c(35,-25))
cds3 <- rbind(c(-15,5), c(5,25), c(45,5), c(15,-45))
lines <- spLines(cds1, cds2, cds3, crs='+proj=longlat +datum=WGS84')
#lines <- spTransform(lines, CRS("+init=epsg:21037"))

# raster
r <- raster(ncols=50, nrows=50, xmn = -50 , xmx = 50 , ymn = -50 , ymx = 50, crs='+proj=longlat +datum=WGS84' )
values(r) <- 10 + sample(1:10, ncell(r), replace=TRUE)

lines <- gBuffer(lines, byid = TRUE, width = 3)

rextracted <- extract(r,lines, cellnumbers=TRUE)

df <- data.frame(rextracted[1])
for(i in 2:length(rextracted)) df <- rbind(df , data.frame(rextracted[i]))
locations <- df[,1]

r[locations] <- 1
plot(r)
plot(lines, add=T)


r_coords <- coordinates(r)
r_coords_extracted <- r_coords[locations,]
#points(r_coords_extracted)
