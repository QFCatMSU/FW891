theme_ugly = function()
{
  ## Create an object and include everything from theme_bw()
  newTheme = theme_bw() +     

  ## then modify theme_bw() with the seven subcomponents below
    theme(panel.background = element_rect(fill="grey25",
                                          linewidth=2, color="grey0"),
          panel.grid.minor = element_line(color="grey50", linetype=4),
          panel.grid.major = element_line(color="grey100"),
          plot.background = element_rect(fill = "lightgreen"),
          plot.title = element_text(hjust = 0.45),
          plot.subtitle = element_text(hjust = 0.42),
          axis.text = element_text(color="blue", family="mono", size=9));
  
  ### return newTheme to the caller
  ##  You could take this line out -- but it is bad programming practice...
  return(newTheme);
}

### Could also use this... but best to go the function route
#   if you are eventually going to turn this into a package
ugly =  theme_bw() + 
        theme(panel.background = element_rect(fill="grey25",
                                              linewidth=2, color="grey0"),
        panel.grid.minor = element_line(color="grey50", linetype=4),
        panel.grid.major = element_line(color="grey100"),
        plot.background = element_rect(fill = "lightgreen"),
        plot.title = element_text(hjust = 0.45),
        plot.subtitle = element_text(hjust = 0.42),
        axis.text = element_text(color="blue", family="mono", size=9));


### Including geom defaults in this function
theme_uglyAdv = function() 
{
  ## These are session variables -- like the working directory
  update_geom_defaults("line", list(color = "yellow"));
  update_geom_defaults("point", list(color = "green"));
  update_geom_defaults("smooth", list(color = "red",
                                      linetype=4,
                                      linewidth=2,
                                      fill="lightblue"));
  
  # Detach and reattach ggplot2 -- this is a hack!
  detach("package:ggplot2", unload = TRUE);  # remove package ggplot from sessio
  library(package="ggplot2");                # reload ggplot package
  
  newTheme = theme_bw() + 
    theme(panel.background = element_rect(fill="grey25",
                                          linewidth=2, color="grey0"),
          panel.grid.minor = element_line(color="grey50", linetype=4),
          panel.grid.major = element_line(color="grey100"),
          plot.background = element_rect(fill = "lightgreen"),
          plot.title = element_text(hjust = 0.45),
          plot.subtitle = element_text(hjust = 0.42),
          axis.text = element_text(color="blue", family="mono", size=9));
  
  return(newTheme);
}

theme_uglyAdv_noDetach = function() 
{
  ## These are session variables -- like working directory
  update_geom_defaults("line", list(color = c("firebrick", "purple")));
  update_geom_defaults("point", list(color = "green"));
  update_geom_defaults("smooth", list(color = "red",
                                      linetype=4,
                                      linewidth=2,
                                      fill="lightgreen"));
  
  # Detach and reattach ggplot2 -- this is a hack!
  # detach("package:ggplot2", unload = TRUE); library(ggplot2);
  
  newTheme = theme_bw() + 
    theme(panel.background = element_rect(fill="grey25",
                                          linewidth=2, color="grey0"),
          panel.grid.minor = element_line(color="grey50", linetype=4),
          panel.grid.major = element_line(color="grey100"),
          plot.background = element_rect(fill = "lightgreen"),
          plot.title = element_text(hjust = 0.45),
          plot.subtitle = element_text(hjust = 0.42),
          axis.text = element_text(color="blue", family="mono", size=9));
  
  return(newTheme);
}