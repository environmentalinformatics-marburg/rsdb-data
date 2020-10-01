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

# show all raster layers
#remotesensing$rasterdbs

# get raster layer
rasterdb <- rasterdb_gap_mask <- remotesensing$rasterdb("hyperspectral_forest_edge")

# show all vector layers
#remotesensing$vectordbs

# get vector layer
vectordb <- remotesensing$vectordb("plots_forest_edge")

# get plot polygons
plot_vectors <- vectordb$getVectors()
#plot(plot_vectors)

# polygon of plot1
plot_polygon <- plot_vectors$geometry[plot_vectors$plot == "plot1"]

# get raster at plot1 with all bands
r <- rasterdb$raster(ext = plot_polygon)
plot(r)

# get index NVDI
r <- rasterdb$raster(ext = plot_polygon, product = "ndvi")
plot(r)

# get index TGI
r <- rasterdb$raster(ext = plot_polygon, product = "tgi")
plot(r)

# get index by custom formula
r <- rasterdb$raster(ext = plot_polygon, product = "(r600 - r650) / r800")
plot(r)
