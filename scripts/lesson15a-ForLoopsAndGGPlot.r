{
  rm(list=ls());  options(show.error.locations = TRUE);
  library(package = "ggplot2");
  library(package = "viridis"); # for colors
  
  #### Topics:
  #    1) for loops and ggplot-- need to use aes_()
  #    2) using the viridis package to set colors
  #    3) making numeric values discrete using as.factor()
  #    4) turning numeric strings into numbers using as.numeric()
  
  ### January temperatures in Lansing 2016-2022
  Jan_Avg = read.csv(file = "data/Jan_TAVG.csv");

  ### Create a ggplot canvas 
  plot1 = ggplot(); 
  
  ### Plot each of the seven columns in Jan Temps
  for(i in 1:ncol(Jan_Avg))
  {
    ### When using for loops, you need to use aes_() instead of aes()
    #   We are mapping: x to temperatures, y to years, and fill to dates
    plot1 = plot1 + 
      geom_point(mapping=aes_(x=Jan_Avg[,i],          # plot temperature column i
                              y=colnames(Jan_Avg)[i], # (2016:2022)[i]
                              fill=as.numeric(rownames(Jan_Avg))), # 1:31
                 shape = 22,
                 size = 4,     # these 3 are subcomponents -- not mappings
                 stroke = 2);
  }
  
  plot1 = plot1 + 
    theme_minimal() + 
    scale_fill_viridis(discrete = FALSE, # continuous values
                       option = "A",     # options are A-H, D is Viridis
                       direction = 1) +  # -1 reverses the colors
    labs(x = "Temp (\U00B0 C)",
         y = "Year",
         fill = "Dates");
  plot(plot1);
  
  ### Viridis info:
  # https://www.rdocumentation.org/packages/viridis/versions/0.6.2/topics/scale_fill_viridis
  
  ## Questions 
  #  How would you change plot1 if you wanted to plot each row (instead of column) in Jan_Avg?
  #  How would you take the "X" out of the years?
  
  
  ### Create a ggplot canvas 
  plot2 = ggplot(); 
  
  ### Make a line plot for each of the seven columns  
  for(i in 1:ncol(Jan_Avg))
  {
    ### Mapping: x to dates, y to temperatures, and color to year
    plot2 = plot2 + 
      geom_line(mapping=aes_(x=as.numeric(rownames(Jan_Avg)),  # 1:31
                             y=Jan_Avg[,i], # plot temperature column i
                             color=colnames(Jan_Avg)[i]), # as.factor(2016:2022)[i]
                size = 1.5);
  } 
  
  plot2 = plot2 +
    theme_bw() + 
    scale_color_viridis(discrete = TRUE, # values are discrete (not continuous)
                        option = "H",    # options are A-H, default is D (Viridis)
                        direction = 1) + # -1 reverses colors
    labs(x = "Date",
         y = "Temp (\U00B0 C)",
         color = "Year");
  plot(plot2);
  
}
