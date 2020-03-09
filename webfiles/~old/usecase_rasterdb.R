# This script file contains usage examples of package RSDB for raster processing.
# help("rPontDB-package", package="RSDB") # show main manual page
# help(package="RSDB") # show all manual pages
# packageDescription("RSDB") # show package Description
# packageVersion("RSDB") # show package version
library(RSDB)
#remotesensing <- RemoteSensing$new("http://localhost:8081", "user:password") # open local remote sensing database
remotesensing <- RemoteSensing$new("http://192.168.191.183:8081", "user:password") # open remote sensing database
#remotesensing$web() #open web interface in browser




#rasterdb <- remotesensing$rasterdb("testing_kili") # open RasterDB
rasterdb <- remotesensing$rasterdb("kili") # open RasterDB
xmin <- 312062
ymin <- 9638537
xmax <- 312062 + 100
ymax <- 9638537 + 100
ext <- extent(xmin, xmax, ymin, ymax) # create extent of raster
t0 <- Sys.time()
#r <- rasterdb$raster(ext, band=c(1:146)) # request raster from RasterDB
#r <- rasterdb$raster(ext, band=c(1:145)) # request raster from RasterDB
#r <- rasterdb$raster(ext, band=c(1:142)) # request raster from RasterDB
#r <- rasterdb$raster(ext, band=c(1:133)) # request raster from RasterDB
r <- rasterdb$raster(ext, band=c(1:109)) # request raster from RasterDB
t1 <- Sys.time()
print((t1-t0))
#plot(r)
#writeRaster(r, "c:/pointdb_data/out.tif")
library(hsdar)
sl <- to_speclib(as.matrix(r), r) # transform to speclib
plot(sl)


