{ 
  rm(list=ls());  options(show.error.locations = TRUE);

  #### Install package -- you will be prompted by RStudio 
  
  # sp needs to be installed before sf package but you will still
  # get an error about sp not being installed -- this can be ignored
  library(package = "sp");       #old Simple Features (but still needed)
  library(package = "rgeos");    # getting/converting crs
  library(package = "rgdal");    # getting/converting crs
  library(package = "ggplot2");
  library(package = "sf");       # Simple Features
  library(package = "rnaturalearth");     # for getting coord data
  library(package = "rnaturalearthdata"); # for getting coord data
  library(package="raster");  # raster data -- unused in this script
  library(package="stars");   # raster data -- unused in this script
  
  # rnaturalearth does not include lakes... naturalearthhires does
  # This is needed to install naturalearthires package --
  #  the prompted way to install does not work...
  devtools::install_github("ropensci/rnaturalearthhires");

  ### get the lake borders -- don't run if lakes is already in the Environment
  ### this uses naturalearthhires (I think...)
  # I have already done this and saved the data to a shapefile
  # lakes = ne_download(scale = 10,    # download data from naturalearth
  #                       type = "lakes",
  #                       category = "physical");

  # Get the lake borders from downloaded file
  lakes = st_read(dsn="data/lakes/ne_10m_lakes.shp");
  
  # convert the lake borders to a simple feature -- with the crs
  lakesSF = st_as_sf(lakes, crs = 4326); 
  
  # get the state borders from naturalearth
  states = ne_states(country = "United States of America");
  
  # convert the states to a Simple Feature -- with a crs
  statesSF = st_as_sf(states, crs = 2955);

  #### add Canada to the map ####
  
  # creating three points to overlay on map
  
  # creating a data frame with two named/numeric columns
  pointsDF = data.frame(lat=numeric(), long=numeric());
  # adding points to the data frames
  pointsDF[1,] = c(30, -100);  
  pointsDF[2,] = c(40, -120);  
  pointsDF[3,] = c(50, -110);
  
  # converting points to a Simple Feature
  points = st_as_sf(pointsDF, 
                    coords = c("long", "lat"),
                    crs = 4326);

  # combine points into one value
  points2 = summarise(points, do_union = FALSE);
  
  # convert points to a linestring
  lineString = st_cast(points2, to="LINESTRING");
  
  # plot the states, lakes, and 3 points
  plot5 = ggplot() +
    # plot the states
    geom_sf(data = statesSF,
            mapping = aes(geometry = geometry),      
            color = "black", 
            fill = "grey") +
    # plot the lakes
    geom_sf(data = lakesSF,
            mapping = aes(geometry = geometry),
            color = "black",
            fill = "lightblue") +
    # plot the 3 points
    geom_sf(data = points,
            mapping = aes(geometry = geometry),
            color = rgb(red=1, green=0.5, blue=0),
            shape=24,
            size=2,
            alpha = 0.7,
            stroke = 3,
            fill = "lightgreen") +
    # plot the 3 points as a line  
    geom_sf(data = lineString,
            mapping = aes(geometry = geometry),
            color = rgb(red=1, green=0, blue=0),
            size=2,
            alpha = 0.8,
            linetype = 3) +
    # change the crs -- this works if everything has a defined crs
    coord_sf(crs = 4326,  #2955 3857 2163 4326 -- can change to any crs   
             xlim = c(-130, -40),  # in degrees...
             ylim = c(20, 60),
             expand = TRUE);
  plot(plot5);
  # since no projection is given -- Mercator is assumed
  # center in on Michigan
  # add three points for Detroit, Lansing, and Grand Rapids
  
  # plot the states, lakes, and 3 points
  plot6 = ggplot() +
    # plot the states
    geom_sf(data = statesSF,
            mapping = aes(geometry = geometry),      
            color = "black", 
            fill = "grey") +
    # plot the lakes
    geom_sf(data = lakesSF,
            mapping = aes(geometry = geometry),
            color = "black",
            fill = "lightblue") +
    # plot the 3 points
    geom_sf(data = points,
            mapping = aes(geometry = geometry),
            color = rgb(red=1, green=0.5, blue=0),
            shape=24,
            size=2,
            alpha = 0.7,
            stroke = 3,
            fill = "lightgreen") +
    # plot the 3 points as a line  
    geom_sf(data = lineString,
            mapping = aes(geometry = geometry),
            color = rgb(red=1, green=0, blue=0),
            size=2,
            alpha = 0.8,
            linetype = 3) +
    # change the crs -- this works if everything has a defined crs
    coord_sf(crs = 26917,   # UTM 17N
        xlim = c(-3000000, 2000000),  # in meters or feet?
        ylim = c(3000000, 7000000),
        expand = TRUE);
  plot(plot6);
  
  # Redo with UTM 15N and try to get the same view
}