#!/usr/bin/env Rscript
rm(list=ls())
library(argparser, quietly=TRUE)
library(tidyverse, quietly=TRUE)
library(here, quietly = TRUE)
library(gmRi, quietly = TRUE)

dat_proc_occu_fn<- function(input_df, year_min, year_max,output_csv_path){
  
  # input_df = Cleaned data data frame
  #min year: 2010
  #max year: 2015
  # Returns: A processed data frame with species occurrence records 
  
  if(FALSE){
    input_df<- read.csv("C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N/example_data_clean.csv")
   #output_csv_path<- "C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N\\example_data_clean_aallyn.csv"
    year_min<- 2010
    year_max<- 2015
  }
  
  ## Start function
  
  dat_proc_temp<- input_df %>%
    dplyr::select(id, Year, Month, longitude, latitude, sci_name, numbers, PA, chl, distance, Ni, O2,Sal,SSH, SST,depth) %>%
    filter(longitude >= -20 & longitude <= -5) %>%
    filter(Month == "7" | Month == "8")
   
    
    # Apply year filters
    dat_proc_temp2<- dat_proc_temp %>%
    filter(., Year >= year_min & Year <= year_max)   
  
    dat_proc_occu_temp<- dat_proc_temp2 %>%
    mutate(numbers = ifelse(is.na(numbers) == TRUE & PA < 1,5, numbers)) %>%   
    filter(!is.na(numbers))
    
    dat_proc_occu<- dat_proc_occu_temp
  # Return and save it
   write.csv(dat_proc_occu, file = output_csv_path)
  return(dat_proc_occu)
}


proc_occu_csv<- function(input_csv_path, year_min, year_max, output_csv_path){
  
  # Read in data from csv
  input_df<- read.csv(input_csv_path)
  
  # Run clean
  proc_occu_df<- dat_proc_occu_fn(input_df, year_min, year_max)
  
  # Output
  write.csv(proc_occu_df, file = output_csv_path)
  
}

if(!interactive()){
  # Build up our command line argument parser
  parser<- arg_parser("Process cleaned NOAA NEFSC trawl data csv file")
  # Our first argument, the path to the input csv file
  parser<- add_argument(parser, "input_csv_path", help = "Input .csv file path")
  # Our second argument, the min year to keep
  parser<- add_argument(parser, "year_min", type = "numeric", help = "The minimum year to keep")
  # Our third argument, the max year to keep
  parser<- add_argument(parser, "year_max", type = "numeric", help = "The minimum year to keep")
  # Our fourth argument, the path to the out csv file
  parser<- add_argument(parser, "output_csv_path", help = "Output .csv file path")
  
  # Parse the arguments
  args<- parse_args(parser)
  print(args)
  
  # Process csv
  proc_occu_csv(args$input_csv_path, args$year_min, args$year_max, args$output_csv_path)
}