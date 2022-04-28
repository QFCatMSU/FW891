{
  rm(list=ls());  options(show.error.locations = TRUE);

  ## Getting weather data from NOAA/NCDC
  library(rnoaa);

  lansingWeather = ncdc(datasetid="GHCND",
               datatypeid=c("TMAX", "TAVG", "TMIN", "PRCP",
                            "SNOW", "AWND", "WDF2", "WSF2",
                            "WT01", "WT09"),
               stationid="GHCND:USW00014836",
               startdate = "2016-02-01", enddate ="2016-02-29",
               token="LfoeHFkVUMLcokHXGCTTjukJteFEcvvM",
               limit=400  );
  lansingWeatherDF = lansingWeather[["data"]];
  write.csv(x=lansingWeatherDF, file="data/LansingWeatherFeb2016.csv");

  feb = read.csv("data/LansingWeatherFeb2016.csv");

}