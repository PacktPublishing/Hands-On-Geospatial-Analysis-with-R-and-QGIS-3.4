## Section 2, Data Preparation and Basic Plotting
## Using the open datasets downloaded
## from https://data.vancouver.ca/datacatalogue/index.htm

## package installation
# install.packages(c("sf", "readr", "tidyr"))

library(sf) # geospatial data processing
library(readr)

## Video 2: Importing Data into R ####

## key shortcuts
# starting a fresh environment
# run a line of code
print("Hello World")

# run previous lines of script
# run the entire script
# arrow
a <- 1
# pipe
# save script

## work directory, relative paths, and tab
read.csv("../bikeways_shp/bikeways.shp")
## getting help, documentation and cheatsheets
?read.csv

## starting to import data
## extracting information from the dataframe

parks.df <- read.csv("../bikeways_shp/parks.csv")
parks_df <- read_csv("../bikeways_shp/parks.csv")
bikeways <- st_read("../bikeways_shp/bikeways.shp")

names(parks_df)
dim(parks_df)
class(parks_df)
summary(parks_df)
View(parks_df)

bikeways[1]
summary(bikeways$STREET_NAM)
bikeways[bikeways$STREET_NAM == "Cambie", ]

class(bikeways$UNIQUE_ID)
unique(bikeways$STREET_NAM)


## Video 3: Turning Tables into Spatial Data (R part) ####

library(tidyr)

parks_df <- read_csv("../bikeways_shp/parks.csv")

## separate lat and long coordinates into two columns
parks_df <- parks_df %>% 
  separate(GoogleMapDest, c("Latitude", "Longitude"), sep = ",", 
           convert = TRUE) # convert coordinates into numeric

write_csv(parks_df, "../bikeways_shp/parks_qgis.csv")

## converting csv to shapefile, noting WGS84 Coordinate Reference 
## System (CRS - lat, lon); coordinates must be in x y order
parks <- st_as_sf(parks_df, coords = c("Longitude", "Latitude"), 
                  crs = 4326) 


## Video 4: Basic Plotting and Visualisation ####

parks <- st_read("../bikeways_shp/parks.shp")
bikeways <- st_read("../bikeways_shp/bikeways.shp")
van <- st_read("../bikeways_shp/van.shp")

## plotting Vancouver boundary
plot(van)

## plotting bikeways, set the colour and line type (6), and edit the title
plot(st_geometry(bikeways), col = "grey30", lty = 6, main = "Vancouver Bikeways")

## extracting coordinate reference system (CRS) of bikeways and parks
st_crs(bikeways)
st_crs(parks)

## converting parks' CRS to UTM coordinates, consistent with bikeways shapfile
st_crs(parks) <- 26910 

## plotting parks on top of bikeways and set the point shape (21) and colour (green)
plot(st_geometry(parks), add = TRUE, pch = 21, col = "green")


## Video 5: Exporting Data ####
## continuing from video 4's project

## exporting a shapefile
st_write(parks, "parks.shp")

## exporting a graph
png(filename = "van_bikeways.png", width = 600, height = 300, units = "px")
plot(st_geometry(bikeways), col = "grey30", lty = 6, main = "Vancouver Bikeways")
plot(st_geometry(parks), add = TRUE, col = "green", pch = 21)
dev.off()
