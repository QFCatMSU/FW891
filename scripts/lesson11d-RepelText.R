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

  ####  You need to run this once to install ggsflabel -- and you need devtools installed
  #  devtools::install_github("yutannihilation/ggsflabel"); 
  
  library(package = "ggrepel");   # a nice package that can be used for all ggplots
  library(package = "ggsflabel"); # an "add-on" for ggrepel to include geometry (i.e., SF)
  # https://yutannihilation.github.io/ggsflabel/
  
  museums = st_read(dsn="data/museum.csv");
  museums_SF = st_as_sf(museums, 
                        coords = c("lng", "lat"),
                        crs = 4326);

  # Lake MI is a KML file downloaded for the MI arcgis website
  lakeMichigan = st_read(dsn="data/Lake_Michigan_shoreline.kml");
  lakeMI_SF = st_as_sf(lakeMichigan); 
  
  # Lakes are a shapefile downloaded from the natural earth website
  lakes = st_read(dsn="data/lakes/ne_10m_lakes.shp");  
  lakes_SF = st_as_sf(lakes); 
  
  # You can also use the rnaturalearth package to get spatial files
  states = ne_states(country = "United States of America");
  states_SF = st_as_sf(states);
  
  # Remember that later component layer on top of earlier components
  plot1 = ggplot() +
    geom_sf(data = states_SF,
            mapping = aes(geometry = geometry),
            color = "black",
            fill = "grey") +
    geom_sf(data = lakes_SF,
            mapping = aes(geometry = geometry),
            color = "lightblue",
            fill = "lightblue") +
    geom_sf(data = lakeMI_SF,
            mapping = aes(geometry = geometry),
            color = "blue",
            fill = "blue") +
    geom_sf_label_repel(data = museums_SF,
            mapping = aes(geometry=geometry, label=substr(museum,
                                                          start=1,
                                                          stop=3)),
            color="purple",
            fill = "yellow");
  
  #### Notes:
  #    - You often need to click Zoom in the Plot tab to render the plot
  #    - Resizing the plot tab/window re-renders the plot 
  #    - Resizing will also change the number of labels you see
  plot2 = plot1 +
    coord_sf(crs = 4326,    
             xlim = c(-120, -70),    # latitude
             ylim = c(20, 60),       # longitude
             expand = TRUE);
  plot(plot2); 
  
  plot3 = plot1 +
    coord_sf(crs = 26917,   # UTM 17N
        xlim = c(-3000000, 2000000),  # northing
        ylim = c(3000000, 7000000),   # easting
        expand = TRUE);
  plot(plot3);

  # You can save images from either the Plots tab or the Plot Zoom window...
  
  #### Application #####
  #   - Allow for the maximum overlap so no label disappears
  #   - Improve the arrows
  #   - Add two other mappings to anything on the plot
}