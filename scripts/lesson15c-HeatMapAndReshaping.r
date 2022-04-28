{
  rm(list=ls());  options(show.error.locations = TRUE);
  library(package = "ggplot2");
  library(package = "reshape2");
  
  #### Topics:
  #    1) heat maps using geom_tile() 
  #       - geom_tile() effectively requires three mappings: x,y, fill
  #    2) "melting" data frames using reshape2 package
  #    3) "melting" data frames using for loops
  #    4) turning numbers into factors (because we do not want continuous values in a heatmap)
  
  # Note: variable names cannot start with a number (this includes columns)
  Jan_Avg = read.csv(file = "data/Jan_TAVG.csv");

  #### Create a new data frame like this:
  #  Date  Year      TAVG
  #    1   2016   (temp value)
  #    2   2016   (temp value)
  #    3   2016   (temp value)
  #    4   2016   (temp value)
  #  ...
  #   28   2022   (temp value)
  #   29   2022   (temp value)
  #   30   2022   (temp value)
  #   31   2022   (temp value)
  
  ### Add a date column
  Jan_Avg$Date = rownames(Jan_Avg);
  
  ### Use the melt function in the reshape2 package
  #   measure.vars: columns you are melting (switching from horizontal to vertical)
  #   variable.name: the name of the new melted column
  #   value.name: the name of the column that has the values for the new melted column
  Jan_Avg_Melt = melt(Jan_Avg,
                      measure.vars = c("X2016", "X2017", "X2018",
                                       "X2019", "X2020", "X2021",
                                       "X2022"),
                      variable.name = "Year",
                      value.name = "Temperature");
  
  
  ### Remove the "X" from the Year column
  Jan_Avg_Melt$Year = sub(Jan_Avg_Melt$Year, 
                          pattern = "X",
                          replacement = "");
  
  ### Create the heat plot
  #   We are mapping: x to date, y to years, and fill to temperature
  #   Note: date and year are numeric but need to be forced info factors
  plot1 = ggplot(data = Jan_Avg_Melt) +
    geom_tile(mapping = aes(x=as.factor(as.numeric(Date)), # 1-31
                            y=as.factor(Year),             # 2016-2022
                            fill=Temperature)) +          
    scale_fill_gradientn(colors = c("blue", "red")) + 
    theme_bw() +    
    labs(x = "Date",
         y = "Year",
         fill = "Temp (\U00B0 C)");
  plot(plot1);
  
  ### Alternative: "reshape" the data frame yourself
  
  ### Create the matrix 
  Jan_Temp_Mat = matrix(nrow = 7 * 31,
                        ncol = 3);  
  
  ### Give names to the columns
  colnames(Jan_Temp_Mat) = c("Date", "Year", "Temperature");
  
  ### Convert matrix to a data frame 
  Jan_Temp_DF = as.data.frame(Jan_Temp_Mat);
  
  ### Add in the values for the three columns
  for(i in 1:nrow(Jan_Temp_Mat))
  {
    ## %% is the modulus operator -- it gives the remainder
    #  %% is used when you are cycling through a set number of values
    ## floor() removes the decimal 
    whichDate = ((i-1)%%31 +1);      # values between 1-31
    whichYear = floor((i-1)/31) +1;  # values between 1-7
    
    if(i > 215)
    {
      cat(); # for breakpoints
    }
    
    Jan_Temp_DF$Date[i] = whichDate; 
    Jan_Temp_DF$Year[i] = 2015 + whichYear; 
    Jan_Temp_DF$Temperature[i] = Jan_Avg[whichDate, whichYear]; 
  }

  ### Create the heat plot
  plot2 = ggplot(data = Jan_Temp_DF) +
    geom_tile(mapping = aes(x=as.factor(Date), 
                            y=as.factor(Year),
                            fill=Temperature)) +
    scale_fill_gradientn(colors = c("purple", "orange")) + 
    theme_bw() +    
    labs(x = "Date",
         y = "Year",
         fill = "Temp (\U00B0 C)");
  plot(plot2);
}
