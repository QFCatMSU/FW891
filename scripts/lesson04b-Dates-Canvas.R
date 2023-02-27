{
  # create a theme
  # use theme in next lesson
  # undoing geom defaults...
  
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  source(file="themes/ggplot_theme.r");
  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  
  
  #### Part 1: From last lesson ###
  plot1 = ggplot(data=weatherData) +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(x=1:nrow(weatherData), y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                linewidth=2,
                fill="lightgreen") +
    theme_bw() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot1);
  
  #### Part 1: Add year to date values ####
  # a) save the date vector from the data frame to the variable theDate
  theDate1 = weatherData$date; 

  # theDate = weatherData[["date"]];  # equivalent to previous line
  # theDate = weatherData[ , "date"]; # equivalent to previous 2 lines in base R not equivalent in TidyVerse
  
  # b) need a year in the date before formatting--
  #    append (paste) "-2016" to all values in theDate
  theDate2 = paste(theDate1, "-2016", sep="");
  # theDate = paste(theDate, "2016", sep="-"); # functionally equivalent to previous line
  # theDate = paste(theDate, "16", sep="-20"); # also equivalent 
  
  # c) Save the values in Date format
  theDate3 = as.Date(theDate2, format="%m-%d-%Y");

  # d) Save theDate back to the data frame as a new column
  weatherData$dateYr = theDate3;  
  # weatherData[["dateYr"]] = theDate3;  # equivalent to previous line
  # weatherData[, "dateYr"] = theDate3;  # equivalent to previous 2 lines

  #### Part 2: Use Dates on x-axis ###
  plot2 = ggplot(data=weatherData) +
    geom_line(mapping=aes(x=dateYr, y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(x=dateYr, y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(x=dateYr, y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                linewidth=2,
                fill="lightgreen") +
    theme_bw() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot2);
  
  #### Part 3: Move x to canvas --
  ###   only works because EVERY geom uses dateYr
  plot3= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                size=2,
                fill="lightgreen") +
    theme_bw() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot3);
  
  #### Part 4: Convert date format -- will not work!
  ## Note geom_path warning:
  ##   geom_path: Each group consists of only one observation. 
  ##   Do you need to adjust the group aesthetic?
  dateYrFormatted = format(weatherData$dateYr, format="%m/%d");
  plot4= ggplot(data=weatherData[1:4,], mapping=aes(x=dateYrFormatted[1:4])) +
    geom_line(mapping=aes(y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                size=2,
                fill="lightgreen") +
    theme_bw() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot4);
  
  #### Part 5: Convert date format and date breaks
  plot5= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                size=2,
                fill="lightgreen") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels =  "%m/%d") +
    theme_bw() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot5);

  #### Part 6: Add theme component
  plot6= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                size=2,
                fill="lightgreen") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels =  "%m/%d") +
    theme_bw() +
    theme(panel.background = element_rect(fill="grey25",
                                          size=2, color="grey0"),
          panel.grid.minor = element_line(color="grey50", linetype=4),
          panel.grid.major = element_line(color="grey100"),
          plot.background = element_rect(fill = "lightgreen"),
          plot.title = element_text(hjust = 0.45),
          plot.subtitle = element_text(hjust = 0.42),
          axis.text = element_text(color="blue", family="mono", size=9)) +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot6);
  
  #### Part 7: Use a theme saved elsewhere
  plot7= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                size=2,
                fill="lightgreen") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels =  "%m/%d") +
    theme_ugly() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot7);
  
  #### Part 8: Include geom defaults in theme 
  #     Note: you can only choose one property --
  #           but you can further edit the colors
  plot8= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp)) +
    geom_line(mapping=aes(y=minTemp)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels = "%m/%d") +
    theme_uglyAdv() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot8);
 
  #### Part 9: Forget to detach the defaults
  plot9= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp)) +
    geom_line(mapping=aes(y=minTemp)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels =  "%m/%d") +
    theme_uglyAdv_noDetach() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot9); 
  
  #### Part 10: Forget to detach the defaults stick around
  #             this is a session variable!
  plot10= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp)) +
    geom_line(mapping=aes(y=minTemp)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels =  "%m/%d") +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot10); 
}  