# This script file contains usage examples to calculate indices of LiDAR data with RSDB.

# **** init ***

library(data.table)
library(RSDB)

# help("rPontDB-package", package="RSDB") # show main manual page
# help(package="RSDB") # show all manual pages
# packageDescription("RSDB") # show package Description
# packageVersion("RSDB") # show package version

remotesensing <- RemoteSensing$new("http://localhost:8081", "user:password") # open local remote sensing database connection
#remotesensing <- RemoteSensing$new("http://192.168.191.183:8081", "user:password") # open remote sensing database connection

#remotesensing$web() #open web interface in browser

#remotesensing$lidar_layers() #query names of lidar layers

#pointdb <- remotesensing$lidar("alb") #open one lidar layer
#fs <-  pointdb$process_functions() #get all lidar index functions


# **** util ***

#subset_arg_poi_square <- function(group, pois,edge=10) {
#  poisFull <- paste0(group, "/", pois)
#  poisFinal <- paste0(poisFull, collapse="&")
#  r <- paste0("square(poi(", poisFinal, "),", edge, ")")
#  return(r)
#}

subset_arg_poi_square <- function(group, pois,edge=10) {
  poisFinal <- paste0(pois, collapse=";")
  r <- paste0("square(poi(group=", group, ",", poisFinal, "),", edge, ")")
  return(r)
}

#subset_arg_roi <- function(rois, group) {
#  roisFull <- paste0(group, "/", rois)
#  roisFinal <- paste0(roisFull, collapse="&")
#  r <- paste0("roi(", roisFinal, ")")
#  return(r)
#}

subset_arg_roi <- function(group, rois) {
  roisFinal <- paste0(rois, collapse=";")
  r <- paste0("roi(group=", group, ",", roisFinal, ")")
  return(r)
}

# **** processing ***

process_layer <- function(layer_name) {


  pointdb <- remotesensing$lidar(layer_name) #open one lidar layer

  #poi_group <- layer_name
  #pois <- remotesensing$poi_group(poi_group)
  #poi_names <- pois$name
  #subsets <- subset_arg_poi_square(group=poi_group, pois=poi_names, edge=10)

  roi_group <- layer_name
  rois <- remotesensing$roi_group(roi_group)
  roi_names <- rois$name
  subsets <- subset_arg_roi(group=roi_group, rois=roi_names)

  cat("\n")
  cat(subsets)
  cat("\n")

  #script <- c("BE_H_MAX","BE_H_MEAN")
  script <- pointdb$process_functions()$name

  df <- pointdb$process(subset=subsets, script=script)
}



#layer_names <- c("alb", "hai", "sch")
layer_names <- c("hai")

result_list <- lapply(layer_names, process_layer)

df <- rbindlist(result_list)


cor(df$BE_H_MAX, df$BE_H_MEAN, use="complete.obs")

df$subset <- NULL
corMatrix <- cor(as.matrix(df), use="pairwise.complete.obs")
#corMatrix <- cor(df$BE_ELEV_ASPECT, as.matrix(df), use="pairwise.complete.obs")

levelplot(abs(corMatrix), col.regions=heat.colors(100), scales=list(x=list(rot=90)))


pointdb <- remotesensing$lidar("hai") #open one lidar layer
script <- c("BE_H_MAX","BE_H_MEAN")
df1 <- pointdb$process(subset="roi(hai/HEW10|hai/HEW11)", script=pointdb$process_functions()$name)



subset_arg_poi_square(group = "hai", pois = "HEW10", edge = 20)
subset_arg_roi(group = "hai", pois = c("HEW10","HEW11"))




