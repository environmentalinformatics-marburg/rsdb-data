library(RSDB)
library(mapview)
library(rgl)

remotesensing <- RemoteSensing$new("http://localhost:8081", "user:password") # open local remote sensing database connection
#remotesensing <- RemoteSensing$new("http://192.168.191.183:8081", "user:password") # open remote sensing database connection

pointdb <- remotesensing$lidar("hai")

ext <- extent_radius(x=597306.5, y=5670193.5, r=200)

points <- pointdb$query(ext=ext)

plot3d(points$x, points$y, points$z)

plot(density(points$z, n=20))


dtm <- pointdb$query_raster(type="dtm2", ext=ext)

#plot(dtm)
plainview(dtm)
visualise_raster(as.matrix(dtm))


dsm <- pointdb$query_raster(type="dsm2", ext=ext)

#plot(dsm)
plainview(dsm)
#visualise_raster(as.matrix(dsm))


chm <- pointdb$query_raster(type="chm2", ext=ext)

#plot(chm)
plainview(chm)
#visualise_raster(as.matrix(chm))


voxel <- pointdb$query_raster(type="voxel", ext=ext) #does not show in RStudio --> open in web browser (in RStudio button "show in new window")
cubeView(voxel, col=col)


pointdb <- remotesensing$lidar("hai")
ext <- extent_radius(x=599798.5, y=5657795, r=200)
voxel <- pointdb$query_raster(type="voxel", ext=ext)
cubeView(voxel)



pl <- viridis::plasma(1000, alpha = 1, begin = 0, end = 1)
col <- c("#000000FF", pl[100:1000])










