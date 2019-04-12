# Packages
library(dplyr)
library(ggplot2)

# Data
species <- read.csv('data/species.csv',
  stringsAsFactors = FALSE)
animals <- read.csv('data/animals.csv',
  na.strings = '',
  stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput(
  inputId = 'pick_species',
  label = 'Pick a Species',
  choices = unique(species[['id']]))
in2 <- ...(
  ... = 'slider_months',
  ...,
  ...,
  ...,
  ...)
side <- sidebarPanel('Options', in1, ...)
out1 <- textOutput('species_label')
out2 <- plotOutput('species_plot')
...
main <- mainPanel(out1, out2, ...)
tab <- tabPanel(
  title = 'Species',
  sidebarLayout(side, main))
ui <- navbarPage(
  title = 'Portal Project',
  tab)

# Server
server <- function(input, output) {

  slider_months <- reactive({
    ...
    ...
  })
  
  output[['species_label']] <- renderText({
    input[['pick_species']]
  })
  output[['species_plot']] <- renderPlot({
    df <- animals %>%
      filter(id == input[['pick_species']]) %>%
      filter(month %in% ...)
    ggplot(df, aes(year)) +
      geom_bar()
  })
  output[['species_table']] <- renderDataTable({
    df <- animals %>%
      filter(species_id == input[['pick_species']]) %>%
      filter(month %in% slider_months())
    df
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
