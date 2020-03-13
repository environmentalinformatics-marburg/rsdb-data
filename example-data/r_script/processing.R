if(!require("remotes")) install.packages("remotes")

# install RSDB package and automatically install updated versions
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
indices <- c("area", # area of requested polygon
             "vegetation_coverage_02m_CHM", # ratio of forest coverage
             "BE_H_MEAN", "BE_H_MAX", # forest maturity: mean and maximum of point cloud points (normalizes to height above ground)
             "BE_H_SD", "BE_H_VAR_COEF",  # Variability of the vegetation distribution: standard deviation and coefficient of variation
             "BE_PR_REG", "BE_PR_UND", "BE_PR_CAN", # layer characterization by penetration ratio at layers: regeneration, understory, canopy
             "BE_FHD", # foliage height diversity
             "chm_height_sd", "chm_surface_ratio") # canopy characteristics: canopy surface area ratio, canopy standard deviation

# calculate indices (on the RSDB server)
df <- pointcloud$indices(areas = areas, functions = indices)


# get vector layer
vectordb <- remotesensing$vectordb("plots_forest_edge")

#get CRS as PROJ4
proj4 <- vectordb$proj4

# get vector data in original projection
sfData <- vectordb$getVectors()

# show plot polygons
mapview::mapview(sfData)

# get extent of plots
plot_extent <- sf::st_bbox(sfData)

# create raster for mask
r <- raster::raster(vals=0, resolution=1, xmn=plot_extent$xmin, ymn=plot_extent$ymin, xmx=plot_extent$xmax, ymx=plot_extent$ymax, crs=proj4)

# create mask of plots
r_mask <- raster::mask(r, mask = sfData, inverse=TRUE, updatevalue = 1)

# correct NA values in mask
raster::values(r_mask)[raster::values(r_mask) == 0] <- NA

# show raster plot mask
mapview::mapview(r_mask)

# create new raster layer in RSDB (plot mask)
remotesensing$create_rasterdb("plots_forest_edge_mask")

# get raster layer (plot mask)
maskLayer <- remotesensing$rasterdb("plots_forest_edge_mask")

# upload mask raster into RSDB
maskLayer$insert_RasterLayer(r_mask)
