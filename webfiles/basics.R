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
rasterdb <- remotesensing$rasterdb("be_hai_hyperspectral")

# get names of PointDBs
remotesensing$pointdbs
# get one pointdb
pointdb <- remotesensing$pointdb("be_hai_lidar_06_classified")

# get names of PointClouds
remotesensing$pointclouds
# get one pointcloud
pointcloud <- remotesensing$pointcloud("jannik_uniwald_sequoia")

# get names of POI groups
remotesensing$poi_groups
# get one POI group
pois <- remotesensing$poi_group("be_hai_poi")
# get one POI
poi <- remotesensing$poi(group_name="be_hai_poi", poi_name="HEW02")

# get names of ROI groups
remotesensing$roi_groups
# get one ROI group
rois <- remotesensing$roi_group("be_hai_roi")
# get one ROI
roi <- remotesensing$roi(group_name="be_hai_roi", roi_name="HEW02")

# create extent around poi of 10 meter edge length
ext <- extent_diameter(poi$x, poi$y, 10)

# get RasterStack of all bands at ext
r <- rasterdb$raster(ext)
plot(r)

# get data.frame of PointDB points at ext
df1 <- pointdb$query(ext)

# get data.frame of PointCloud points
df2 <- pointcloud$points(extent_diameter(477656.150, 5632072.109, 10))

# open web interface in browser
remotesensing$web()




