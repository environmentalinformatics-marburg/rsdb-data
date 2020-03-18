# RSDB distribution with example datasets

This distribution contains RSDB. example datasets and example R-scripts.

The example datasets are already inserted into RSDB and additionally the original example dataset files are in folder `example-data`.

Example R-scripts are located in folder `example-data/r_script`.


[Download this distribution as zip-file](https://github.com/environmentalinformatics-marburg/rsdb-data/archive/master.zip)

Or download this distribution with git:
```bash
git clone --depth 1 -b master https://github.com/environmentalinformatics-marburg/rsdb-data.git
```

This RSDB distribution is runnable on **Windows** and on **Ubuntu**.

## Run on Windows 10 64bit

Extract the zip-file on a short path without spaces in it, e.g. to `C:/rsdb`

Doubleclick `win_server.cmd` to run RSDB server. Stop it by closing the console window.

No dependencies are needed as `java` and `gdal` for Windows 10 64bit are included.

Files of pattern `win_*.cmd` are executable for Windows.

## Run on Ubuntu

Extract the zip-file.

Dependencies Java (`default-jdk`) and GDAL `libgdal-java` are needed which are not included this distribution for Ubuntu. Refer to the [documentation](https://environmentalinformatics-marburg.github.io/rsdb/docs/server_installation).

Install dependencies and mark sh-files as executable.
```bash
sudo apt-get install default-jdk
sudo apt install libgdal-java
chmod +x *.sh
```

Run RSDB server.
```bash
./server.sh
```
Press ctrl-c to stop RSDB server.

## RSDB usage

**Web-interface**: Per default your local RSDB server is running at [http://127.0.0.1:8081](http://127.0.0.1:8081)

If your local RSDB is running currently you can directly click on this link to open RSDB web-interface. (For freshly started RSDB server, wait a few seconds until "Server running.." is printed on the terminal.)

This URL can also be used for access by the [RSDB R-package](https://environmentalinformatics-marburg.github.io/rsdb/docs/r_package_installation).


---
## Example datasets

All example datasets are inserted in RSDB as layers.

You can use the original example data files located in subfolders of `example-data` to try out to insert data into RSDB.

---
### Dataset lidar_forest_edge

This is a dataset of LiDAR data covering an edge of the forest.

Original dataset is located at `example-data/lidar_forest_edge`

#### Task for dataset import

web-interface `Tools` - `Task` - Category `PointCloud` - Task `import`

Insert task parameters. At the bottom the summary of the resulting task is shown which should be the following:

`{ "task_pointcloud": "import", "pointcloud": "lidar_forest_edge", "source": "example-data/lidar_forest_edge", "storage_type": "TileStorage" }`

Click `Submit` and wait a few seconds to finish the task.

Refresh you browser window (by pressing "F5") to update list of contained layers.

#### Task for rasterized layer generation

web-interface `Tools` - `Task` - Category `PointCloud` - Task `rasterize`

Insert task parameters. At the bottom the summary of the resulting task is shown which should be the following:

`{ "task_pointcloud": "rasterize", "pointcloud": "lidar_forest_edge", "storage_type": "TileStorage" }`

Click `Submit` and wait a few seconds to finish the task.

Refresh you browser window (by pressing "F5") to update list of contained layers.

---
### Dataset plots_forest_edge

This dataset contains plot definitions as polygons in a GeoPackage file. The plot areas are covered by the lidar dataset lidar_forest_edge.

Original dataset is located at `example-data/plots_forest_edge/plots_forest_edge.gpkg`

---
## Example processing

Processing R script is located at `example-data/r_script`

The script uploads a plot mask into RSDB as raster layer `plots_forest_edge_indices` at band 1 with title `plot mask`.

Aim of the following:  
Based on the plot mask, pixels of resolution of 1 meter should be filled at plot areas with point cloud index calculation values by task `index_raster`.

The point cloud task `index_raster` can be specified and submitted on the web interface or on the command line. ([see documentation](https://environmentalinformatics-marburg.github.io/rsdb/docs/tasks/))

Parameters:

**task_pointcloud**: "index_raster" *// task name*  
**pointcloud**: "lidar_forest_edge" *// source point cloud layer*  
**rasterdb**: "plots_forest_edge_indices" *// target raster layer with mask at band 1*  
**indices**: "BE_H_MEAN" *// indices to calculate for each pixel*  
**mask_band**: 1 *// the previously created band 1 should be used*  

Following task specification will be generated if the parameter arguments have been typed into the web interface:

{ "task_pointcloud": "index_raster", "pointcloud": "lidar_forest_edge", "rasterdb": "plots_forest_edge_indices", "indices": [ "BE_H_MEAN" ], "mask_band": 1 }

This task specification can be submitted by the `Submit` button or at command line it can be typed directly and submitted.
