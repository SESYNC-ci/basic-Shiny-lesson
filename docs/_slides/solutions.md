---
---

## Solutions

===

## Solution 1



~~~r
# Libraries
library(ggplot2)
library(dplyr)

# Data
species <- read.csv('data/species.csv', stringsAsFactors = FALSE)
animals <- read.csv('data/animals.csv', na.strings = '', stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput('pick_species',
                   label = 'Pick a species',
                   choices = unique(species[['id']]))
out1 <- textOutput('species_label')
out2 <- plotOutput('species_plot')
tab <- tabPanel(title = 'Species',
                in1, out1, out2)
ui <- navbarPage(title = 'Portal Project', tab)

server <- function(input, output) {
  output[['species_label']] <- renderText(
    species %>%
      filter(id == input[['pick_species']]) %>%
      select(genus, species) %>%
      paste(collapse = ' ')
  )
  output[['species_plot']] <- renderPlot(
    animals %>%
      filter(species_id == input[['pick_species']]) %>%
      ggplot(aes(year)) +
      geom_bar()
  )
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
~~~
{:.text-document .no-eval title="{{ site.handouts[2] }}"}


[Return](#exercise-1)
{:.notes}

===

## Solution 2



~~~r
# Libraries
library(ggplot2)
library(dplyr)

# Data
species <- read.csv('data/species.csv', stringsAsFactors = FALSE)
animals <- read.csv('data/animals.csv', na.strings = '', stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput('pick_species',
                   label = 'Pick a species',
                   choices = unique(species[['id']]))
side <- sidebarPanel('Options', in1)
out1 <- textOutput('species_label')
out2 <- tabPanel(title = 'Plot',
                 plotOutput('species_plot'))
out3 <- tabPanel(title = 'Data',
                 dataTableOutput('species_table'))                 
main <- mainPanel(out1,
                  tabsetPanel(out2, out3))
tab <- tabPanel(title = 'Species',
                sidebarLayout(side, main))
ui <- navbarPage(title = 'Portal Project', tab)

server <- function(input, output) {
  output[['species_label']] <- renderText(
    species %>%
      filter(id == input[['pick_species']]) %>%
      select(genus, species) %>%
      paste(collapse = ' ')
  )
  output[['species_plot']] <- renderPlot(
    animals %>%
      filter(species_id == input[['pick_species']]) %>%
      ggplot(aes(year)) +
      geom_bar()
  )
  output[['species_table']] <- renderDataTable(
    animals %>%
      filter(species_id == input[['pick_species']])
  )
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
~~~
{:.text-document .no-eval title="{{ site.handouts[2] }}"}


[Return](#exercise-2)
{:.notes}

===

## Solution 3



~~~r
# Libraries
library(ggplot2)
library(dplyr)

# Data
species <- read.csv('data/species.csv', stringsAsFactors = FALSE)
animals <- read.csv('data/animals.csv', na.strings = '', stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput('pick_species',
                   label = 'Pick a species',
                   choices = unique(species[['id']]))
img <- img(src = 'image-filename.png', alt = 'short image description')                   
side <- sidebarPanel(img, 'Options', in1)
out1 <- textOutput('species_label')
out2 <- tabPanel('Plot',
                 plotOutput('species_plot'))
out3 <- tabPanel('Data',
                 dataTableOutput('species_table'))                 
main <- mainPanel(out1,
                  tabsetPanel(out2, out3))
tab <- tabPanel(title = 'Species',
                sidebarLayout(side, main))
ui <- navbarPage(title = 'Portal Project', tab)

server <- function(input, output) {
  output[['species_label']] <- renderText(
    species %>%
      filter(id == input[['pick_species']]) %>%
      select(genus, species) %>%
      paste(collapse = ' ')
  )
  output[['species_plot']] <- renderPlot(
    animals %>%
      filter(species_id == input[['pick_species']]) %>%
      ggplot(aes(year)) +
      geom_bar()
  )
  output[['species_table']] <- renderDataTable(
    animals %>%
      filter(species_id == input[['pick_species']])
  )
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
~~~
{:.text-document .no-eval title="{{ site.handouts[2] }}"}


[Return](#exercise-3)
{:.notes}

===

## Solution 4



~~~r
# Libraries
library(ggplot2)
library(dplyr)

# Data
species <- read.csv('data/species.csv', stringsAsFactors = FALSE)
animals <- read.csv('data/animals.csv', na.strings = '', stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput('pick_species',
                   label = 'Pick a species',
                   choices = unique(species[['id']]))
in2 <- sliderInput('slider_months',
                   label = 'Month Range',
                   min = 1,
                   max = 12,
                   value = c(1, 12))
img <- img(src = 'image-filename.png', alt = 'short image description')
side <- sidebarPanel(img, 'Options', in1, in2)									    
out1 <- textOutput('species_label')
out2 <- tabPanel('Plot',
                 plotOutput('species_plot'))
out3 <- tabPanel('Data',
                 dataTableOutput('species_table'))                 
main <- mainPanel(out1,
                  tabsetPanel(out2, out3))
tab <- tabPanel(title = 'Species',
                sidebarLayout(side, main))
ui <- navbarPage(title = 'Portal Project', tab)

# Server
server <- function(input, output) {
  reactive_data_frame <- reactive({
    months <- seq(input[['slider_months']][1],
                  input[['slider_months']][2])
    animals %>%
      filter(species_id == input[['pick_species']]) %>%
      filter(month %in% months)
  })
  output[['species_label']] <- renderText(
    species %>%
      filter(id == input[['pick_species']]) %>%
      select(genus, species) %>%
      paste(collapse = ' ')
  )
  output[['species_plot']] <- renderPlot(
    ggplot(reactive_data_frame(), aes(year)) +
      geom_bar()
  )
  output[['species_table']] <- renderDataTable(reactive_data_frame())
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
~~~
{:.text-document .no-eval title="{{ site.handouts[3] }}"}


[Return](#exercise-4)
{:.notes}
