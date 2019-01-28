## Shiny server ##

server <- function(input, output) {
  
  ## create an object called caption that shows the text:
  ## "My First Shiny Application" on the page
  output$caption <- renderUI({
    HTML("My First Shiny Application")
  })

  output$popn_map <- renderLeaflet(
    leaflet(vancouver) %>% 
      addTiles(group = "Default") %>%
      addProviderTiles("CartoDB.Positron", group = "Minimal") %>%
      addLayersControl(baseGroups = c("Default", "Minimal"), options = layersControlOptions(collapsed = FALSE)) %>%
      addAwesomeMarkers(lng = -123.15, lat = 49.3, icon = awesome_icon, label = "Stanley Park") %>%
      addPolygons(layerId = ~GeoUID, # add layerID
                  fillColor = ~pal(popn16), fillOpacity = 0.8, weight = 1.5, color = "grey", 
                  label = paste("Region:", vancouver$region, "Population:", vancouver$popn16),
                  highlightOptions = highlightOptions(color = "white", weight = 2, opacity = 1,
                                                      bringToFront = TRUE)) %>% 
      addLegend(pal = pal, ~popn16, position = "bottomleft", opacity = 0.5,
                title = "Vancouver Population in 2016") 
  )
  
  output$plot_title <- renderUI({
    req(input$popn_map_shape_click$id) # improves user experience
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
}