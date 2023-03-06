{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package

  ### Use application from boxplots2 ####
  
  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  # for people still using R v3
  
  ### Part 7a: Boxplot ####
  plot7a = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp)) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Change in Temperature (\u00B0F)");
  plot(plot7a);
  
  ### Re-order the directions on the x-axis using factor(s)
  windDirOrdered = factor(weatherData$windDir,
                       levels=c("North", "East", "South", "West"));
  
  #### A Reordering the Boxplot ####
  plot7b = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp)) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Change in Temperature (\u00B0F)");
  plot(plot7b);
  
  #### Part 8: Map color to windSpeed(s)
  # windSpeedOrdered = factor(weatherData$windSpeedLevel,
  #                         levels=c("Low", "Medium", "High"));
  
  # A Boxplot with a mapping ####
  plot8 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp, fill=windSpeedLevel),
                 na.rm = TRUE) +  # gets rid of warning about non-finite values
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)",
         fill = "Wind Speed");
  plot(plot8);
  
  #### Part 9: Same boxplot faceted by wind speed instead of mapped ####
  plot9 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE) +  
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) + 
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot9);
  
  #### Part 10: violin plot (make this earlier!) ####
  plot10 = ggplot(data=weatherData) +
    geom_violin(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                na.rm = TRUE) +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot10);
  
  #### Part 11: Manually setting colors (not mapped!) ####
  plot11 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE,   # gets rid of warning about non-finite values
                 color = "brown",
                 fill = "grey70") +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) +  
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)",
         fill="Wind Speed");
  plot(plot11);

  
  #### Part 12: Manually setting all 12 boxes (not mapped!) ####
  # there are 12 boxes to color so we need a vector with 12 colors:
  boxColors = c("blue", "blue", "blue", "brown",
                "brown", "brown", "brown", "brown",
                "brown", "brown", "brown", "brown");
  
  ### same vector as above -- uses repeat function: 
  boxColors = c(rep("blue", 3),
                rep("brown", 9));
  
  plot12 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE,  
                 color = boxColors,
                 fill = "grey70") +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot12);

  #### Part 13: Messing with the outliers ####
  plot13 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE,   # gets rid of warning about non-finite values
                 color = boxColors,
                 fill = "grey50",
                 outlier.color = rgb(red=0, green=0.3, blue=0),
                 outlier.shape = "\u053e") +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot13);
  
  ### Part 14: Changing facet labels
  windLabels = c(Low = "Light Winds",
                 Medium = "Medium Winds",
                 High = "Strong Winds");

  plot14 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE,   # gets rid of warning about non-finite values
                 color = boxColors,
                 fill = "grey50",
                 outlier.color = rgb(red=0, green=0.3, blue=0),
                 outlier.shape = "\u053e") +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel),
                labeller=as_labeller(windLabels)) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot14);

  #### Part 15: Add date labels to the outlier ####
  
  #### Extension -- Error bars  ####
  plotA = ggplot(data=weatherData) +          
      stat_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                   na.rm=TRUE,
                   geom = "errorbar",   # adds the whisker ends
                   width = 0.2,         # width of whisker ends (0 to 1)
                   color = boxColors) + # keep ends the same color as whiskers
      geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                   na.rm = TRUE,  
                   color = boxColors,
                   fill = "grey50",
                   outlier.color = rgb(red=0, green=0.3, blue=0),
                   outlier.shape = "\u053e") +
      theme_bw() +
      facet_grid( cols=vars(windSpeedLevel)) +
      labs(title = "Change in Temperature vs. Wind Direction",
           subtitle = "Lansing, Michigan: 2016",
           x = "Wind Direction",
           y = "Degrees (Fahrenheit)");
    plot(plotA);
}