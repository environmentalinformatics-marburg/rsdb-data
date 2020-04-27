library(RSDB)

# set account
userpwd <- "user:password" # use this account (if not loaded from file)
fileName <- "~/.remote_sensing_userpwd.txt" # optional file in home directory content: user:password
userpwd <- readChar(fileName, file.info(fileName)$size) # optional read account from file

# open remote sensing database
#remotesensing <- RemoteSensing$new("http://localhost:8081", userpwd) # local
#remotesensing <- RemoteSensing$new("http://192.168.191.183:8081", userpwd) # remote server
remotesensing <- RemoteSensing$new("http://137.248.191.215:8081", userpwd) # remote server

# get pointcloud names
remotesensing$pointclouds

# open pointcloud
pointcloud <- remotesensing$pointcloud("jannik_uniwald_sequoia")

# get description
pointcloud$description

# get projection as geo code (e.g. EPSG)
pointcloud$geocode

# get projection as proj4
pointcloud$proj4

# get extent
pointcloud$extent

#create position
pos <- c(477662.863, 5632129.623)

# create extent at position and diameter of 10 meter
ext <- extent_diameter(x=pos[1], y=pos[2], 10)

# get data.frame of points in extent
df <- pointcloud$points(ext, columns=c("x", "y", "z", "classification", "returns"))

# get data.frame of points in extent
df <- pointcloud$points(ext, columns=c("x", "y", "z", "classification", "returns"), filter="classification=0")

# get raster of points per pixel at 1 meter resolution
r <- pointcloud$raster(ext, res=1,  type="point_count")
plot(r)

# get raster of laser pulses per pixel at 1 meter resolution
r <- pointcloud$raster(ext, res=1,  type="pulse_count")
plot(r)

# get raster of DSM at 0.5 meter resolution and fill missing pixels
r <- pointcloud$raster(ext, res=0.5,  type="dsm", fill=10)
plot(r)
visualise_raster(r)

# get raster of DTM at 0.5 meter resolution and fill missing pixels
r <- pointcloud$raster(ext, res=0.5,  type="dtm", fill=10)
plot(r)
visualise_raster(r)

# get raster of CHM at 0.5 meter resolution and fill missing pixels
r <- pointcloud$raster(ext, res=0.5,  type="chm", fill=10)
plot(r)
visualise_raster(r)


# create polygon
library(sp)
x <- 477662.863 + c(1,2,1.5,1,1)
y <- 5632129.623 + c(1,1,2.7,2,1)
coords <- cbind(x, y)
p <- Polygon(coords=coords)
ps <- Polygons(list(p), ID=17)
sps <- SpatialPolygons(list(ps))
plot(sps)

# get points in polygon
df <- pointcloud$points(p, columns=c("x", "y", "z", "classification", "returns"))

# calculate all indices for area of polygon
df <- pointcloud$indices(list(p1=p), pointcloud$index_list$name)

# calcaulte for one polygon one index
pointcloud$indices(p, "BE_H_MAX")

#get one ROI, create polygon and create bounding box
roi <- remotesensing$roi(group_name="hai", roi_name="HEW02")
p <- Polygon(coords=roi$polygon)
x <- p@coords[,1]
y <- p@coords[,2]
ext <- extent(x=min(x), xmax=max(x), ymin=min(y), ymax=max(y)) # create bounding box from polygon
pointcloud$indices(ext, "BE_H_MAX") # calculate index at ext
pointcloud$indices(p, "BE_H_MAX") # calculate index at polygon






