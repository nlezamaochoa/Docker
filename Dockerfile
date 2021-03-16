# Base image from rocker/geospatial, which includes tidyverse stuff and some other capacities
FROM rocker/geospatial:4.0.3


# Additions to base image
COPY ./clean_dat_n.r ./home/$USER/clean_dat_n.r


#make scripts executable
RUN chmod +x  /home/$USER/*.r