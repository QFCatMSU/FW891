{ 
  rm(list=ls());  options(show.error.locations = TRUE);
  source(file="scripts/spatial-header.R"); # moved all package info to header.r
  
  pseudoData = read.csv("data/pseudoData.csv");
  
  ### 3 parts to formatting dates and date-times (similar to Simple Features)
  #   1) Tell R how the date or date-time is formatted
  #   2) R returns a standardized date or date-time object to you
  #   3) Use the standardized object to extract/format information
  
  ### The page you need to reference:
  # https://stat.ethz.ch/R-manual/R-devel/library/base/html/strptime.html
  
  ### And a good video about why things are so complicated:
  # https://www.youtube.com/watch?v=-5wpm-gesOY
  
  # date1 looks like this: Apr 15, 2022
  # broken down there is:
  #    - the abbreviation for the month (%b)
  #    - a space
  #    - the day of the month (%d)
  #    - a comma and a space
  #    - the 4-digit year (%Y)
  
  ### Read in the first column and convert to a Date
  stnDate = as.Date(pseudoData$date1,      # date1 is a chr (string) column
                    format="%b %d, %Y");   # give the format of date1
  
  ### Since date1 is in Date format, we can change to any format...
  date_formatted = format(stnDate, format="%m-%d-%y"); # this is a chr vector -- not Date
  
  ### Or, just pull info from it
  date_weekOfDay = format(stnDate, format="%A");       # this is a chr vector
  
  # dateTime1 looks like this: 2022-04-15 09:56PM
  # broken down there is:
  #    - the 4-digit year (%Y)
  #    - a dash
  #    - Month as a number (%m)
  #    - a dash
  #    - the day of the month (%d)
  #    - a space
  #    - Hour in 12-hour time (%I)
  #    - a colon
  #    - minutes (%M)
  #    - AM/PM indicator (%p)
  
  ### With date-time columns, we need to use POSIXct
  ##    POSIXct is the UNIX standard for date-times (developed in the 1970s)
  stnDateTime = as.POSIXct(pseudoData$dateTime1,
                           format="%Y-%m-%d %I:%M%p");
  
  ### And, again, we can reformat:
  dateTime_formatted = format(stnDateTime, format="%m-%d-%y %H%m");  # a chr vector
  
  ### Or, pull some information out of it:
  dateTime_weekOfDay = format(stnDateTime, format="%a");             # a chr vector
  
  ### If we want we can put the new date vectors in the data frame:
  pseudoData$date_ref = date_formatted;
  pseudoData$weekOfDay = dateTime_weekOfDay;

  ### Application:
  # 1) Create a script file in your script folder named app13.r
  # 2) Create a properly formatted Date object from the pseudoData 
  #    columns date2 and date3
  # 3) Create a properly formatted POSIXct object from the 
  #    pseudoData columns dateTime2 and dateTime3
  # 4) Create a vector that has the dates in this format: 15-April, 2022
  #    - add this vector to a column named date_formatted in pseudoData
  # 5) Create a vector that has the date-times in this format: 09:36 on Fri 04/15/22 
  #    - add this vector to a column named dateTime_formatted in pseudoData
  # 6) Create a vector that has the number of seconds since the epoch 
  #    - this is since Jan 1, 1970 at midnight GMT (but you do not need this info)
  #    - add this vector to a column named epoch in pseudoData
}
