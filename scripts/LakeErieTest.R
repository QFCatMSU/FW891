{ 
#  source(file="scripts/header.R"); # moved all package info to header.r
  
  # sp needs to be installed before sf package but you will still
  # get an error about sp not being installed -- this can be ignored
  # library(package = "sp");       #old Simple Features (but still needed)
  # library(package = "rgeos");    # getting/converting crs
  # library(package = "rgdal");    # getting/converting crs
  library(package = "ggplot2");
  library(package = "viridis");
  library(package = "ggOceanMaps");
  # library(package = "dplyr");
  library(package = "sf");       # Simple Features
  # library(package = "rnaturalearth");     # for getting coord data
  # library(package = "rnaturalearthdata"); # for getting coord data
  
  # Lake MI is a KML file downloaded for the MI arcgis website
  lakeErie = st_read(dsn="shapefiles/Lake_Erie/Lake_Erie_Contours.shp");
  lakeErie_SF = st_as_sf(lakeErie); 
  
  plot1 = ggplot() +
    geom_contour(data = lakeErie_SF,
            mapping = aes(geometry=geometry,
                          color=DEPTH, 
                         )) +
    theme_minimal() +
    scale_color_viridis(option="D") +
    scale_fill_viridis(option="A");
  plot(plot1);
}
