{ 
  source(file="scripts/header.R"); # moved all package info to header.r
  
  # Lake MI is a KML file downloaded for the MI arcgis website
  lakeMichigan = st_read(dsn="data/Lake_Michigan_shoreline.kml");
  lakeMI_SF = st_as_sf(lakeMichigan); 
  
  # Lakes are a shapefile downloaded from the natural earth website
  lakes = st_read(dsn="data/lakes/ne_10m_lakes.shp");  
  lakes_SF = st_as_sf(lakes); 
  
  # You can also use the rnaturalearth package to get spatial files
  states = ne_states(country = "United States of America");
  states_SF = st_as_sf(states);
  
  ## A decent webpage with a spatial example
  #  https://r-spatial.org/r/2018/10/25/ggplot2-sf.html
  
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
        xlim = c(-3000000, 2000000),  
        ylim = c(3000000, 7000000),
        expand = TRUE);
  plot(plot1);
  
  plot2 = plot1 +
    ## These come from the ggspatial package...
    annotation_scale(location = "tl",  # options: tr, br, tl, bl
                   #  plot_unit ="m",  # needs to match CRS
                     width_hint = 0.2,
                     bar_cols = c("red", "orange"),
                     line_col = "gray20",   
                     text_col = "blue") +
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
  
  #### Save to plot
  saveRDS(plot2, file="data/plot.RData");
  
  #### Application
  #    - add the compass and scale to a plot of your spatial data
  #    - position the compass on the right side about 1/3 of the way up
  #    - position scale at the top-center
  #    - make the scale width about 30% of the plot
  #    - double the size of the compass without skewing it
  #    - Using annotation_spatial_hline 
  #       add two latitude lines at 40 and 50 degrees (CRS 4326)
  #       intercept is the argument you want to use
}
