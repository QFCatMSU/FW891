{
  rm(list=ls());                 # clear Environment tab
  library(package = "ggmap");
  library(package = "viridis");
  library(package = "sf"); 
  
  ### Reduce size of shapefiles here: https://mapshaper.org/
  ### I have not found a realiable R way to simplify bathymetric data
  
  ggmap::register_google("AIzaSyAzE_ptJ4iJvpaTaUly3wr6CrZrLiWixzU");
  
  # original bathymetry data downloaded from NOAA (this is slow...)
  lakeErie = st_read(dsn="shapefiles/Lake_Erie/Lake_Erie_Contours.shp");
  lakeErie_SF = st_as_sf(lakeErie);  # convert to simple feature (not always needed)
  
  # same bathymetry data reduced by 95% using mapshaper.org
  lakeErieReduced = st_read(dsn="shapefiles/Lake_Erie/reduced/Lake_Erie_Contours.shp");
  lakeErieReduced_SF = st_as_sf(lakeErieReduced); 
  
  ### Plotting google map with original Lake Erie bathymetry data
  plot1 = ggmap(get_map("Lake Erie", 
                        zoom = 8, maptype = "terrain")) + 
    geom_sf(data = lakeErie_SF, 
            mapping = aes(geometry=geometry, 
                          color=DEPTH),
            inherit.aes = FALSE) +       # don't inherit ggmap mappings
    scale_color_viridis(option="D");     # for contour line color scheme
  # plot(plot1);
  
  ### Plotting google map with reduced Lake Erie bathymetry data
  plot2 = ggmap(get_map("Lake Erie", 
                        zoom = 8, maptype = "terrain")) + 
          geom_sf(data = lakeErieReduced_SF, 
                  mapping = aes(geometry=geometry, 
                                color=DEPTH),
                  inherit.aes = FALSE) +       # don't inherit ggmap mappings
          scale_color_viridis(option="D");     # for contour line color scheme
  # plot(plot2);
  
  ### Test changing CRS (kind of a random CRS)
  #   This will not maintain the google map image 
  plot3  = plot2 + 
    coord_sf(crs = 26917,    # UTM zone 17N
             xlim = c(300000, 670000),  
             ylim = c(4550000, 4750000),
             expand = TRUE);
  # plot(plot3);
} 