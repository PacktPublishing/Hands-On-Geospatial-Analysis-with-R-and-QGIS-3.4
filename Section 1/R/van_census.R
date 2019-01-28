## Section 3, Geospatial Processing with Tidyverse and sf Package

## package installation
# install.packages(c("cancensus", "sf", "tidyverse", "leaflet", "viridis", "forcats"))

library(sf) # geospatial data processing
library(tidyverse) # data cleaning and analysis
library(leaflet) # interactive map
library(viridis) # colour palette

## Video 1, Data Query and Acquisition from an API #### 
## Exploring census data in the Vancouver area

library(cancensus) # exploring Canada census data

## setting up api
options(cancensus.api_key = "*******") # please input your API key obtained from https://censusmapper.ca/users/sign_up
options(cancensus.cache_path = "../cancensus/") # path to store your census data

## displaying available census variables
info <- list_census_vectors("CA16")

## obtaining Vancouver census tracts data for 2016 and 2011 population,
## population density per square km, Canadian citizens, 
## immigrant population - America, Europe, Africa, Asia, Oceania and others,
## non-immigrants, non-permanent residents, and aboriginal population
van_ct <- get_census(dataset = "CA16", regions = list(CMA = "59933"), level = "DA",
                     vectors = c("v_CA16_401", "v_CA16_402", "v_CA16_406", "v_CA16_3393", 
                                 "v_CA16_3459", "v_CA16_3495", "v_CA16_3549", "v_CA16_3579", 
                                 "v_CA16_3633", "v_CA16_3408", "v_CA16_3435", "v_CA16_3852"),
                     use_cache = FALSE, geo_format = "sf")


## renaming column names in the Vancouver census dataframe
van_ct <- van_ct %>% 
  plyr::rename(replace = c("Shape Area" = "shp_a", "Population" = "popn",
                           "Dwellings" = "dwlg", "Households" = "hshd",
                           "Region Name" = "region", "Area (sq km)" = "area",
                           "v_CA16_401: Population, 2016" = "popn16",
                           "v_CA16_402: Population, 2011" = "popn11",
                           "v_CA16_406: Population density per square kilometre" = "popn_d",
                           "v_CA16_3393: Canadian citizens" = "can",
                           "v_CA16_3459: Americas" = "amr", "v_CA16_3495: Europe" = "eu",
                           "v_CA16_3549: Africa" = "afr", "v_CA16_3579: Asia" = "asia",
                           "v_CA16_3633: Oceania and other places of birth" = "oc",
                           "v_CA16_3408: Non-immigrants" = "non_im",
                           "v_CA16_3435: Non-permanent residents" = "non_pr",
                           "v_CA16_3852: Total - Aboriginal identity for the population in private households - 25% sample data" = "ab"
                           ))

## taking a look at the new column names
names(van_ct)
View(van_ct)

## basic ploting function
plot(van_ct[9], main = "Greater Vancouver Census Tracts")

## only retain City of Vancouver area and University Endowment Lands
vancouver <- van_ct %>%
  filter(region == "Vancouver" | grepl("9330069.", CT_UID)) 

plot(vancouver)

st_write(van_ct, "../spatial_files/CA16-59933-DA.shp", delete_dsn = TRUE)


## Video 2, Tidy Data and Analysis with Tidyverse Library ####

## reading in Vancouver census tract shapefile
van <- st_read("../spatial_files/CA16-59933-DA.shp")

## examining the dataframe
head(van)

## data analysis in one run
df <- van %>% 
  filter(CT_UID == "9330010.01") %>%  
  select(CT_UID, region, popn16, can, amr, eu, afr, asia, oc, non_im, non_pr, geometry) %>% 
  gather(key = "origin", value = "count", -CT_UID, -region, -popn16, -geometry) 


## Video 3, Statistical Summaries and Graphic Outputs ####

library(forcats) # reorder factors

## reading in Vancouver census tract shapefile
van <- st_read("../spatial_files/CA16-59933-DA.shp")

## statistical summaries
van %>% 
  summary()

mean(van$popn16)
min(van$popn16)
max(van$popn16)
hist(van$popn16)

## taking a look at places of origin for residents
class(df$origin)
unique(df$origin)

## bar plot using previously analysed data in video 2 
ggplot(df, aes(fct_reorder(origin, count), count)) +
  geom_bar(stat = "identity") + # displays value instead of counting the rows
  labs(x = "Origin", y = "Population", title = "Regional demographics") +
  # coord_flip() +
  coord_polar() +
  theme_bw()

## hexagonal density plot for population against area per unit
van %>% 
  ggplot(aes(area, popn16)) +
  geom_hex() +
  labs(x = "Area in sq km", y = "Population", 
       title = "Metro Vancouver 2016 Population against Area") +
  scale_x_log10() +
  scale_fill_viridis_c(name = "Count") +
  theme_bw()


## Video 4, Making an Interactive Map with Leaflet Library ####

## reading in Vancouver census tract shapefile
van <- st_read("../spatial_files/CA16-59933-DA.shp")

## only retain City of Vancouver area and University Endowment Lands
vancouver <- van %>%
  filter(region == "Vancouver" | grepl("9330069.", CT_UID)) 

## creating a palette function to fill in map polygons
popn_bins <- c(0, 250, 500, 1000, 2000, Inf)
pal <- colorBin(viridis(n = 5), # using Viridis palette
                domain = vancouver$popn16, bins = popn_bins)

## if the map did not plot properly, try running the following code
## please note van_ct is obtained from video 1 
# names(van$geometry) <- names(van_ct$geometry)

popn_map <- leaflet(vancouver) %>% 
  addTiles() %>%
  addPolygons(
    fillColor = ~pal(popn16), 
    fillOpacity = 0.8,
    weight = 1.5, # boundary thickness
    color = "grey", # boundary colour
    label = paste("Region:", vancouver$region, "Population:", vancouver$popn16),
    highlightOptions = highlightOptions(color = "white", weight = 2, opacity = 1,
                                        bringToFront = TRUE) # highlight selected polygon
              ) %>% 
  addLegend(pal = pal, ~popn16, position = "bottomleft", opacity = 0.5,
            title = "Vancouver Population in 2016") 
  # addMarkers(lng = -122.85, lat = 49.27) %>%
  # addPopups(lng = -122.9, lat = 49.25, popup = paste("I am a PopUp"))
popn_map



## Video 5, Map Specifics, Markers, Legend and Scales ####

## reading in spatial data
parks <- st_read("../spatial_files/parks.shp")
bikeways <- st_read("../spatial_files/bikeways.shp")
van <- st_read("../spatial_files/van.shp")

## plotting map using ggplot2 library
bikemap <- ggplot() +
  geom_sf(data = van, aes(fill = "Vancouver Boundary")) +
  geom_sf(data = bikeways, aes(colour = "Bikeways"), show.legend = "line") +
  geom_sf(data = parks, aes(colour = "Parks"), show.legend = "point") +
  labs(title = "Vancouver Bikeway Map") +
  scale_fill_manual(values = c("Vancouver Boundary" = "darkseagreen3"),
                    guide = guide_legend(override.aes = list(
                      linetype = "blank", shape = NA)), name = NULL) +
  scale_colour_manual(values = c("Bikeways" = "grey30", "Parks" = "green"),
                      guide = guide_legend(override.aes = list(
                        linetype = c("solid", "blank"), shape = c(NA, 16))), name = NULL) +
  theme_light()
bikemap

ggsave("Van_Bikemap.png", bikemap, width = 8, height = 5)
