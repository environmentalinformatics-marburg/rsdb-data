# This script loads geoTIFF files and meta data CSV-file.

library(hsdar)
library(data.table)
library(pryr)

#dir <- "hyperspectral_geotiff_1/"
#dir <- "hyperspectral_geotiff_2/"
dir <- "hyperspectral_geotiff_1a/"
#dir <- "hyperspectral_geotiff_2a/"

band_meta <- fread(paste0(dir, "band_meta.csv"))

hyperspectral_data <- brick(paste0(dir, "cof1", ".tif"))
names(hyperspectral_data) <- band_meta$title

one_band_raster <- raster(hyperspectral_data, layer=100) #extract one band of the hypespectral data
plot(one_band_raster) #visualise one band of data

spec_lib <- speclib(as.matrix(hyperspectral_data), wavelength=band_meta$wavelength, fwhm=band_meta$fwhm) # convert RasterBrick to hsdar Speclib

#vegindex_names <- vegindex() # get all predifined index names in hsdar
#indices <- vegindex(spec_lib, vegindex_names) # calculate all indices

spec_lib_diff <- derivative.speclib(spec_lib) #get first derivation of spectra

plot(spec_lib)

plot(spec_lib_diff)

#m <- spec_lib@spectra@spectra_ma #get spectra matrix of spectra
m <- spec_lib_diff@spectra@spectra_ma #get spectra matrix of first derivation of spectra
#m

pr <- prcomp(m)
pca_matrix <- pr$x[,c(1:10)]

rs <- sqrt(rowSums(pca_matrix^2))
spec_div <- mean(rs)

plot(rs)


getValue <- function(dir, file, band_meta) {
  print(file) # show processing progress
  hyperspectral_data <- brick(paste0(dir, file)) # read file
  names(hyperspectral_data) <- band_meta$title #set band names
  raw_m <- as.matrix(hyperspectral_data)
  raw_m <- na.omit(raw_m) # remove rows with NA values
  spec_lib <- speclib(raw_m, wavelength=band_meta$wavelength, fwhm=band_meta$fwhm) # convert RasterBrick to hsdar Speclib
  #m <- spec_lib@spectra@spectra_ma #get spectra matrix of spectra
  spec_lib_diff <- derivative.speclib(spec_lib) #get first derivation of spectra
  m <- spec_lib_diff@spectra@spectra_ma #get spectra matrix of first derivation of spectra
  #m <- na.omit(m) # remove rows with NA values
  pr <- prcomp(m) # calculate PCA
  pca_matrix <- pr$x[,c(1:10)] # get matrix of first n PCA components
  rs <- sqrt(rowSums(pca_matrix^2)) # calculate distance to centroid
  spec_div <- mean(rs) # calculate mean centroid distance
  return(spec_div)
}

getValueSafe <- function(dir, file, band_meta) { # return warning and NA if error
  return( tryCatch(getValue(dir, file, band_meta), error = function(e) { warning(paste0(file, '  ', e)); return(NA)}) )
}

#getValue(dir, "cof1.tif", band_meta) # example


files <- list.files(dir, "*.tif$") # get all tif files in directory

values <- sapply(files, pryr::partial(getValueSafe, dir = dir, band_meta = band_meta))
valuesSorted <- sort(values)
par(mar=c(3,2,0.5,0.5))
plot(valuesSorted, xaxt="n", pch='x')
titles <- gsub("\\..*","",names(valuesSorted))
axis(1, at=c(1:length(valuesSorted)),labels=titles, cex.axis=0.75)





























