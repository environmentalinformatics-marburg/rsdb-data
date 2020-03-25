if(!require("remotes")) install.packages("remotes")
remotes::install_github("environmentalinformatics-marburg/rsdb/r-package")


library(RSDB)
library(mapview)
library(landscapemetrics)
library(tidyverse)
library(raster)


####Custom function definitions#################


gap_filter <- function(patches, min_area=5/10000, max_para=1.5){
  # Function to filtered gap maps to keep only gaps which fullfill a minimum area and shape criteria
  
  # Get patch metrics
  gapStats<-landscapemetrics::calculate_lsm(patches,what=c('lsm_p_area','lsm_p_para'))
  # Apply size filter criterion-
  selected_gapIDs <-gapStats %>% dplyr::filter(class>0 & metric=='area' & value > min_area) %>% dplyr::select(class)
  # Apply perimeter/area  filter criterion
  selected_gapIDs<-gapStats %>% dplyr::filter(class %in% selected_gapIDs$class & metric=='para' & value < max_para) %>% dplyr::select(class)
  
  patches[!patches%in%selected_gapIDs$class]<-0
  return(patches)
}


gap_metrics <- function(patches){
  # Function to calcuate a basic set of gap metrics using the landscapemetrics package
  
  edge.stats<-calculate_lsm(patches,what=c('lsm_l_te','lsm_l_ed'),count_boundary = FALSE,directions=8)  %>% spread(key=metric,value= value) %>% dplyr::select(ed,te)
  
  
  gapStats<-calculate_lsm(patches,what=c('lsm_p_area','lsm_p_perim'),count_boundary=FALSE,directions=8)
  
  area.stats<-gapStats %>% dplyr::filter(metric=='area') %>% summarise(count=n(),
                                                                       mean_area=mean(value),
                                                                       max_area=max(value),
                                                                       min_area=min(value),
                                                                       sd_area=sd(value),
                                                                       total_area=sum(value))
  
  
  perim.stats<-gapStats %>% dplyr::filter(metric=='perim') %>% summarise(max_perim=max(value),
                                                                         min_perim=min(value),
                                                                         mean_perim=mean(value),
                                                                         sd_perim=sd(value),
                                                                         total_perim=sum(value))
  
  
  stats<-bind_cols(area.stats,perim.stats,edge.stats)
  
  
  return(stats)
}

get_gap_stats<-function(patches, aoi){
  #Function to get the gap metrics for a plot/ aoi
  
  # Crop patcj raster tp extent of aoi
  patch_map_masked <- raster::crop(patches,aoi)
  # Mask patch cells outside the aoi
  patch_map_masked <- raster::mask(patch_map_masked,mask=aoi)
  
  # Get the gaps according to the filter criteria
  gaps<-gap_filter(patches = patch_map_masked)
  
  # Get the gap statistics for the selected AOI
  return(gap_metrics(gaps))
}

######### Example Usage ###################

#Connect to local RSDB

remotesensing <- RSDB::RemoteSensing$new("https://vhrz1078.hrz.uni-marburg.de:8201",userpwd)

# get plot polygons
vectordb_plots <- remotesensing$vectordb("plots_forest_edge")
plot_vectors <- vectordb_plots$getVectors()

#view plot_vectors
fig<-mapview::mapview(plot_vectors)
fig

#get raster layer with gap_mask which we created in the previous script
rasterdb_gap_mask <- remotesensing$rasterdb("forest_edge_gap_mask")

ext <- rasterdb_gap_mask$extent
gap_mask <- rasterdb_gap_mask$raster(ext = ext, band = 1)

#convert to binary raster with 1=potential gap and 0= closed canopy
gap_mask[gap_mask==1]<-0
gap_mask[is.na(gap_mask)]<-1

#view gap_mask
fig+mapview::mapview(gap_mask) 

# The gap_mask raster is converted to a patch raster by assining all touching gap cells a unique patch ID using a connected component labeling alogrithm
patch_map<-landscapemetrics::get_patches(gap_mask,1)[[1]]
fig+mapview::mapview(patch_map) 


# Get the summary gap statisitcs for all polygons
results<-data.frame()

for (i in 1:nrow(plot_vectors)){
  print(i)
  tmp<-get_gap_stats(patch_map,aoi=plot_vectors[i,])
  results<-rbind(results,tmp)
  
}
results


