# RSDB distribution with example datasets




## Example datasets

Original example datasets are located in subfolders of `example-data`

### Dataset lidar_forest_edge

This is a dataset of LiDAR Data covering an edge of the forest.

Origiginal dataset is located at `example-data/lidar_forest_edge`

Task for dataset import:

web-interface `Tools` - `Task` - Category `PointCloud` - Task `import`

Insert task parameters. At the bottom the summary of the resulting task is schown which should be the following:

`{ "task_pointcloud": "import", "pointcloud": "lidar_forest_edge", "source": "example-data/lidar_forest_edge", "storage_type": "TileStorage" }`

Click `Submit` and wait a few seconds to finish the task.

Refresh you browser window (by pressing "F5") to update list of contained layers.

Task for rasterized layer generation:

web-interface `Tools` - `Task` - Category `PointCloud` - Task `rasterize`

Insert task parameters. At the bottom the summary of the resulting task is schown which should be the following:

`{ "task_pointcloud": "rasterize", "pointcloud": "lidar_forest_edge", "storage_type": "TileStorage" }`

Click `Submit` and wait a few seconds to finish the task.

Refresh you browser window (by pressing "F5") to update list of contained layers.

### Dataset plots_forest_edge

This dataset cotains plot definitions as polygons in a GeoPackage file. The plot areas are covered by the lidar dataset lidar_forest_edge.

Original dataset is located at `example-data/plots_forest_edge/plots_forest_edge.gpkg`