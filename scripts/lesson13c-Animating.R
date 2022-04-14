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
  
  
  ### Application
  # 1) Add the following to the script file app13.r
  # 2) Save the GLATOS fish movement data (CRS 4326) in the file 
  #    data/Two_Interpolated_Fish_Tracks.csv to a Simple Feature
  # 3) The fish are in Lake Erie 
  #    - Create a spatial plot of the fish locations over a map of Lake Erie
  # 4) Create an animation of the fish movement 
  #    - map the record_type to color (use the colors blue and orange)
  #    - map the animal_id to shape (use a star and a triangle)
  #    - In the title put the time in this format: 15-May @ 4:57AM
  # 5) Save the animation as FishTracks.gif to a folder called images 
  #    in your Project Folder
  #    - Use 300 frames in the animation (this will take time to render)
  #    - have to animation run at 10 frames per second
  # 6) Answer the following questions in comments:
  #    Why are there many frames without any movement?
  #    Why are there so many points in each of the frames?
}


# ** The individual column in pseudoData gives a number (1,2,3) to the moving
#    objects.  The problem with mapping a number is that R will think the values
#    are continuous and create a gradient mapping.  as.factor() forces the 
#    values to be discrete.