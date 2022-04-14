{ 
  rm(list=ls());  options(show.error.locations = TRUE);

  # Timezones -- 4 ways of setting
  # 1) Do nothing 
  # 2) Set to system timezone
  # 3) Explicitly set (with a list of all possible timezones)
  # 4) Switch timezone 
  
  # The first two are not recommended if you actually need to specify a timezone!
  
  pseudoData = read.csv("data/pseudoData.csv");
  
  ## Possibilities for timezones
  # put nothing in the timezone will default to "", which is equivalent to 
  # the current system's timezone
  stnDateTime1 = as.POSIXct(pseudoData$dateTime1,
                           format="%Y-%m-%d %I:%M%p");

  tz1 = attr(stnDateTime1, "tzone");  # ""

  # Force the time zone to be your computers timezone (Sys.timezone)
  stnDateTime2 = as.POSIXct(pseudoData$dateTime1,
                           format="%Y-%m-%d %I:%M%p",
                           tz = Sys.timezone());

  tz2 = attr(stnDateTime2, "tzone");  # for me (in Michigan), this is America/New York
  
  # Choose a timezone from here:
  # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  # Use the TZ database name column -- the abbreviation do not work
  stnDateTime3 = as.POSIXct(pseudoData$dateTime1,
                           format="%Y-%m-%d %I:%M%p",
                           tz = "America/Vancouver");

  tz3 = attr(stnDateTime3, "tzone");  # America/Vancouver
  
  ### Note: the timezones should automatically adjust for daylight savings time.
  #   because DST information is part of the timezone.  However, I have yet to
  #   test this out (generate data that occurs during the transition to/from DST
  #   and see if it is handled correctly).   

  ### Make a copy:
  stnDateTime4 = stnDateTime3;
  
  # You can later use attr() to change the timezone   
  attr(stnDateTime4, "tzone") = "Australia/Melbourne";
  tz4 = attr(stnDateTime4, "tzone");  # Australia/Melbourne
  
  # Note how the timezone is represented when posixct are printed to Console
  print(stnDateTime1[1:10]);
  print(stnDateTime2[1:10]);
  print(stnDateTime3[1:10]);
  print(stnDateTime4[1:10]);
  
  # But, if you cat() the posixct to the Console then you just get epoch time.
  # This shows how posixct is really just epoch time that can be converted
  # to any time zone and formatted to your liking
  cat(stnDateTime1[1:10]);
  cat(stnDateTime2[1:10]);
  cat(stnDateTime3[1:10]);
  cat(stnDateTime4[1:10]);
  
  ### Setting a timezone will not change the time values
  #   but changing the timezone will change the time values.
  #   Notice that stnDateTime4 has different times -- it has 
  #   adjusted from Vancouver time to Melbourne time.  Both 
  #   still have the same epoch time.

 
  ## Questions:
  # 1) Does not setting a timezone mean the same code mean that the
  #    DateTime object will produce different results on different computers
  #    in different timezones
  # 2) How does posixct adjust for values that cross between timezones
}
