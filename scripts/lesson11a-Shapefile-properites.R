{ 
  rm(list=ls());  options(show.error.locations = TRUE);

  #### Alternative way to install a package: only need to do once per computer
  #    devtools::install_github("ropensci/rnaturalearthhires");
  
  # sp needs to be installed before sf package but you will still
  # get an error about sp not being installed -- this can be ignored
  # library(package = "sp");       #old Simple Features (but still needed)
  # library(package = "rgeos");    # getting/converting crs
  # library(package = "rgdal");    # getting/converting crs
   library(package = "ggplot2");
  # library(package = "dplyr");
   library(package = "sf");       # Simple Features
  # library(package = "rnaturalearth");     # for getting coord data
  # library(package = "rnaturalearthdata"); # for getting coord data

  museums = st_read(dsn="data/museum.csv");
  
  # The simple features (SF) museums is the museums data frame 
  # with these differences: 
  #   - SF has meta data (bounding box, CRS, geometry) 
  #   - SF combines the coordinates from the data frame into geometry
  # Otherwise, they are the same (i.e., the columns in the data frames are the same)
  museums_SF1 = st_as_sf(museums, 
                         coords = c("lng", "lat"),
                         crs = 4326);
  
  # Change the crs before plotting 
  museums_SF2 = st_transform(museums_SF1, crs = 3593);

  # Look at metadata for the CRS
  print(museums_SF1);
  print(museums_SF2);
  
  #### Finding meta data for large shapefiles is hard so...
  # Look at the bounding boxes for both of the simple features:
  boundBox1 = st_bbox(museums_SF1);
  boundBox2 = st_bbox(museums_SF2);
  
  # Look at the CRS for both SF
  crs1 = st_crs(museums_SF1);
  crs2 = st_crs(museums_SF2);
  
  # Look at the geometry for both SF
  geometery1 = st_geometry(museums_SF1);
  geometery2 = st_geometry(museums_SF2);
  
  #### Geometries:
  #    - Point (2 coordinate values: long/lat or north/east)
  #    - Multipoint (multiple points)
  #    - Linestring (multiple points with line between consecutive points)
  #    - Multilinestring (mutiple linestrings)
  #    - Polygon    (linestring with a line connecting first and last point)
  #    - Multipolygon (mutiple polygons)
  #    https://r-spatial.github.io/sf/articles/sf1.html
  
  
  # Plot the museum simple feature by itself
  #  Note: geom_sf will use the "bounding box" to determine the axes
  #        if no coordinates are given
  plot1 = ggplot() +
    geom_sf(data = museums_SF2,
            mapping = aes(geometry = geometry),
            color = "red");
  plot(plot1);
  
  # You could add an annotation as long as you know the bounding box
  plot2 = ggplot() +
    geom_sf(data = museums_SF2,
            mapping = aes(geometry = geometry),
            color = "red") +
    annotate(geom="text",    # adding two text annotations
             x = c(10000000, 11000000), # 2 northings
             y = c(-1000000, -1500000), # 2 eastings
             color = "blue", # both get same color
             label = c("Have I found the map?", "I did!"));
  plot(plot2);
  
  # But, if you are adding components that are not geom_sf
  #  you will get in trouble when the CRS changes
  plot3 = ggplot() +
    geom_sf(data = museums_SF2,
            mapping = aes(geometry = geometry),
            color = "red") +
    annotate(geom="text",
             x = c(10000000, 11000000),
             y = c(-1000000, -1500000),
             color = "blue",
             label = c("Have I found the map?", "I did!")) +
    coord_sf(crs = 26917);   # changing CRS
  plot(plot3);
  
  #### Better solution: create a SF that has the text ####
  
  ## Create a data frame with the text and the coordinates
  textDF = data.frame(labels = c("Have I found the map?", "I did!"),
                      northing = c(10000000, 11000000),
                      easting = c(-1000000, -1500000));
  
  ## Convert the data frame to an SF and include the CRS
  textDF_SF = st_as_sf(textDF,
                       coords = c("northing", "easting"),  # yes, this is opposite of lon,lat
                       crs = 3593); # this number is the original CRS
  
  ## Now the text "annotation" will convert to the new CRS
  plot4 = ggplot() +
    geom_sf(data = museums_SF2,
            mapping = aes(geometry = geometry),
            color = "red") +
    geom_sf_text(data = textDF_SF,
                 mapping=aes(geometry=geometry, label=labels),
                 color = "blue") +
    coord_sf(crs = 26917);   # changing CRS
  plot(plot4);
  
  
  #### Application #####
  #   Add three new points to the data frame 
  #   - use only one SF
  #   - make each point a different color, size, and shape
  #   - make sure the bounding box does not change because of the new points
}
