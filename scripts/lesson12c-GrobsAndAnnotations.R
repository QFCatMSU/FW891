{ 
  rm(list=ls());  options(show.error.locations = TRUE);
  source(file="scripts/spatial-header.R"); # moved all package info to header.r

  ### Read in plot save two lessons ago:
  plotInfo = readRDS(file="data/plot.RData");

  ### Get the llama image
  imgJPG = readJPEG("images/alpaca.jpg");   # from the jpeg package
  imgGrobJPG = rasterGrob(imgJPG, interpolate=TRUE);
  
  # Get Lake Michigan spatial data and save to an SF
  lakeMichigan = st_read(dsn="data/Lake_Michigan_shoreline.kml");
  lakeMI_SF = st_as_sf(lakeMichigan); 
  
  plot_LakeMI = ggplot() +
    geom_sf(data = lakeMI_SF,
        mapping = aes(geometry = geometry),
        color = "blue",
        fill = "lightgreen") +
    theme_void() +   # remove all plot features
    theme(panel.background=element_rect(color = "black", fill="transparent", 
                                        size=3));
  plot(plot_LakeMI);
  
  # Save plot as an image: (note: images folder must exist!)
  # Saving as both a JPG and PNG to show the difference...
  ggsave(filename="images/LakeMI.png", plot=plot_LakeMI, device=png);
  ggsave(filename="images/LakeMI.jpg", plot=plot_LakeMI, device=jpeg);

  # Read in the two images of Lake MI -- save to Environment
  LakeMI_PNG = readPNG("images/LakeMI.png");     # package: png
  LakeMI_JPG = readJPEG("images/LakeMI.jpg");    # package jpeg
 
  #### Plot coordinates (from previous lesson) 
  #     xlim = c(-3000000, 2000000),  
  #     ylim = c(3000000, 7000000),
  
  ### PNG allow for transparency
  ### Disadvantages:
  #   - does not maintain aspect ratio (yet...)
  #   - bounding box is needed
  #   - information can be lost when converting plots to images
  newPlot = plotInfo +
    annotation_raster(imgJPG,     # does not matter JPG vs PNG
                      xmin=-3000000, xmax=-2400000, 
                      ymin=6200000, ymax=7000000) +
    annotation_raster(LakeMI_PNG, # does matter -- image has transparency
                      xmin=1000000, xmax=2000000, 
                      ymin=6000000, ymax=7000000) +
    coord_sf(crs = 26917,  
             xlim = c(-3000000, 2000000),  
             ylim = c(3000000, 7000000),
             expand = TRUE);
  plot(newPlot);
  
  newPlot2 = plotInfo +
    annotation_raster(imgJPG,     # does not matter JPG vs PNG
                      xmin=-3000000, xmax=-2400000, 
                      ymin=6200000, ymax=7000000) +
    annotation_raster(LakeMI_JPG, # does matter -- image has transparency
                      xmin=1000000, xmax=2000000, 
                      ymin=6000000, ymax=7000000) +
    coord_sf(crs = 26917,  
             xlim = c(-3000000, 2000000),  
             ylim = c(3000000, 7000000),
             expand = TRUE);
  plot(newPlot2);
  
  # Application:
  # Recreate the two multipanelings from previous lesson using annotation_raster
}
