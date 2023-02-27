{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  library(package=gridExtra);            # for multipaneling
  library(package=grid);                 # for add text
  
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                       stringsAsFactors = FALSE);

  #### Part 1: using grep to find days with a specific weather event
  rainyDays = grep(weatherData$weatherType, pattern="RA");   # any day with rain
  breezyDays = grep(weatherData$weatherType, pattern="BR");  # any breezy day

  #### Part 2: Scatterplot for Humidity vs. Temperature on breezy days
  plot1 = ggplot(data=weatherData[breezyDays,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Humidity vs. Temperature (Breezy Days)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");
  plot(plot1);

  #### Part 3: Combine weather events using set operations
  rainyAndBreezy = intersect(rainyDays, breezyDays);
  rainyOrBreezy = union(rainyDays, breezyDays);
  rainyNotBreezy = setdiff(rainyDays, breezyDays);
  breezyNotRainy = setdiff(breezyDays, rainyDays);

  #### Part 3b: Invert a condition using setDiff
  notRainyAndNotBreezy = setdiff(1:nrow(weatherData), rainyOrBreezy);
  
  #### Part 4: Creating plots for all rainy day/breezy day combinations
  # The plot data is being created but it is not being rendered here #
  plot2 = ggplot(data=weatherData[rainyDays,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Humidity vs. Temperature (Rainy Days)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plot3 = ggplot(data=weatherData[rainyAndBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Rainy AND Breezy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plot4 = ggplot(data=weatherData[rainyOrBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Rainy OR Breezy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plot5 = ggplot(data=weatherData[rainyNotBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Rainy and NOT Breezy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plot6 = ggplot(data=weatherData[breezyNotRainy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Breezy and NOT Rainy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  #### Adding titles
  multi5a=arrangeGrob(plot1, plot2, plot3, plot4,
                      top=textGrob(label="I llove llamas",  # Grobs are another lesson...
                                   gp=gpar(col="blue")),
                      bottom="And so should you",
                      layout_matrix = rbind(c(1,1,2),
                                            c(1,1,NA),
                                            c(4,3,3),
                                            c(4,NA,NA)));
  plot(multi5a);

  #### Declaring the matrix first
  layout = matrix(nrow=4, ncol=3, byrow=TRUE, # don't need both nrow,ncol
                  data = c(1,1,2,
                           1,1,NA,
                           4,3,3,
                           4,NA,NA));
  
  #### Extending plots across rows and columns using matrix
  multi5b=arrangeGrob(plot1, plot2, plot3, plot4,
                      layout_matrix = layout);
  plot(multi5b);
  
 
  
}
