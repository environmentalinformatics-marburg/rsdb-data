# This script generates two rasters, uploads them to one RasterDB layer at different time slices and retrieves the raster data back into R.


# Install RSDB package and automatically install updated versions.
if(!require("remotes")) install.packages("remotes")
remotes::install_github("environmentalinformatics-marburg/rsdb/r-package")
# In some cases a restart of R is needed to work with a updated version of RSDB package (in RStudio - Session - Terminate R).

library(RSDB)
library(raster)

# get documentation
?'RSDB-package'

# create connection to RSDB server. Local RSDB server needs to be running.
remotesensing <- RSDB::RemoteSensing$new(url = "http://127.0.0.1:8081")

# connect to remote RSDB server
#url <- "https://example.com:1234"
#username <- "user"
#password <- "password"
#remotesensing <- RSDB::RemoteSensing$new(url=url, userpwd=paste0(username, ":", password))

# create new RasterDB layer
remotesensing$create_rasterdb("generated_raster")

# open RasterDB layer
rasterdb <- remotesensing$rasterdb("generated_raster")

# generate pixel data
m1 <- matrix(data=c(1:(400*400)), nrow=400, ncol=400)
m1[100,200] <- NA
m1[100,201] <- NA
m1[101,200] <- NA
m1[101,201] <- NA
m2 <- t(m1)

# create two R RasterLayer of same crs and resolution
r1 <- raster::raster(m1, xmn=609932, ymn=5674236, xmx=610365, ymx=5674631, crs="+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs ")
r2 <- raster::raster(m2, xmn=609932, ymn=5674236, xmx=610365, ymx=5674631, crs="+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs ")

# view created R RasterLayer
#mapview::mapview(r1)
#mapview::mapview(r2)

# upload R RasterLayer data into RSDB RasterDB layer
# Note: resolution and crs for RasterDB layer is detemined by first inserted data.
#       It is indispensable that all following data uploads to this RasterDB layer match that resolution and crs.
rasterdb$insert_RasterLayer(r1, time_slice = "2020-05", band = 1, band_title="generated data")
rasterdb$insert_RasterLayer(r2, time_slice = "2020-08", band = 1, band_title="generated data")

# get extent of this RasterDB layer
rasterdb$extent

# get data.frame of time_slices of this RasterDB layer
rasterdb$time_slices

# get raster of one time slice from RasterDB layer
ext <- raster::extent(matrix(c(609932, 5674236, 610365, 5674631), nrow=2))
r3 <- rasterdb$raster(ext=ext, time_slice="2020-05")
r4 <- rasterdb$raster(ext=ext, time_slice="2020-08")
#mapview::mapview(r3)
#mapview::mapview(r4)
