## Section 5, Visualisation and Application Deployment

## package installation
# install.packages(c("shiny", "sf", "leaflet", "viridis", "tidyverse", "forcats", "rsconnect"))

library(shiny)
library(sf) 
library(leaflet) 
library(viridis) 
library(tidyverse)
library(forcats)

## Video 1, Shiny Server - the Basics #### 
## use runApp() function to run the Shiny application



## Video 2, Sharing the Map on Shiny ####

## reading in Vancouver census tract shapefile
vancouver <- st_read("../spatial_files/vancouver.shp")

## creating a palette function to fill in map polygons (repeating section 3 material)
popn_bins <- c(0, 250, 500, 1000, 2000, Inf)
pal <- colorBin(viridis(n = 5), # using Viridis palette
                domain = vancouver$popn16, bins = popn_bins)

## Paste the following code chunk to server.R
## using code from section 3, Cancensus interactive map but adding a layerID
output$popn_map <- renderLeaflet(
  leaflet(vancouver) %>% 
    addTiles() %>%
    addPolygons(layerId = ~GeoUID,
                fillColor = ~pal(popn16), fillOpacity = 0.8, weight = 1.5, color = "grey", 
                label = paste("Region:", vancouver$region, "Population:", vancouver$popn16),
                highlightOptions = highlightOptions(color = "white", weight = 2, opacity = 1,
                                                    bringToFront = TRUE)) %>% 
    addLegend(pal = pal, ~popn16, position = "bottomleft", opacity = 0.5,
              title = "Vancouver Population in 2016")
)

runApp("shiny/")

## Video 3, Reactive Values - Displaying Static Plots Upon Clicking on a Polygon ####

## need to map selection to either layer ID or lat + long.
output$plot_title <- renderUI({
  req(input$popn_map_shape_click$id)
  HTML(paste("<b>", "Demographics for GeoUID:",  "</b>", input$popn_map_shape_click$id, "</h4>"))
})

output$popn_plot <- renderPlot({
  req(input$popn_map_shape_click$id)
  vancouver %>% 
    filter(GeoUID %in% input$popn_map_shape_click$id) %>%  
    select(CT_UID, region, popn16, can, amr, eu, afr, asia, oc, non_im, non_pr, geometry) %>% 
    gather(key = "origin", value = "count", -CT_UID, -region, -popn16, -geometry) %>% 
    ggplot(mapping = aes(fct_reorder(origin, count), count)) +
    geom_bar(stat = "identity") + 
    labs(x = "Origin", y = "Population", title = "") +
    coord_flip() +
    theme_bw() +
    theme(text = element_text(size = 18))
})  

## Video 4, Deploying the Application and Share to Public ####

## first, prepare a global.R script in the shiny folder by pasting the following in it
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


## app-depolyment
library(rsconnect)

## create a free account on https://www.shinyapps.io and obtain the following information
setAccountInfo(name = "", token = "", secret = "")

## deploying or updating the application
deployApp("shiny/")


## Video 5, Advanced Customisations in Shiny ####

## adding awesome markers from the Ionicon library
awesome_icon <- awesomeIcons(icon = "tree", library = "fa", markerColor = "green", iconColor = "white")

runApp("/shiny")
