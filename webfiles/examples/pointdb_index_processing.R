library(RSDB)

# set account
userpwd <- "user:password" # use this account (if not loaded from file)
fileName <- "~/.remote_sensing_userpwd.txt" # optional file in home directory content: user:password
userpwd <- readChar(fileName, file.info(fileName)$size) # optional read account from file

# open remote sensing database
#remotesensing <- RemoteSensing$new("http://localhost:8081", userpwd) # local
#remotesensing <- RemoteSensing$new("http://192.168.191.183:8081", userpwd) # remote server
remotesensing <- RemoteSensing$new("http://137.248.186.133:8200", userpwd) # remote server

# get one pointdb
remotesensing$pointdbs
pointdb <- remotesensing$pointdb("be_hai_lidar_06_classified")

# get one POI group
remotesensing$poi_groups
pois <- remotesensing$poi_group(group_name="be_hai_poi")

# get one ROI group
remotesensing$roi_groups
rois <- remotesensing$roi_group(group_name="be_hai_roi")

# create areas of all POIs in a POI-group with 10 meter squares
areas_of_pois <- mapply(function(name, x, y) {return(extent_diameter(x=x, y=y, d=10))}, pois$name, pois$x, pois$y)

# create areas of all ROIs in a ROI-group
areas_of_rois <- rois$polygon

#some_functions <- c("BE_H_MAX", "BE_H_P20", "pulse_density")
some_functions <- c("BE_H_MAX")

#get all lidar index processing functions
all_functions <-  pointdb$processing_functions
all_function_names <- all_functions$name

areas <- areas_of_pois
#areas <- areas_of_rois

functions <- some_functions
#functions <- all_function_names

df <- pointdb$process(areas=areas, functions=functions)
