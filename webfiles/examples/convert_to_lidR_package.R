#get points as data.frame from database and convert it to LAS object of lidR package

library(lidR)
library(data.table)
library(RSDB)

#get documentation of conversion funktion
?as.LAS

# set account
userpwd <- "user:password" # use this account (if not loaded from file)
fileName <- "~/.remote_sensing_userpwd.txt" # optional file in home directory content: user:password
userpwd <- readChar(fileName, file.info(fileName)$size) # optional read account from file

# open remote sensing database
#remotesensing <- RemoteSensing$new("http://localhost:8081", userpwd) # local
#remotesensing <- RemoteSensing$new("http://192.168.191.183:8081", userpwd) # remote server
remotesensing <- RemoteSensing$new("http://137.248.191.215:8081", userpwd) # remote server

#get points as data.frame
roi <- remotesensing$roi("be_hai_roi", "HEW47")
pointdb <- remotesensing$pointdb("be_hai_lidar_06_classified")

pointdb$processing_functions

df <- pointdb$query_polygon(polygon=roi$polygon$HEW47)

#convert data.frame to LAS object of lidR package
las <- as.LAS(df)

#plot LAS object
plot(las)
