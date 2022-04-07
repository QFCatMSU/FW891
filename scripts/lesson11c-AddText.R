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
  
  # the data frame museums
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
  
  #### Note: last component with a CRS determines the CRS for the whole plot ####
  
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
    geom_sf_label(data = museums_SF,
             mapping = aes(color=Presidential.Library,
                           geometry=geometry, label=substr(museum,
                                                           start=1,
                                                           stop=3)),
          #   color="purple",
             fill = "yellow") + 
    ### Note: Lake MI will cover up the labels...
    geom_sf(data = lakeMI_SF,
            mapping = aes(geometry = geometry),
            color = "blue",
            fill = "blue");
  
  plot2 = plot1 +
    # 4326 will default to Mercator projection...
    coord_sf(crs = 4326,    
             xlim = c(-120, -70),  # in degrees...
             ylim = c(20, 60),
             expand = TRUE);
  plot(plot2);  
  
  ### Often need to click Zoom button in Plot window to see full map
  plot3 = plot1 +
    coord_sf(crs = 26917,   # UTM 17N
        xlim = c(-3000000, 2000000),  
        ylim = c(3000000, 7000000),
        expand = TRUE);
  plot(plot3); 

  #### Nudging text -- and how it relates to CRS ####
  # Same plot as above with nudged text
  # Remember that later component layer on top of earlier components
  plot1b = ggplot() +
    geom_sf(data = states_SF,
            mapping = aes(geometry = geometry),
            color = "black",
            fill = "grey") +
    geom_sf(data = lakes_SF,
            mapping = aes(geometry = geometry),
            color = "lightblue",
            fill = "lightblue") +
    geom_sf_label(data = museums_SF,
             mapping = aes(
                           geometry=geometry, label=substr(museum,
                                                           start=1,
                                                           stop=3)),
             color="purple",
             fill = "yellow",
             nudge_x = -5,     # nudge the label by -5 units in x dir
             mudge_y = 5) +    # nudge the label by 5 units in y dir
    geom_sf(data = lakeMI_SF,
            mapping = aes(geometry = geometry),
            color = "blue",
            fill = "blue");
  
  plot2b = plot1b +
    coord_sf(crs = 4326,    
             xlim = c(-120, -70),  
             ylim = c(20, 60),
             expand = TRUE);
  plot(plot2b);     # nudging seems to work for this plot
  
  plot3b = plot1b +
    coord_sf(crs = 26917,  
        xlim = c(-3000000, 2000000),  
        ylim = c(3000000, 7000000),
        expand = TRUE);
  plot(plot3b);     # nudging does not seems to work for this plot
  
  #### Nudging does not adapt to the CRS!
  #### And nudging by 5 feet does not change much
  
  
  #### Application #####
  #   Add a color mapping that distinguishes presidential library from 
  #     non-presidential libraries (it's a column in the data frame...)
  #   Change the default mapped colors using style_* component 
}