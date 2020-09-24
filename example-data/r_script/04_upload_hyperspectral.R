if(!require("remotes")) install.packages("remotes")

# Install RSDB package and automatically install updated versions.
remotes::install_github("environmentalinformatics-marburg/rsdb/r-package")
# In some cases a restart of R is needed to work with a updated version of RSDB package (in RStudio - Session - Terminate R).


library(RSDB)
library(raster)

# get documentation
??RSDB

# create connection to RSDB server. Local RSDB server needs to be running.
remotesensing <- RSDB::RemoteSensing$new(url = "http://127.0.0.1:8081")

# path to hyperspectral raster file may need to be adjusted
r <- raster::stack("../hyperspectral_forest_edge/hyperspectral_forest_edge.tif")

# path to band meta data file may need to be adjusted
band_meta <- read.csv("../hyperspectral_forest_edge/hyperspectral_forest_edge_bands.csv")

# show raster data (160 bands, first 16 bands shown)
#plot(r)

# get projection
proj4 <- r@crs

# create a new raster layer for the hyperspectral raster
remotesensing$create_rasterdb("hyperspectral_forest_edge", proj4=proj4)

# get raster layer
rasterdb <- rasterdb_gap_mask <- remotesensing$rasterdb("hyperspectral_forest_edge")

# upload all 160 bands. This takes several seconds.
rasterdb$insert_RasterStack(r)

# set band wavelength information
rasterdb$set_band_meta(band_meta)

# show band meta data
rasterdb$bands


