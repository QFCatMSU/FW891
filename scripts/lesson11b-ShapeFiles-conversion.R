{ 
  rm(list=ls());  options(show.error.locations = TRUE);

  # sp needs to be installed before sf package but you will still
  # get an error about sp not being installed -- this can be ignored
  library(package = "sp");       #old Simple Features (but still needed)
  library(package = "rgeos");    # getting/converting crs
  library(package = "rgdal");    # getting/converting crs
  library(package = "ggplot2");
  library(package = "dplyr");
  library(package = "sf");       # Simple Features
  library(package = "rnaturalearth");     # for getting coord data
  library(package = "rnaturalearthdata"); # for getting coord data

  # look for Geodetic CRS in simple feature
  museums = st_read(dsn="data/museum.csv");

  # add the crs and coordinates so it can be converted into a simple feature
  museums_SF = st_as_sf(museums, 
                        coords = c("lng", "lat"),
                        crs = 4326);
  
  # Plot the museum simple feature by itself
  plot1 = ggplot() +
    geom_sf(data = museums_SF,
            mapping = aes(geometry = geometry),
            color = "red");
  plot(plot1);
  
  #### Create your own shapefile ####
  # Check if file already exists -- don't recreate the file...
  if(!file.exists("shapefiles/museums.kml"))
  {
    # Shapefiles create 4 files: shp, shx, dbf, proj
    st_write(museums_SF, dsn = "shapefiles/museums.kml", 
             driver = "kml");
  }
  if(!file.exists("shapefiles/museums.shp"))
  {
    st_write(museums_SF, dsn = "shapefiles/museums.shp", 
             driver = "ESRI Shapefile");
  }
  if(!file.exists("shapefiles/museums.shp"))
  {
    st_write(museums_SF, dsn = "shapefiles/museums.geojson", 
             driver = "GeoJSON");
  }
  ##   drivers: https://gdal.org/drivers/vector/index.html
  
  ### These objects are already in shapefile format
  museums_KML = st_read(dsn="shapefiles/museums.kml");
  museums_SHP = st_read(dsn="shapefiles/museums.shp");
  museums_GEO = st_read(dsn="shapefiles/museums.geojson");

  ### This is a paranoid step to make sure the objects are shapefiles
  museums_KML_SF = st_as_sf(museums_KML);
  museums_SHP_SF = st_as_sf(museums_SHP);
  museums_GEO_SF = st_as_sf(museums_GEO);
  
  # All six of the above shape files/simple features will create the same plot
  plot2 = ggplot() +
    geom_sf(data = museums_KML_SF,  # replace with any of the shape files above
            mapping = aes(geometry = geometry),
            color = "red");
  plot(plot2);  # same as plot 1 no matter which shape file you use
}