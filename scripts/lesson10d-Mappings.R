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
  
  # lakes110 <- ne_download(scale = 110, type = 'lakes', category = 'physical')
  # sp::plot(lakes110, col = 'blue');
  
  # look for Geodetic CRS in simple feature
  
  museums = st_read(dsn="data/museum.csv");
  ## When you convert a CSV to a simple feature, you need to
  #   supply the longitude and latitude columns (in that order)
  ## This SF has no crs -- will cause error when plotting
  #   error: cannot transform sfc object with missing crs
  museums_SF1 = st_as_sf(museums, 
                         coords = c("lng", "lat"));  # you need to provide long/lat columns
  
  # add the crs so it can be plotted
  museums_SF2 = st_as_sf(museums, 
                         coords = c("lng", "lat"),
                         crs = 4326);
  
  #### Group 1:
  #  Using a text editor (RStudio is a text editor):    
  #    Create a CSV file that has lat/long for Detroit, Chicago, and Toronto
  #  Create a Simple Feature from the file
  
  ## KML files are google map files (similar to HTML files)
  #  KMZ files are also google map files that have been zipped
  lakeMichigan = st_read(dsn="data/Lake_Michigan_shoreline.kml");
  # KML files have the lat, long, and crs built in  -- you (usually) do not need to declare it
  lakeMI_SF = st_as_sf(lakeMichigan); 
  
  ## SHP file are shapefiles (probably the most popular -- ArcGIS)
  #  They are not standalone files!
  # Get the lake borders from downloaded file
  lakes = st_read(dsn="data/lakes/ne_10m_lakes.shp");  
  lakes_SF = st_as_sf(lakes); 
  
  # get the state borders from naturalearth
  states = ne_states(country = "United States of America");
  
  # convert the states to a Simple Feature -- with a crs
  states_SF = st_as_sf(states);

  ### Natural Earth website
  ### ArcGIS website
  
  # Remember that later component layer on top of earlier components
  plot1 = ggplot() +
    geom_sf(data = states_SF,
            mapping = aes(geometry = geometry, fill=region, linetype=type),
            color = "black") +
    geom_sf_text(data = states_SF,
                  mapping = aes(geometry=geometry, label=postal),
                  color="yellow") + 
    geom_sf(data = lakes_SF,
            mapping = aes(geometry = geometry, color=scalerank),
            fill = "lightblue") +
    geom_sf(data = museums_SF2,
            mapping = aes(geometry = geometry, shape=Presidential.Library),      
            color = "red", 
            fill = "red") +
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
        xlim = c(-3000000, 2000000),  # note the negative number (false easting)
        ylim = c(3000000, 7000000),
        expand = TRUE);
  plot(plot3);
  
  #### https://gis-michigan.opendata.arcgis.com
  #### https://www.naturalearthdata.com/ 
  #### https://spatialreference.org/ref/epsg/
    
  # Zoom in to Great Lakes region
  #### add Canada to the map ####
  #### add Lake Erie to the map ###
  #### add Detroit, Chicago, Toronto as points to the map ####
  #### Use UTM 14N (26914) -- add get same view
  #### Pick 2 other CRS from to use
  
  ### Manually add lines ####
  ### Manually add text ####
}