{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
#  source(file="themes/ggplot_theme.r");
  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  
  
  #### Part 1: Add year to date values ####
  # a) save the date vector from the data frame to the variable theDate
  theDate1 = weatherData$date; 

  # b) need a year in the date before formatting--
  theDate2 = paste(theDate1, "-2016", sep="");
  
  # c) Save the values in Date format
  theDate3 = as.Date(theDate2, format="%m-%d-%Y");

  # d) Save theDate back to the data frame as a new column
  weatherData$dateYr = theDate3;

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
          plot.title = element_text(hjust = 1),
          plot.subtitle = element_text(hjust = 1),
          axis.text = element_text(color="blue", family="mono", size=9)) +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot6);
  
}