{ 
  rm(list=ls());  options(show.error.locations = TRUE);

  #### Install package -- you will be prompted by RStudio 
  
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

  museums = st_read(dsn="data/museum.csv");
  museums_SF = st_as_sf(museums, 
                        coords = c("lng", "lat"),
                        crs = 4326);

  # Lake MI is a KML file downloaded for the MI arcgis website
  lakeMichigan = st_read(dsn="data/Lake_Michigan_shoreline.kml");
  lakeMI_SF = st_as_sf(lakeMichigan); 
  
  # Lakes are a shapefile downloaded from the natural earth website
  lakes = st_read(dsn="data/lakes/ne_10m_lakes.shp");  
  lakes_SF = st_as_sf(lakes); 
  
  # You can also use the rnaturalearth package to get spatial files
  states = ne_states(country = "United States of America");
  states_SF = st_as_sf(states);

    
  #### Make a line from the museum points:
  # using dplyr -- very clean
  museumLine = dplyr::summarise(museums_SF);            # creates an SF multipoint
  museumLine_SF = st_cast(museumLine, to="LINESTRING"); # creates an SF linestring
  
  # convert points to a linestring (official way -- not as clean)
  museumLine2 = st_union(museums_SF);    # creates a List instead of a data frame  
  museumLine2_SF = st_cast(museumLine2, to="LINESTRING");
  
  # Remember that later component layer on top of earlier components
  plot1 = ggplot() +
    geom_sf(data = states_SF,
            mapping = aes(geometry = geometry),
            color = "black",
            fill = "grey") +
    geom_sf(data = lakes_SF,
            mapping = aes(geometry = geometry),
            color = "lightblue",
            fill = "lightblue") +
    geom_sf(data = lakeMI_SF,
            mapping = aes(geometry = geometry),
            color = "blue",
            fill = "blue") +
    geom_sf(data = museumLine_SF,   # created with dplyr
            mapping = aes(geometry = geometry),      
            color = "yellow", 
            size = 2) +
    geom_sf(data = museumLine2_SF,  # create with st_convert
            mapping = aes(geometry = geometry),      
            color = "blue") +
    geom_sf(data = museums_SF,      # overlap points on the lines
            mapping = aes(geometry = geometry),      
            color = "red") +
    coord_sf(crs = 26917,   
        xlim = c(-3000000, 2000000),  
        ylim = c(3000000, 7000000),
        expand = TRUE);
  plot(plot1);
}