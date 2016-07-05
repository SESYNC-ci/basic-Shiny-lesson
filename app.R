
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
                              downloadButton("download_data", label = "Download")
                            ),
                            mainPanel(plotOutput("species_plot")))
                          ),
                 tabPanel(title = "Data",
                          dataTableOutput("surveys_subset")))

# Server
server <- function(input, output){
  
  surveys_subset <- reactive({
    surveys_subset <- subset(surveys, surveys$species_id == input$pick_species)
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
}

# Run app
shinyApp(ui = ui, server = server)