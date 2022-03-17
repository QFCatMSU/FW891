{
  # get points from sf
  # get lines from sf?
  # add gpplot components?
  # add points from 
  
  rm(list=ls());  options(show.error.locations = TRUE);

  library(package="tidyverse");
  library(package="leaflet");
  
  museumData = read.csv(file="data/museum.csv");
  
  map = leaflet();

  map = setView(map=map, 
          lng=-87, lat=43.4,
          zoom = 5);
  
  ## leaflet providers: https://leaflet-extras.github.io/leaflet-providers/preview/
  map = addProviderTiles(map=map,
                         provider = providers$OpenTopoMap);
  map = addMarkers(map=map, lng=-87, lat=43.4, layerId = 100,
                   popup="Stuff here!");
  map = addTiles(map=map);

  print(map);


}