{   
  rm(list=ls());  options(show.error.locations = TRUE);
  source(file="scripts/spatial-header.R"); # moved all package info to header.r

  # Get spatial data for all Lakes (downloaded from naturalearth) -- save to a SF
  lakes = st_read(dsn="data/lakes/ne_10m_lakes.shp"); # can (usually) use this as an SF
  lakes_SF = st_as_sf(lakes); # on the safe side -- explicitly make into an SF
  
  # Get spatial data for the US using rnaturalearth package -- save to an SF
  states = ne_states(country = "United States of America");
  states_SF = st_as_sf(states);
  
  ## A decent webpage with a spatial example
  #  https://r-spatial.org/r/2018/10/25/ggplot2-sf.html
  
  # plot the US and the lakes 
  plot1 = ggplot() +
    geom_sf(data = states_SF,
            mapping = aes(geometry = geometry),
            color = "black",
            fill = "grey") +
    geom_sf(data = lakes_SF,
            mapping = aes(geometry = geometry),
            color = "lightblue",
            fill = "lightblue") +
    coord_sf(crs = 26917,  
        xlim = c(-3000000, 2000000),  # not the ideal CRS...
        ylim = c(3000000, 7000000),
        expand = TRUE);
  plot(plot1);
  
  plot2 = plot1 +
    # These come from the ggspatial package...
    # They are "spatially aware" object (i.e., they adjust to the CRS)
    annotation_scale(location = "tl",  # options: tr, br, tl, bl
                   #  plot_unit ="m",  # needs to match CRS
                     width_hint = 0.2,
                     bar_cols = c("red", "orange"),
                     line_col = "gray20",   
                     text_col = "blue") +
    annotation_spatial_hline(intercept = c(40,50), color="red") +
      
    annotation_north_arrow(location = "bl", 
                  height = unit(0.5, "in"),
                  which_north = "true", 
                  pad_x = unit(0.5, "in"), 
                  pad_y = unit(0.4, "in"),
                  style = north_arrow_fancy_orienteering(
                                      text_col = 'red',
                                      line_col = 'blue',
                                      fill = 'yellow'));
  plot(plot2);    
  
  #### Save the plot to a file (to open later)
  ##   This is saving the Environment data for plot2 to a file
  saveRDS(plot2, file="data/plot.RData");
  
  #### Application
  #    1) Make these changes to plot2:
  #    - position the compass on the right side and centered vertically
  #    - position scale at the top-center 
  #        - you need to one of the padding subcomponents
  #    - make the scale width about 30% of the plot
  #    - increase the height of the scale bar (note: you can use cm or in)
  #    - (approximately) double the size of the compass without 
  #       changing the aspect ratio (i.e., the shape stays the same)
  #    - Add two latitude lines at 40 and 50 degrees
  #       - color the lines red
  #       - use annotation_spatial_hline 
  
  #   2) Add the compass and scale to a plot with your spatial data
  #    - include at least three subcomponent changes for both scale and compass
  #    - Add two green longitude lines 

}
