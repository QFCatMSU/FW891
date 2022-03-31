{ 
  rm(list=ls());  options(show.error.locations = TRUE);
devtools::install_github("yutannihilation/ggsflabel")
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
  library(package = "ggrepel"); 
  library(package = "ggsflabel"); 
  library(package = "gganimate");
  
  # look for Geodetic CRS in simple feature
  
  fishTracks = st_read(dsn="data/Two_Interpolated_Fish_Tracks.csv");
  ## When you convert a CSV to a simple feature, you need to
  #   supply the longitude and latitude columns (in that order)
  ## This SF has no crs -- will cause error when plotting
  #   error: cannot transform sfc object with missing crs
  fishTracks_SF = st_as_sf(fishTracks, 
                           coords = c("longitude", "latitude"),
                           crs=4326);  

  
  #### Group 1:
  #  Using a text editor (RStudio is a text editor):    
  #    Create a CSV file that has lat/long for Detroit, Chicago, and Toronto
  #  Create a Simple Feature from the file

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
            mapping = aes(geometry = geometry),
            color = "black") +
    geom_sf(data = lakes_SF,
            mapping = aes(geometry = geometry),
            fill = "lightblue") +
    geom_sf(data = fishTracks_SF,
            mapping = aes(geometry = geometry),
            color = "red");

  
  plot2 = plot1 +
    # 4326 will default to Mercator projection...
    coord_sf(crs = 4326,    
             xlim = c(-84,-81),  # in degrees...
             ylim = c(41, 43),
             expand = TRUE);
  plot(plot2);
  
  ### Get date from timestamps
  a = fishTracks_SF$bin_timestamp;
  b = as.Date(a, format="%m/%d/%Y");
  
  ### Often need to click Zoom button in Plot window to see full map
  plot3 = plot1 +
    coord_sf(crs = 26917,   # UTM 17N
        xlim = c(300000, 500000),  
        ylim = c(4550000, 4750000),
        expand = TRUE) +
        transition_time(time=b);
  # plot(plot3);
  
  
  plot4 = plot1 +
    coord_sf(crs = 26917,   # UTM 17N
        xlim = c(300000, 500000),  
        ylim = c(4550000, 4750000),
        expand = TRUE) +
        labs(title = "Fish Date: {closest_state}") +
        transition_states(states = b,
                  transition_length = 1,
                  state_length = 2,
                  wrap = TRUE);
  # plot(plot4);
  
  ## Send the animation to the viewer  
  #animate(plot4, nframes = 100, fps = 10);
  
  ## create an animated gif from the plot
  #  This step takes a LONG time... especially if you increase nframes
  anim_save(filename = "images/animate2.gif",
            animation = plot4,
            nframes = 100,       # number of frames in animation
            fps = 10);           # frames per second
  #### https://gis-michigan.opendata.arcgis.com
  #### https://www.naturalearthdata.com/ 
  #### https://spatialreference.org/ref/epsg/

}