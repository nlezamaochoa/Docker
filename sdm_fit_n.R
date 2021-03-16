
#!/usr/bin/env Rscript
rm(list=ls())
library(argparser, quietly=TRUE)
library(tidyverse, quietly=TRUE)
library(here, quietly = TRUE)
library(gmRi, quietly = TRUE)
library(mgcv)

setwd("C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N/")

sdm_fit_fn<- function(input_df, mod_formula,output_mod){
  
  # This function brings in the processed Nerea's data as a data frame and then fits a simple linear model, which is returned and saved to output_mod_path.
  
  # Args:
  # input_df = Processed bycatch data
  # mod_formula = Model formula
  
  # Returns: A fitted linear model object
  # For debugging/walking through the function
  if(FALSE){
    input_df<- read.csv("C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N/example_data_clean.csv")
    mod_formula<- formula(PA ~ chl)
    output_mod<- "C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N/example_lmfit.rds"
  }

  mod_fit<- gam(mod_formula, data = input_df)
  
  # Return
  saveRDS(mod_fit, file = output_mod)
  return(mod_fit)
}

sdm_fit_rds<- function(input_csv_path,  mod_formula, output_rds_path){
  
  # Read in data from csv
  input_df<- read.csv(input_csv_path)
  
  # Run model fitting
  sdm_fit<- sdm_fit_fn(input_df, mod_formula)
  
  # Output
  saveRDS(sdm_fit, file = output_rds_path)
}


#source("C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N/sdm_fit_fn.R")

  # Build up our command line argument parser
  parser<- arg_parser("Fit SDM to occurrence data")
  # Our first argument, the path to the input csv file
  parser<- add_argument(parser, "input_csv_path", type = "character",help = "Input .csv file path")
  # Our second argument, the model formula
  parser<- add_argument(parser, "mod_formula",type = "character", help = "The model formula")
  # Our third argument, the output rds path
  parser<- add_argument(parser, "output_mod", help = "The output rds path")

  
  if(interactive()){
    # Default args for ArgumentParser()$parse_args are commandArgs(TRUE), which is what we want if we are running the code through the terminal (e.g., non-interactively). But, if running interactively, we don't want that.
    # Getting path with gmRi shared path function. I haven't figured out a great way to do deal with this inside and outside of the container...
    if(Sys.info()[["user"]] == "rstudio"){
      box_data<- "~/box_data/"
    } else {
      box_data<- shared.path(os.use = "unix", group = "Mills Lab", folder = "Projects/NASA_UNSDG19/Data/")
    }
  
  
  
  
  
  
  if(interactive()){
    # Default args for ArgumentParser()$parse_args are commandArgs(TRUE), which is what we want if we are running the code through the terminal (e.g., non-interactively). But, if running interactively, we don't want that. 
    args<- parse_args(parser, PA ~ chl, c("C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N\\example.csv", "C:\\Users\\nereo\\Documents\\NOAA\\PROJECTS & COLLABORATIONS\\PROJECTS\\FACET\\Docker\\Functions\\example_N\\example_data_clean66.csv"))
  } else {
    # Parse the arguments
    args<- parse_args(parser)
    print(args)
  }
  
  


  # Fit and save sdm
  dat<- read.csv(args$input_csv_path)
  dat_model=  sdm_fit_rds(input_df = dat, mod_formula = args$mod_formula, output_mod = args$output_mod)

  #dat_mod_occu<- dat_mod_occu_fn(input_df = dat, mod_formula = args$mod_formula, output_mod = args$output_mod)