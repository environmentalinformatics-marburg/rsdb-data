library(RSDB)

# set account
userpwd <- "user:password" # use this account (if not loaded from file)
fileName <- "~/.remote_sensing_userpwd.txt" # optional file in home directory content: user:password
userpwd <- readChar(fileName, file.info(fileName)$size) # optional read account from file

# open remote sensing database
#remotesensing <- RemoteSensing$new("http://localhost:8081", userpwd) # local
#remotesensing <- RemoteSensing$new("http://192.168.191.183:8081", userpwd) # remote server
remotesensing <- RemoteSensing$new("http://137.248.191.215:8081", userpwd) # remote server

# get names of PointDBs
remotesensing$pointdbs

# get one pointdb
pointdb <- remotesensing$pointdb("kili_campaign1_lidar_classified_2015")

# get names of ROI groups associated with this PointDB
pointdb$roi_groups

# get names of POI groups associated with this PointDB
pointdb$poi_groups

# get meta data of PointDB
pointdb$info

# get one ROI group
rois <- remotesensing$roi_group("kili_A")

# get one ROI
roi <- remotesensing$roi(group_name="kili_A", roi_name="cof3_A")

# get one POI group
pois <- remotesensing$poi_group("kili")

# get one POI
poi <- remotesensing$poi(group_name="kili", poi_name="cof3")

# get points of point-cloud that are covered by polygon cof3_A
df <- pointdb$query_polygon(roi$polygon[[1]])
library(rgl)
plot3d(df$x, df$y, df$z)

# create extent around poi of 10 meter edge length
ext <- extent_diameter(poi$x, poi$y, 10)

# get points of point-cloud that are covered by ext,
# with last return only, just x,y,z coordinates and x,y moved to origin of ext
df <- pointdb$query(ext, filter="last_return=1", columns=c("x","y","z"), normalise="origin")
library(rgl)
plot3d(df$x, df$y, df$z)

# get points of point-cloud that are covered by ext,
# just x,y,z coordinates and z as height above gound, extremes removed
df <- pointdb$query(ext, normalise=c("extremes", "ground"))
library(rgl)
plot3d(df$x, df$y, df$z, df$intensity)

# get RasterLayer of ext, processed as DTM
r <- pointdb$query_raster(ext, "dtm")
plot(r)
RSDB::visualise_raster(r)

# get voxels of ext as RasterStack
ext <- extent_diameter(poi$x, poi$y, 50)
r <- pointdb$query_raster(ext, "voxel")
#plot(r)
library(mapview)
cubeview(r)


