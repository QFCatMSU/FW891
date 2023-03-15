{f
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  library(package=akima);
  
  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  # for people still using R v3
  
  #### Part 1: Mapping point size and color ####
  plot1 = ggplot( data=weatherData, 
                  mapping = aes(x=avgTemp, y=relHum, 
                                z = precip2) ) +
    # geom_raster(mapping = aes(x=avgTemp, y=relHum, 
    #                           fill = precip2),
    #             interpolate=TRUE) + #after_stat(level))) +
    theme_bw() +
    stat_summary_2d(binwidth = 10) +
    scale_fill_gradient2('precip2', 
                         low = "green", 
                         mid = "blue", 
                         high = "red", 
                         midpoint = 0.2,
                         limits=range(-1,2)) +
    # geom_density_2d(mapping = aes(x=avgTemp, y=relHum, 
    #                               color = precip2)) + #after_stat(level))) +

   # layer(geom="raster", params=list(interpolate=TRUE)) +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)",  
         y = "Humidity (\u0025)");     
  plot(plot1);
}
