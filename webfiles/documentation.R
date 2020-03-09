#get documentation pages

library(RSDB)

#package overview
?`RSDB-package`

#documentation of central class RemoteSensing
?RemoteSensing

#documentation of (hyperspectral) raster class RasterDB
?RasterDB

#documentation of (LiDAR) point-cloud class PointCloud
?PointCloud

#documentation of (LiDAR) point-cloud class PointDB (old layers)
?PointDB

#show package description file
packageDescription("RSDB")

#show package version
packageDescription("RSDB")$Version

#show index of package documentation pages
help(package="RSDB")

#list available functions / classes in package
ls(pos="package:RSDB")
