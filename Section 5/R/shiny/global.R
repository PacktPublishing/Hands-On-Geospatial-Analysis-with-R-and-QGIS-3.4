## Preparing the environment ready for the Shiny application
library(shiny)
library(sf) 
library(leaflet) 
library(viridis) 
library(tidyverse)
library(forcats)

## reading in Vancouver census tract shapefile
vancouver <- st_read("spatial_files/vancouver.shp")

## creating a palette function to fill in map polygons (repeating section 3 material)
popn_bins <- c(0, 250, 500, 1000, 2000, Inf)
pal <- colorBin(viridis(n = 5), # using Viridis palette
                domain = vancouver$popn16, bins = popn_bins)
