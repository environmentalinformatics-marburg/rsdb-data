# Requirement for this script is the raster layer plots_forest_edge_indices with processed index values of vegetation_coverage_02m_points at band 2.

if(!require("remotes")) install.packages("remotes")

# install RSDB package and automatically install updated versions
remotes::install_github("environmentalinformatics-marburg/rsdb/r-package")


library(RSDB)
library(mapview)

# create connection to RSDB server. Local RSDB server needs to be running.
remotesensing <- RSDB::RemoteSensing$new(url = "http://127.0.0.1:8081")

#list raster layers
#remotesensing$rasterdbs

# get raster layer 'plots_forest_edge_indices' with index vegetation_coverage_02m_points at band 2
rasterdb <- remotesensing$rasterdb("plots_forest_edge_indices")
#rasterdb <- remotesensing$rasterdb("forest_edge_indices")
ext <- rasterdb$extent
r <- rasterdb$raster(ext = ext, band = 2)
#r <- rasterdb$raster(ext = ext, band = 1)
mapview::mapview(r)

# get projection
proj4 <- rasterdb$proj4

# calculate gap_mask on the index values wiht threshold value of 80%
percentage <- 0.8
r@data@values <- ifelse(r@data@values > percentage, 1, 0)

# view gap_mask
mapview::mapview(r)

# create a new raster layer for the gap_mask
remotesensing$create_rasterdb("plots_forest_edge_gap_mask", proj4=proj4)
#remotesensing$create_rasterdb("forest_edge_gap_mask", proj4=proj4)

# get raster layer
rasterdb_gap_mask <- remotesensing$rasterdb("plots_forest_edge_gap_mask")
#rasterdb_gap_mask <- remotesensing$rasterdb("forest_edge_gap_mask")

# insert gap_mask raster data into raster layer
rasterdb_gap_mask$insert_RasterLayer(r)
