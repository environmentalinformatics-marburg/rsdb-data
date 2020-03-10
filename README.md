# RSDB distribution with example datasets

This distribution contains RSDB and example datasets.
The example datasets are already inserted into RSDB and additionally the original example dataset files are in folder example-data.


[Download this distribution as zip-file](https://github.com/environmentalinformatics-marburg/rsdb-data/archive/master.zip)

Or download this distribution with git:
```bash
git clone --depth 1 -b master https://github.com/environmentalinformatics-marburg/rsdb-data.git
```

This RSDB distribution is runnable on Windows and on Ubuntu.

## Run on Windows 10 64bit

Extract the zip-file on a short path without spaces in it, e.g. to `C:/rsdb`

Doubleclick `win_server.cmd` to run RSDB server. Stop it by closing the console window.

No dependencies are needed as `java` and `gdal` for Windows 10 64bit are included.

Files of patten `win_*.cmd` are executable for Windows.

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

For a started RSDB server

This URL can also be used for access by the [RSDB R-package](https://environmentalinformatics-marburg.github.io/rsdb/docs/r_package_installation).


---
## Example datasets

All example datasets are inserted in RSDB as layers.

You can use the original example data files located in subfolders of `example-data` to try out to insert data into RSDB.

---
### Dataset lidar_forest_edge

This is a dataset of LiDAR Data covering an edge of the forest.

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