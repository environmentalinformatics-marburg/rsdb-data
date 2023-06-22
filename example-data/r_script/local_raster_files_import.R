# Install RSDB package and automatically install updated versions.
if(!require("remotes")) install.packages("remotes")
remotes::install_github("environmentalinformatics-marburg/rsdb/r-package")
# In some cases a restart of R is needed to work with a updated version of RSDB package (in RStudio - Session - Terminate R).

library(RSDB)
library(raster)

# get documentation
?'RSDB-package'

# connect to remote RSDB server
#url <- "https://example.com:1234"
#username <- "user"
#password <- "password"
remotesensing <- RSDB::RemoteSensing$new(url=url, userpwd=paste0(username, ":", password))



path <- "./"
raster_files <- dir(path, full.names = TRUE, recursive = TRUE, pattern = "*.yaml")

for(raster_file in raster_files) {
  cat(paste0("import:   ", raster_file, "\n"))

  task <- list(
    task_rasterdb = "import",
    rasterdb = "test",
    file = raster_file
  )

  result <- remotesensing$submit_task(task=task)
  print("")
  #print(result$status)
  #print(result$message)
}




