{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  
  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv");
  
  plot1 = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=relHum, y=avgTemp, 
                            shape=windDir, color=windSpeed),
                size=4) +
    theme_minimal() +
    labs(title = "Humidity (relHum) vs Temperature (avgTemp)",
         subtitle = "Lansing, Michigan: 2016",
         y = "Temp \n(F)",   # comment about \n
         x = "Humidity (%)") +
    scale_x_continuous(breaks = c(50,60,70,80,90)) +
    scale_y_continuous(limits = c(0, 100)) +
    theme( axis.title.x=element_text(size=16, color="lightblue"),
           axis.title.y=element_text(size=12, angle=0, vjust=0.5, color="lightblue"),
           plot.title=element_text(size=18, face="bold", hjust=0.5,
                                   color ="lightgreen"),
           plot.subtitle=element_text(size=10, face="italic", hjust=0.5, 
                                      color="white"),
           axis.line.x.bottom = element_line(linewidth = 2, color = "lightgreen"),
           axis.line.y.left = element_line(linewidth = 2, color = "lightgreen"),
           axis.ticks.y.left = element_line(color="red", linewidth=5),
           axis.text.x=element_text(angle=270, vjust=0.5, color="pink",
                                    face="bold"),
           axis.text.y=element_text(color="pink"),
           legend.background = element_rect(color="green", fill="grey90",
                                            linewidth=1, linetype=2),
           ### comment about legend themes
           legend.key = element_rect(fill="lightblue", color="blue"),
           legend.position="bottom",
           legend.title = element_text(color="brown", face="bold", vjust=.85),
           panel.grid.major = element_line(linewidth=1, color="grey80"),
           panel.grid.minor = element_line(linewidth=0.2, linetype=4, color="grey80"),
           plot.background = element_rect(fill="black"),
           panel.background = element_rect(fill="lightyellow"));
  plot(plot1);
}