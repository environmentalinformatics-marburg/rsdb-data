if(!require("remotes")) install.packages("remotes")

# You should only run this line for first time or for RSDB R-Package update
remotes::install_github("environmentalinformatics-marburg/rsdb/r-package")

library(RSDB)

# get documentation
??RSDB

# create connection to RSDB server. Local RSDB server needs to be running.
remotesensing <- RSDB::RemoteSensing$new(url = "http://127.0.0.1:8081")

# list point cloud layers
remotesensing$plointclouds

# list raster layers
remotesensing$rasterdbs

# list vector layers
remotesensing$vectordbs

# list ROI layers
remotesensing$roi_groups

# get point cloud
pointcloud <- remotesensing$pointcloud("lidar_forest_edge")

# get all ROIs (polygons) of one ROI layer
rois <- remotesensing$roi_group("plots_forest_edge")

# get info about all implemented point cloud indices
pointcloud$index_list

# set areas for index calculations, areas are named by R-"names"-Attribute, e.g. names(areas)
areas <- rois$polygon

# set indices to calculate
indices <- c("BE_PR_REG", "BE_PR_UND", "BE_PR_CAN")

# calculate indices (on the RSDB server)
pointcloud$indices(areas = areas, functions = indices)



