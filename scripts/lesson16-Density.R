{ 
  rm(list=ls());  options(show.error.locations = TRUE);

  # sp needs to be installed before sf package but you will still
  # get an error about sp not being installed -- this can be ignored
  library(package = "sp");       #old Simple Features (but still needed)
  library(package = "rgeos");    # getting/converting crs
  library(package = "rgdal");    # getting/converting crs
  library(package = "ggplot2");
  library(package = "viridis");
  library(package = "dplyr");
  library(package = "sf");       # Simple Features
  library(package = "rnaturalearth");     # for getting coord data
  library(package = "rnaturalearthdata"); # for getting coord data
  
  US_Pop = read.csv(file="data/US_Pop_By_State.csv");
  
  states = ne_states(country = "United States of America");
  states_SF = st_as_sf(states);

  ### create a new column called population:
  states_SF$population = "";
  
  ### Fill in the popluation column
  for(i in 1:nrow(states_SF))
  {
    thisState = states_SF$woe_name[i];
    stateIndex = which(US_Pop$State == thisState);
    states_SF$population[i] = US_Pop$Population[stateIndex];
  }
  
  ### Remove the commas from the numbers
  states_SF$population = gsub(states_SF$population,
                              pattern = ",",
                              replacement = "");
 
  ### Make the column numeric:
  states_SF$population = as.numeric(states_SF$population);
  
  
  plot1 = ggplot() +
    geom_sf(data = states_SF,
            mapping = aes(geometry = geometry, 
                          fill=population),
            color = "black") +
    scale_fill_viridis(option="H") + 
    coord_sf(crs = 4326,    
             xlim = c(-125, -65),  
             ylim = c(20, 60));
  plot(plot1);
}