{ 
  rm(list=ls());  options(show.error.locations = TRUE);
  source(file="scripts/spatial-header.R"); # moved all package info to header.r
  
  library(package = "gganimate");  # for animations
  
  dateColumns = function(index, curTime, data)
  {
    data$date1[index] = format(curTime,format="%b %d, %Y");
    data$date2[index] = format(curTime,format="%Y-%m-%d");
    data$date3[index] = format(curTime,format="%m/%d/%y");
    data$dateTime1[index] = format(curTime,format="%Y-%m-%d %I:%M%p");
    data$dateTime2[index] = format(curTime,format="%Y-%m-%d %H:%M:%S");
    data$dateTime3[index] = format(curTime,format="%Y-%m-%d %Hh%Mm");
    return(data);
  }
  # using GLATOS data
  fishTracks = st_read(dsn="data/Two_Interpolated_Fish_Tracks.csv");

  ### Get date from timestamps
  timeStamp_Orig = fishTracks$bin_timestamp;
  timeStamp_Date = as.Date(timeStamp_Orig, format="%m/%d/%Y");
  
  # Two ways to save a timestamp:
  timeStamp_POSIXlt = as.POSIXlt(timeStamp_Orig,
                                 format="%m/%d/%Y %H:%M",
                                 tz=Sys.timezone());
  timeStamp_POSIXct = as.POSIXct(timeStamp_Orig,
                                 format="%m/%d/%Y %H:%M",
                                 tz=Sys.timezone());
  
  #### Extract information from a posixct:
  dates = format(timeStamp_POSIXct, format = "%d");
  day = format(timeStamp_POSIXct, format = "%A");
  fancier = format(timeStamp_POSIXct, format = "%a %b %e, %Y");
  
  ## Seconds since the Unix epoch started (Jan 1, 1970)
  since1970 = format(timeStamp_POSIXct, format = "%s") 

  #### Julian Dates:
  realDates = as.Date(seq(from=12000, to=13000, by=4), 
                      origin=as.Date("1960-01-01"))
  
  dayOfWeek = format(realDates, format = "%A");
  
  startTime = "2022-04-15 9:41pm";
  startTimePosix = as.POSIXct(startTime,
                              format="%Y-%m-%d %I:%M%p",
                              tz=Sys.timezone());
  
  startTimePosix = startTimePosix + 60*15;  # adds time in seconds

  pseudoData = data.frame(matrix(ncol=9, nrow=300));
  colnames(pseudoData) = c("date1", "date2", "date3",
                           "dateTime1", "dateTime2", "dateTime3",
                           "northing", "easting", "individual");

  currentTime = startTimePosix;
  pseudoData = dateColumns(1, currentTime, pseudoData);
  #pseudoData$dateTime[1] = format(currentTime,format="%Y-%m-%d %I:%M%p");
  pseudoData$northing[1] = 200000; # increase moves north
  pseudoData$easting[1] = 650000;  # increase moves east
  pseudoData$individual[1] = 1;
  
  for(i in 2:100)
  {
     currentTime = currentTime + 15*60;
     pseudoData = dateColumns(i, currentTime, pseudoData);
 #    pseudoData$dateTime[i] = format(currentTime,format="%Y-%m-%d %I:%M%p");
     pseudoData$northing[i] = pseudoData$northing[i-1] + sample(-100:100, 1);
     pseudoData$easting[i] = pseudoData$easting[i-1] + sample(1:200, 1);
     pseudoData$individual[i] = 1;
  }
  

  currentTime = startTimePosix;
  pseudoData = dateColumns(101, currentTime, pseudoData);
#  pseudoData$dateTime[101] = format(currentTime,format="%Y-%m-%d %I:%M%p");
  pseudoData$northing[101] = 210000;
  pseudoData$easting[101] = 660000;
  pseudoData$individual[101] = 2;
  
  for(i in 102:200)
  {
     currentTime = currentTime + 15*60;
      pseudoData = dateColumns(i, currentTime, pseudoData);
  #   pseudoData$dateTime[i] = format(currentTime,format="%Y-%m-%d %I:%M%p");
     pseudoData$northing[i] = pseudoData$northing[i-1] + sample(-100:100, 1);
     pseudoData$easting[i] = pseudoData$easting[i-1] + sample(-200:0, 1);
     pseudoData$individual[i] = 2;
  }
  
  currentTime = startTimePosix;
  pseudoData = dateColumns(201, currentTime, pseudoData);
#  pseudoData$dateTime[201] = format(currentTime,format="%Y-%m-%d %I:%M%p");
  pseudoData$northing[201] = 205000;
  pseudoData$easting[201] = 660000;
  pseudoData$individual[201] = 3;
  
  for(i in 202:300)
  {
     currentTime = currentTime + 15*60;
      pseudoData = dateColumns(i, currentTime, pseudoData);
   #  pseudoData$dateTime[i] = format(currentTime,format="%Y-%m-%d %I:%M%p");
     pseudoData$northing[i] = pseudoData$northing[i-1] + sample(-100:100, 1);
     pseudoData$easting[i] = pseudoData$easting[i-1] + sample(-200:0, 1);
     pseudoData$individual[i] = 3;
  }
    
  pseudoData2 = st_as_sf(pseudoData, 
                         coords=c("easting", "northing"), 
                         crs=3078);
  
  pseudoData3 = st_transform(pseudoData2, crs=4326)
    
  a=  as.data.frame(st_coordinates(pseudoData3));
  
  pseudoData4 = pseudoData3;
  pseudoData4$lat = a$X;
  pseudoData4$long = a$Y;
  pseudoData4$geometry = NULL;
  
  write.csv(pseudoData4, "data/pseudoData.csv", row.names = FALSE);
}
