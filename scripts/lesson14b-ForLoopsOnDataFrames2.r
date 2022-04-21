{
  rm(list=ls());  options(show.error.locations = TRUE);

  #### A little fancier regular expression (regex)
  csvFiles = list.files(path = "data/",
                        pattern = "Weather[A-z]{3,6}[0-9]{4}.csv$",  # $ says this is the end
                        full.names = TRUE);

  #### This time we are going to get all data frame and put then in a List
  LansingWeatherList = list();

  ## Go through each csv file and save the data frame to the list
  for(i in 1:length(csvFiles))
  {
    ### save the data from the with file to data
    tempData = read.csv(file=csvFiles[i]);
    
    ### Add the data frame to the List (can be combined with previous line)
    LansingWeatherList[[i]] = tempData;
    
    ### A way to pause to for loop and look at the Environment (can be removed)
    # readline(prompt = "Press enter");
  }
  ### Give a name to each data frame in the list 
  names(LansingWeatherList) = csvFiles;  # oooh, don't like those names
  
  ### Better yet, remove "data/" and ".csv" from the name
  names(LansingWeatherList) = substr(csvFiles, 
                              start = 6,                 # remove "data/"
                              stop = nchar(csvFiles)-4); # remove ".csv"
  
  #### Create a data frame that has the average temperature values (TAVG) 
  #    for Jan in all seven years, which will look something like this:
  #         2016  2017  2018  2019  2020  2021  2022
  # Jan1 
  # Jan2
  # Jan3
  # ...        The TAVG values go into the cells
  # Jan29
  # Jan30
  # Jan31
  
  ### Let's look at the first data frame only
  firstDataFrame1 = LansingWeatherList[1];   # oops,  this just creates another list
  firstDataFrame2 = LansingWeatherList[[1]]; # aaah, this extract the data frame
  
  ### Like last lesson, the unique dates gives us the number of rows.
  ### The number of data frames gives us the number of columns (one for each year)
  dates = unique(firstDataFrame2$date);
  numYears = length(LansingWeatherList);
  
  ### Create a data frame with dates as rows and years as columns
  newWeatherMat = matrix(nrow = length(dates),
                         ncol = numYears);   

  ### Give names to the rows and columns
  colnames(newWeatherMat) = names(LansingWeatherList); 
  rownames(newWeatherMat) = dates;

  ### Add the TAVG values to the matrix one year at a time 
  for(year in 1:numYears)  # cycle thru each year's data frame
  {
    ### Save the data frames from the list to a temp data frame
    tempDF = LansingWeatherList[[year]];  # remember -- 2 brackets!
    
    ### Find which rows have average temperature values
    avgRows = which(tempDF$datatype == "TAVG");
    
    ### Create a new data frame with only the TAVG rows
    tavgDF = tempDF[avgRows,];
    
    ### Add the TAVG values for the year
    for(date in 1:nrow(tavgDF))  # cycle thru each row in tavg data frame
    {
      # date is the row, year is the column and the
      # value is the value from the tavg data frame
      newWeatherMat[date, year] = tavgDF$value[date];
    }
  }
}

### Application:
  #1)  Create a data frame that has the difference in temperature values (TMAX-TMIN) 
  #      for Jan in all seven years, which will look something like this:
  #
  #         2016  2017  2018  2019  2020  2021  2022
  # Jan1 
  # Jan2
  # Jan3
  # ...        The difference in temperatures
  # Jan29         values go into the cells
  # Jan30
  # Jan31

  #2)  Create a data frame that has the average (mean TAVG), maximum (max TMAX), and minimum (min TMIN)
  #    temperature for the whole month
  #
  #            AveTemp    MaxTemp   MinTemp  
  # Jan2016 
  # Jan2017        
  # Jan2018
  # Jan2019       
  # Jan2020         
  # Jan2021
  # Jan2022