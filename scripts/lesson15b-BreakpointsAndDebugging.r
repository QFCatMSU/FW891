{
  rm(list=ls());  options(show.error.locations = TRUE);

  # Red dots: breakpoints that you set
  # Green arrow: in debug, it is the command you are about to execute
  # Debug controls:
  #    Next: go to next command
  #    Continue: go to next breakpoint (or end of script)
  #    Stop: force end the script
  #    Step Into: go to the function (if there is one) 
  #       - only "Steps" into functions that you have created (not packages)
  #    Step Out: completes the function you are in
  #       - Step Out acts like Continue if you are in the main script

  #### To do:
  #    1) Put breakpoint on line 24, demo Next, Continue, Stop
  #    2) Put breakpoint in for loops, demo Next, Continue, Stop, Step Into
  #    3) Put in both breakpoints, demo Continue, Step Out
  #    4) Demo breaking a for loop at a specific iteration?
  
  doThis = function(val)
  {
    val2 = val+3;
    val3 = val2^(1/4);
    return(val3);
  }
  
  vector1 = c(1:10);
  vector2 = c();  
  vector3 = c();  
  vector4 = c();
  
  for(i in 1:length(vector1))
  {
    vector2[i] = sqrt(vector1[i]);  
    vector3[i] = doThis(vector1[i]); # can step in to the function
    vector4[i] = vector1[i]^3;
  }

}
