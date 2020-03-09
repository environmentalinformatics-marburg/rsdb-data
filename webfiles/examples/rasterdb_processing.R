library(RSDB)

# set account
userpwd <- "user:password" # use this account (if not loaded from file)
fileName <- "~/.remote_sensing_userpwd.txt" # optional file in home directory content: user:password
userpwd <- readChar(fileName, file.info(fileName)$size) # optional read account from file

# open remote sensing database
#remotesensing <- RemoteSensing$new("http://localhost:8081", userpwd) # local
#remotesensing <- RemoteSensing$new("http://192.168.191.183:8081", userpwd) # remote server
remotesensing <- RemoteSensing$new("http://137.248.191.215:8081", userpwd) # remote server

# get names of RasterDBs
remotesensing$rasterdbs

# get one rasterdb
rasterdb <- remotesensing$rasterdb("kili_campaign1")

# get one POI group
pois <- remotesensing$poi_group("kili")

# get one POI
poi <- remotesensing$poi(group_name="kili", poi_name="cof3")

# create extent around poi of 10 meter edge length
ext <- extent_diameter(poi$x, poi$y, 10)

# get RasterStack of all bands at ext
r <- rasterdb$raster(ext)
plot(r)

#interactive view RasterStack as 3d cube
library(mapview)
cubeview(r)

#interactive view one band
plainview(r@layers[[50]])

# convert to speclib of hsdar package
library(hsdar)
sp <- as.speclib(r)
plot(sp)

# convert speclib back to Raster
r2 <- HyperSpecRaster(sp)
plot(r2)


