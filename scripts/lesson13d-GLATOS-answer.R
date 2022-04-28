{ 
  rm(list=ls());  options(show.error.locations = TRUE);
  source(file="scripts/spatial-header.R"); # moved all package info to header.r
  
  library(package = "gganimate");  # for animations
  ### The gganimate cheat sheet:
  #   https://ugoproto.github.io/ugo_r_doc/pdf/gganimate.pdf
  
  ### Read in the movement data
  pseudoData = read.csv("data/pseudoData.csv");
  
  ### Convert into a Simple Feature with the standard 4326 CRS
  pseudoData_SF = st_as_sf(pseudoData, 
                           coords=c("lat", "long"), 
                           crs=4326);
  
  ### A shapefile giving the Michigan state park boundaries 
  ### The locations in psudoData map onto Waterloo and Pinckney State Parks
  statePark = st_read(dsn="shapefiles/Michigan_State_Park_Boundaries.geojson");
  
  ### Plot the state parks and the movement data 
  plot1 = ggplot() +
    geom_sf(data = statePark,
            mapping = aes(geometry = geometry)) +
    geom_sf(data = pseudoData_SF,
            mapping = aes(geometry = geometry, 
                          color=as.factor(individual))) +  # ** (end of script)
    coord_sf(crs = 4326,    
             xlim = c(-84.3, -84),    ## Zooming in on Waterloo and 
             ylim = c(42.28, 42.46)); ## Pinckney State Parks
  plot(plot1);
  
  ### Save plot as image
  ggsave(filename = "images/plotImg.jpg",
         plot = plot1, 
         width = 10,
         height = 10,
         units = "in",
         dpi = 150);   # dots per inch
  
  ### Put the dateTime1 into a standard format 
  #   - We are animating over time and, to do this, we need a standardized 
  #     date-time (i.e., POSIXct) vector
  stnTime = as.POSIXct(pseudoData_SF$dateTime1,    
                       format="%Y-%m-%d %I:%M%p");
  
  ### Add the transition (part of gganimate package)
  #   Whatever is in  {  } get evaluated -- frame_time is a gganimate Label Variable
  plot2 = plot1 +
    labs(title = "Timestamp: {frame_time}") +  # puts the time in the title
    transition_time(time=stnTime);

  ## animate() instead of plot() -- the animation goes to the Viewer tab
  animate(plot=plot2, 
          nframes = 10,    # 10 frames (very low -- keeps the rendering time short)
          fps=1);          # 1 per second (so, this will be 10 seconds long)

  ### Formatting the time and adding style to the title
  #   A more complex evaluation in {  } -- note the quotes within quotes
  plot2b = plot1 +
    labs(title = "Stuff happening at:",
         subtitle = "{format(frame_time, '%m-%d at %I:%M%p')}") +
    theme(plot.title = element_text(color="red", size=15)) +
    transition_time(time=stnTime);
  
  animate(plot=plot2b, 
          nframes = 10, 
          fps=1); 
  
  ### More useful to save as gif (again, nframes is small to keep rendering times manageable)
  anim_save(filename = "images/animate-pseudo.gif",   
            animation = plot2b,
            nframes = 10,      # number of frames in animation
            fps = 1);          # frames per second
   
  # ### There are 100 timestamps -- so this will animate each step
  # anim_save(filename = "images/animate-pseudo-HD.gif",   
  #           animation = plot2b,
  #           nframes = 100,      # number of frames in animation
  #           fps = 5);           # frames per second (so, 20 seconds long)
  
  ### Can do fancier transitions -- and a lot more (use the gganimate cheatsheet)

  
  ## Mp4 creation can be a pain...this might work for you
  # anim_save(filename = "images/animate-pseudo.mp4",
  #         animation = plot2b,
  #         renderer = av_renderer(),
  #         nframes = 10,
  #         fps = 1);
  
  
  ### Application -- using this data
  GLATOSData = read.csv("data/Two_Interpolated_Fish_Tracks.csv");
  # The locations are in Lake Erie -- show the map of the area (the points are in Lake Erie)
  # create an animation using the above data
  # map the recording type to color (use blue and orange)
  # map the individual to shape (use a star and a triangle)
  # Time: 15-May @ 4:57AM
  # Save the file in your images folder as FishTracks.gif
  

  GlatosSF = st_as_sf(GLATOSData, 
                      coords=c("longitude", "latitude"), 
                      crs=4326);
    
  plot4 = ggplot() +
    geom_sf(data = GlatosSF,
            mapping = aes(geometry = geometry, 
                          color=as.factor(record_type), 
                          shape=as.factor(animal_id))) +
    coord_sf(crs = 4326,    
             xlim = c(-81, -84),    
             ylim = c(41, 43)); 
  plot(plot4);
  
  stnTimeGlatos = as.POSIXct(GlatosSF$bin_timestamp,
                       format="%m/%d/%Y %H:%M");  
  
  plot4b = plot4 +
    labs(title = "Stuff happening at:",
         subtitle = "{format(frame_time, '%m-%d at %I:%M%p')}") +
    theme(plot.title = element_text(color="red", size=15)) +
    transition_time(time=stnTimeGlatos);
    
  animate(plot=plot4b, 
          nframes = 10, 
          fps=1); 
    ### More useful to save as gif or mp4
  anim_save(filename = "images/animate-glatos-HD.gif",   
            animation = plot4b,
            nframes = 300,       # number of frames in animation
            fps = 10);           # frames per second
}


# ** The individual column in pseudoData gives a number (1,2,3) to the moving
#    objects.  The problem with mapping a number is that R will think the values
#    are continuous and create a gradient mapping.  as.factor() forces the 
#    values to be discrete.