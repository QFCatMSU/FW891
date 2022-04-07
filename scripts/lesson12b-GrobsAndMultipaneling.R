{ 
  rm(list=ls());  options(show.error.locations = TRUE);
  source(file="scripts/spatial-header.R"); # moved all package info to header.r

  ### Read in plot saved in last lesson -- puts the plot in the Environment
  plotInfo = readRDS(file="data/plot.RData");
  plot(plotInfo);  # same info but name has changed

  ### Let's get an images... and convert it to Grobs
  imgJPG = readJPEG("images/alpaca.jpg");   # from the jpeg package
  imgGrobJPG = rasterGrob(imgJPG);
  
  # The above variables are raster data -- they are large!

  # Get Lake Michigan spatial data and save to an SF
  lakeMichigan = st_read(dsn="data/Lake_Michigan_shoreline.kml");
  lakeMI_SF = st_as_sf(lakeMichigan); 

  # A quick plot of Lake Michigan 
  plot_LakeMI = ggplot() +
    geom_sf(data = lakeMI_SF,
        mapping = aes(geometry = geometry),
        color = "blue",
        fill = "lightgreen") +
    theme_void() +   # remove all plot features
    theme(panel.background=element_rect(color = "black", fill="transparent", 
                                        size=3));
  plot(plot_LakeMI);
  
 
  ## multipaneling has to be done using grids
  #  https://cran.r-project.org/web/packages/gridExtra/vignettes/arrangeGrob.html
  
  ### Advantages:
  #   - maintains aspect ratio
  #   - bounding box not needed
  
  # The layout for the multipanel
  matrixLayout = matrix(nrow=4, ncol=3, 
                        byrow=TRUE,   # how the matrix is laid out
                        # this should visually match nrow and ncol!
                        data = c(1,   2,  3, 
                                 NA, NA, NA,
                                 NA, NA, NA,
                                 NA, NA,  1));
  
  #### Grobs and Multipaneling (mention ... argument)
  multi1=arrangeGrob(plotInfo, plot_LakeMI, imgGrobJPG,  # 1, 2, 3
                     top = textGrob(label = "Llamas",
                                    gp=gpar(fontsize=25,# (G)raphical (P)arameters
                                            col="blue")), 
                     right="Alpaca",
                     layout_matrix = matrixLayout);
  plot(multi1); 
  
  # Application
  # 1) Redo multi1 so that the picture of the llama and the Lake Michigan plot 
  #    are to the right of the main plot.
  #    Make sure nothing overlaps (i.e., you can see everything)
  # 2) Create a SF of Lake Michigan that has only the outline of the lake
  #     - make the background color of Lake Michigan transparent
  # 3) Create a rasterGrob of your own image
  # 4) Create a second multipaneling that uses the US map
  #   - put the transparent Lake Michigan in the bottom-right corner  
  #   - set up the paneling so that your four image corners touches these four states:
  #       Idaho, Minnesota, Arizona, and Arkansas 
  #   - note: you will need to change the nrow/ncol of the matrixLayout
  
}
