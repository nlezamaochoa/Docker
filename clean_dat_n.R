#!/usr/bin/env Rscript
rm(list=ls())
library(argparser, quietly=TRUE)
library(tidyverse, quietly=TRUE)
library(here, quietly = TRUE)
library(gmRi, quietly = TRUE)


dat_clean_fn<- function(input_df){
  # For debugging/walking through the function
  if(FALSE){
    input_df<- read.csv("C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N\\example.csv")
#output_csv_path<- "C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N\\example_data_clean_aallyn.csv"
  } 
  # Cleaning -- biomass/abundance issues
  dat_clean<- input_df %>%
    dplyr::select(id, Year, Month, longitude, latitude, sci_name, numbers, PA, chl, distance, Ni, O2,Sal,SSH, SST,depth) %>%
    filter(longitude >= -20 & longitude <= -5) %>%
    filter(Month == "7" | Month == "8") %>%
    filter(Year >= 2010 & Year <= 2015) %>%
    mutate(numbers = ifelse(is.na(numbers) == TRUE & PA < 1,5, numbers)) %>%   
    filter(!is.na(numbers))
  
  # Return and save it
 # write.csv(dat_clean, file = output_csv_path)
  return(dat_clean)
}

clean_csv<- function(input_csv_path, output_csv_path){
  
  # Read in data from csv
  input_df<- read.csv(input_csv_path)
  
  # Run clean
  clean_df<- dat_clean_fn(input_df)
  
  # Output
  write.csv(clean_df, file = output_csv_path)
  
}



  # Build up our command line argument parser
  parser<- arg_parser("Clean raw NOAA NEFSC trawl data")
  # Our first argument, the path to the input csv file
  parser<- add_argument(parser, "input_csv_path", help = "Input .csv file path")
  # Our second argument, the path to the out csv file
  parser<- add_argument(parser, "output_csv_path", help = "Output .csv file path")
  
  if(interactive()){
    # Default args for ArgumentParser()$parse_args are commandArgs(TRUE), which is what we want if we are running the code through the terminal (e.g., non-interactively). But, if running interactively, we don't want that. 
    args<- parse_args(parser, c("C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N\\example.csv", "C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N\\example_data_clean_aallyn.csv"))
  } else {
    # Parse the arguments
    args<- parse_args(parser)
    print(args)
  }
  
  # Clean csv
  
  dat<- read.csv(args$input_csv_path)
  dat_clean<- clean_csv(args$input_csv_path, args$output_csv_path)
  
  

