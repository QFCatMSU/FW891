{
  rm(list=ls());                 # clear Environment tab
  library(package = "ggmap");
  library(package = "viridis");
  library(package = "sf"); 
  
  ggmap::register_google("AIzaSyAzE_ptJ4iJvpaTaUly3wr6CrZrLiWixzU");
  
  # bathymetry data downloaded from NOAA
  lakeErie = st_read(dsn="shapefiles/Lake_Erie/Lake_Erie_Contours.shp");
  lakeErie_SF = st_as_sf(lakeErie); 
  
  plot3 = ggmap(get_map("Lake Erie", 
                        zoom = 8, maptype = "terrain")) + 
          geom_sf(data = lakeErie_SF,
                  mapping = aes(geometry=geometry, 
                                color=DEPTH),
                  inherit.aes = FALSE) +       # don't inherit ggmap mappings
          scale_color_viridis(option="D");     # for contour line color scheme
  plot(plot3);
} 