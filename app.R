library(shiny)
library(leaflet)
# Read in data
plots <- read.csv("data/plots.csv", stringsAsFactors = FALSE)

species <- read.csv("data/species.csv", stringsAsFactors = FALSE)

surveys <- read.csv("data/surveys.csv", na.strings = "", 
                    stringsAsFactors = FALSE)
# User interface
ui <- navbarPage(title = "Hello Shiny!",
                 tabPanel(title = "Plot",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("pick_species", label = "Pick a species", 
                                          choices = unique(species$species_id)),
                              sliderInput("slider_months", label = "Month range",
                                          min = 1, max = 12, value = c(1,12)),
                              downloadButton("download_data", label = "Download")
                            ),
                            mainPanel(plotOutput("species_plot")))
                          ),
                 tabPanel(title = "Data",
                          dataTableOutput("surveys_subset")),
                 tabPanel(title = "Map", leafletOutput("sesync_map")))

# Server
server <- function(input, output){
  
  surveys_subset <- reactive({
    surveys_subset <- subset(surveys, surveys$species_id == input$pick_species &
                               surveys$month %in%
                               input$slider_months[1]:input$slider_months[2])
    return(surveys_subset)
  })
  
  output$species_plot <- renderPlot({
    species_name <- paste(species[species$species_id==input$pick_species,"genus"],
                          species[species$species_id==input$pick_species,"species"])
    barplot(table(surveys_subset()$year), main = paste("Observations of", species_name, "per year"))
  })
  
  output$surveys_subset <- renderDataTable({
    surveys_subset()
  })
  
  output$download_data <- downloadHandler(
    filename = "portals_subset.csv",
    content = function(file) {
      write.csv(surveys_subset(), file)
    }
  )
  
  output$sesync_map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(lng = -76.505206, lat = 38.9767231, popup = "SESYNC")
  })
}

# Run app
shinyApp(ui = ui, server = server)