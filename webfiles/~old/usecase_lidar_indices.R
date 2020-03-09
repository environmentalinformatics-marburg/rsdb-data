# This script file contains usage examples to calculate indices of LiDAR data with RSDB.

# **** init ***

library(data.table)
library(RSDB)

# help("rPontDB-package", package="RSDB") # show main manual page
# help(package="RSDB") # show all manual pages
# packageDescription("RSDB") # show package Description
# packageVersion("RSDB") # show package version

#remotesensing <- RemoteSensing$new("http://localhost:8081", "user:password") # open local remote sensing database connection
remotesensing <- RemoteSensing$new("http://192.168.191.183:8081", "user:password") # open remote sensing database connection

#remotesensing$web() #open web interface in browser

#remotesensing$lidar_layers() #query names of lidar layers

# **** util ***


subset_arg_poi_square <- function(group, pois, edge=10) { # squares of points
  poisFinal <- paste0(pois, collapse=";")
  r <- paste0("square(poi(group=", group, ",", poisFinal, "),", edge, ")")
  return(r)
}

subset_arg_roi <- function(group, rois) { # polygons
  roisFinal <- paste0(rois, collapse=";")
  r <- paste0("roi(group=", group, ",", roisFinal, ")")
  return(r)
}

# **** processing ***


pointdb <- remotesensing$lidar("kili") #open one lidar layer

#pointdb$poi_groups() # get POI groups associated with this layer
#pointdb$roi_groups() # get ROI groups associated with this layer
poi_group <- "kili"
pois <- remotesensing$poi_group(poi_group)
poi_names <- pois$name
subsets <- subset_arg_poi_square(group=poi_group, pois=poi_names, edge=10)

#roi_group <- group_name
#rois <- remotesensing$roi_group(roi_group)
#roi_names <- rois$name
#subsets <- subset_arg_roi(group=roi_group, rois=roi_names)

cat("\n")
cat(subsets)
cat("\n")

#script <- c("BE_H_MAX","BE_H_MEAN")
fs <-  pointdb$processing_functions #get all lidar index functions
script <- fs$name

cat("\n")
cat(as.character(script))
cat("\n")

df <- pointdb$process_OLD(subset=subsets, script=script)






