{ 
  rm(list=ls());  options(show.error.locations = TRUE);
  
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
  since1970 = format(timeStamp_POSIXct, format = "%s") 

  # https://stat.ethz.ch/R-manual/R-devel/library/base/html/strptime.html
}
