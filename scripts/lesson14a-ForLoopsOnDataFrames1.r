{
  rm(list=ls());  options(show.error.locations = TRUE);

  #### One way to get the files (convenient for lots of files)
  csvFiles = list.files('data/',
                        pattern = 'LansingWeatherJan20[0-9][0-9].csv',  # look for 2 chars between 0 and 9
                        full.names = TRUE);

  #### Just going to use the first file for this lesson
  lansingWeatherDF = read.csv(file=csvFiles[1]);  # the 2016 data
  
  #### Let's get the year from the file name
  # First, get the number of characters in the file name
  numChars = nchar(csvFiles[1]);
  
  # The file name is data/LansingWeatherJan2016.csv
  # We only need 16 (6th to last to 5th to last characters)
  yearOfData = substr(csvFiles[1], 
                      start = numChars-5,  # 6th to last character
                      stop = numChars-4);  # 5th to last character
  
  #### The data is not formatted the way we want
  #### What we want (need to "reshape" the data frame):
  #         AWND  PRCP  SNOW  TAVG  TMAX  TMIN  WDF2 ...
  # Jan1 
  # Jan2
  # Jan3
  # ...       The Values columns goes in all these cells
  # Jan29
  # Jan30
  # Jan31
  
  #### Create a new data frame (matrix) that will have
  #    - datatypes (AWND, PRCP, SNOW) as columns
  #    - dates (Jan1-Jan31) as the rows
  #    - values for the datatypes on each date in the cells
  
  #### Get dimensions for the new matrix, which is the same as the 
  #       number of different dates (rows) and datatypes (columns)
  dates = unique(lansingWeatherDF$date);         # length is number of rows
  datatypes = unique(lansingWeatherDF$datatype); # length is numbner of columns
  
  #### Create a matrix with the correct number of rows and columns
  #    Note: all the cells will be NA right now
  newWeatherMat = matrix(nrow = length(dates), 
                         ncol = length(datatypes));
  
  #### Add the dates as rownames and datatypes and column names
  rownames(newWeatherMat) = dates;
  colnames(newWeatherMat) = datatypes;

  #### If you want, you can make this into a data frame (but not necessary)
  # newWeatherDF = as.data.frame(newWeatherMat);
  
  #### Now we copy the values from the orig data frame to the 
  #    cells in the matrix
  for(rowNum in 1:nrow(lansingWeatherDF))  # cycle thru each row in the orig data frame
  {
    # get the date and the datatype from the row in the orig data frame
    thisDate = lansingWeatherDF$date[rowNum];
    thisDatatype = lansingWeatherDF$datatype[rowNum];
    thisValue = lansingWeatherDF$value[rowNum];
    
    # Put the value from the original data frame on:
    # - the row given by thisDate
    # - the column given by thisDataType
    newWeatherMat[thisDate, thisDatatype] = thisValue;
  }
 
  
  # Application:
  # 1) change the list.files()  so that it can read in file names that
  #     have years from 1989 to 2022
  # 2) change yearOfData so that it gets the full four-digit year
  # 3) Add all of the February data to the Matrix from  
  #     data/Lansing-Feb2016.csv
  #     
  #     So, the final matrix will look like this:
  #         AWND  PRCP  SNOW  TAVG  TMAX  TMIN  WDF2 ...
  # Jan1 
  # Jan2
  # Jan3
  # ...      
  # Jan29
  # Jan30      The Values columns goes in all these cells
  # Jan31
  # Feb1 
  # Feb2
  # Feb3
  # ...     
  # Feb29
  
  ### Best to use 2 for loops (1 for Jan, 1 for Feb)
  ### The hardest part is offsetting the matrix for the February values
}