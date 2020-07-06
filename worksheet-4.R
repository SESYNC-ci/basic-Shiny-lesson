# Packages
library(dplyr)
library(ggplot2)

# Data
popdata <- read.csv('data/citypopdata.csv')

# User Interface
in1 <- selectInput(
  inputId = 'selected_city',
  label = 'Select a city',
  choices = unique(popdata[['NAME']])
)
in2 <- ...(
  ... = 'slider_months',
  ...,
  ...,
  ...,
  ...)
side <- sidebarPanel('Options', in1, ...)
out1 <- textOutput('city_label')
out2 <- plotOutput('species_plot')
...
main <- mainPanel(out1, out2, ...)
tab <- tabPanel(
  title = 'City Population',
  sidebarLayout(side, main))
ui <- navbarPage(
  title = 'Census Population Explorer',
  tab)

# Server
server <- function(input, output) {

  slider_months <- reactive({
    ...
    ...
  })
  
  output[['city_label']] <- renderText({
    input[['selected_city']]
  })
  
  output[['city_plot']] <- renderPlot({
    df <- popdata %>% 
      dplyr::filter(NAME == input[['selected_city']])
    ggplot(df, aes(x = year, y = population)) + 
      geom_line() + 
      coord_cartesian(xlim = c(input$my_xlims[1], input$my_xlims[2]))
  })
  
  output[['city_table']] <- renderDataTable({
    df <- popdata %>% 
      dplyr::filter(NAME == input[['selected_city']]) %>%
      filter(year %in% slider_months())
    df
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
