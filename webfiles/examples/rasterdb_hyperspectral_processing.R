library(RSDB)

# set account
userpwd <- "user:password" # use this account (if not loaded from file)
fileName <- "~/.remote_sensing_userpwd.txt" # optional file in home directory content: user:password
userpwd <- readChar(fileName, file.info(fileName)$size) # optional read account from file

# open remote sensing database
#remotesensing <- RemoteSensing$new("http://localhost:8081", userpwd) # local
#remotesensing <- RemoteSensing$new("http://192.168.191.183:8081", userpwd) # remote server
remotesensing <- RemoteSensing$new("http://137.248.191.215:8081", userpwd) # remote server

# get one rasterdb
rasterdb <- remotesensing$rasterdb("kili_campaign1")

# get one POI
poi <- remotesensing$poi(group_name="kili", poi_name="cof3")

# create extent around poi of 10 meter edge length
ext <- extent_diameter(poi$x, poi$y, 10)

# get band of 800nm and fill missing pixels
product <- "gap_filling(r800)"
r <- rasterdb$raster(ext, product=product) # request raster from RasterDB
plot(r)

# get normalised bands (reference-band: 800 nm)
r <- rasterdb$raster(ext, product="normalised_difference(r800, full_spectrum)")
#plot(r)
plot(r@layers[[60]])

# get NDVI
r <- rasterdb$raster(ext, product="ndvi")
plot(r)

# 1. get normalised bands up to 800nm (reference-band: 800nm)
# 2. appy PCA and return first 7 main components
product <- "pca(normalised_difference(r800, gap_filling([r0:r800])), 7)"
r <- rasterdb$raster(ext, product=product) # request raster from RasterDB
plot(r)

# 1. get normalised bands up to 800nm (reference-band: 800nm)
# 2. appy PCA and return first 7 main components
# 3. calculate euclidean distance (bands as components)
product <- "euclidean_distance(pca(normalised_difference(r800, gap_filling([r0:r800])), 7))"
r <- rasterdb$raster(ext, product=product) # request raster from RasterDB
plot(r)

# apply black point compensation to all bands
product <- "black_point_compensation(full_spectrum)"
r <- rasterdb$raster(ext, product=product) # request raster from RasterDB
#plot(r)
plot(r@layers[[60]])

# apply black point compensation to all bands and calculate normalisation
product <- "normalised_difference(r408, black_point_compensation(full_spectrum))"
r <- rasterdb$raster(ext, product=product) # request raster from RasterDB
#plot(r)
plot(r@layers[[60]])


product <- "pca(normalised_difference(r408, black_point_compensation(gap_filling(full_spectrum))), 7)"
r <- rasterdb$raster(ext, product=product) # request raster from RasterDB
plot(r)

product <- "euclidean_distance(pca(normalised_difference(r408, black_point_compensation(gap_filling(full_spectrum))), 7))"
r <- rasterdb$raster(ext, product=product) # request raster from RasterDB
plot(r)

product <- "gap_filling(b120)"
r <- rasterdb$raster(ext, product=product) # request raster from RasterDB
plot(r)





