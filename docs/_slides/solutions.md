---
---

## Exercises

===

### Exercise 1

Modify the call to `renderText()`, used to create `output[['species_label']]`,
to produce a label with the genus and species, taken from the species table,
instead of just the species code. Hint: The function `paste()` with argument
`collapse = ' '` will convert a data frame row to a text string.

[View solution](#solution-1)
{:.notes}

===

### Exercise 2

Include a `tabsetPanel()` nested within the main panel. Title the first tab in
the tabset "Plot" and show the current plot. Title the second tab in the tabset
"Data" and show a `dataTableOutput()` of the data plotted in the first tab.

[View solution](#solution-2)
{:.notes}

===

### Exercise 3

Use the `img` builder function to add a logo, photo, or other image to your app.
The help under `?img` states that HTML attributes come from named arguments to
`img`, and the ["img" HTML tag](https://www.w3schools.com/tags/tag_img.asp)
requires two attributes. You'll need to save the image file in a subfolder
called "www".

[View solution](#solution-3)
{:.notes}

===

### Exercise 4

Notice the exact same code exists twice within the server function, once for
`renderPlot()` and once for `renderDataTable`. The server has no way to identify
an intermediate result, the filtered data frame, that it could reuse. Replace
`slider_months()` with a new `selection_animals()` function that returns the
needed `data.frame`. Bask in the knowledge of the CPU time saved, and
congratulate yourself for practicing DYR!

[View solution](#solution-4)
{:.notes}

===

## Solutions

===

### Solution 1



~~~r
# Libraries
library(ggplot2)
library(dplyr)

# Data
species <- read.csv('data/species.csv',
  stringsAsFactors = FALSE)
animals <- read.csv('data/animals.csv',
  na.strings = '',
  stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput(
  inputId = 'pick_species',
  label = 'Pick a species',
  choices = unique(species[['id']]))
out1 <- textOutput('species_label')
out2 <- plotOutput('species_plot')
tab <- tabPanel(
  title = 'Species',
  in1, out1, out2)
ui <- navbarPage(
  title = 'Portal Project',
  tab)

# Server
server <- function(input, output) {
  output[['species_label']] <- renderText({
    species %>%
      filter(id == input[['pick_species']]) %>%
      select(genus, species) %>%
      paste(collapse = ' ')
  })
  output[['species_plot']] <- renderPlot({
    df <- animals %>%
      filter(species_id == input[['pick_species']])
    ggplot(df, aes(year)) +
      geom_bar()
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
~~~
{:.text-document .no-eval title="{{ site.handouts[2] }}"}


[Return](#exercise-1)
{:.notes}

===

### Solution 2



~~~r
# Libraries
library(ggplot2)
library(dplyr)

# Data
species <- read.csv('data/species.csv',
  stringsAsFactors = FALSE)
animals <- read.csv('data/animals.csv',
  na.strings = '',
  stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput(
  inputId = 'pick_species',
  label = 'Pick a species',
  choices = unique(species[['id']]))
side <- sidebarPanel('Options', in1)
out1 <- textOutput('species_label')
out2 <- tabPanel(
  title = 'Plot',
  plotOutput('species_plot'))
out3 <- tabPanel(
  title = 'Data',
  dataTableOutput('species_table'))                 
main <- mainPanel(out1, tabsetPanel(out2, out3))
tab <- tabPanel(
  title = 'Species',
  sidebarLayout(side, main))
ui <- navbarPage(
  title = 'Portal Project',
  tab)

# Server
server <- function(input, output) {
  output[['species_label']] <- renderText({
    species %>%
      filter(id == input[['pick_species']]) %>%
      select(genus, species) %>%
      paste(collapse = ' ')
  })
  output[['species_plot']] <- renderPlot({
    df <- animals %>%
      filter(species_id == input[['pick_species']])
    ggplot(df, aes(year)) +
      geom_bar()
  })
  output[['species_table']] <- renderDataTable({
    animals %>%
      filter(species_id == input[['pick_species']])
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
~~~
{:.text-document .no-eval title="{{ site.handouts[2] }}"}


Notice the many features of the data table output. There are many options that
can be controlled within the render function such as pagination and default
length. See [here](http://shiny.rstudio.com/gallery/datatables-options.html) for
examples and how to extend this functionality using JavaScript.
{:.notes}

[Return](#exercise-2)
{:.notes}

===

### Solution 3



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

### Solution 4



~~~r
# Libraries
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
  label = 'Pick a species',
  choices = unique(species[['id']]))
in2 <- sliderInput(
  inputId = 'slider_months',
  label = 'Month Range',
  min = 1, max = 12,
  value = c(1, 12))
img <- img(src = 'image-filename.png',
  alt = 'short image description')
side <- sidebarPanel(
  img, 'Options', in1, in2)									    
out1 <- textOutput('species_label')
out2 <- tabPanel(
  title = 'Plot',
  plotOutput('species_plot'))
out3 <- tabPanel(
  title = 'Data',
  dataTableOutput('species_table'))                 
main <- mainPanel(out1, tabsetPanel(out2, out3))
tab1 <- tabPanel(
  title = 'Species',
  sidebarLayout(side, main))
ui <- navbarPage(
  title = 'Portal Project',
  tab1)

# Server
server <- function(input, output) {
  selected_animals <- reactive({
    animals %>%
      filter(species_id == input[['pick_species']]) %>%
      filter(
        month >= input[['slider_months']][1],
        month <= input[['slider_months']][2])
  })
  output[['species_label']] <- renderText({
    species %>%
      filter(id == input[['pick_species']]) %>%
      select(genus, species) %>%
      paste(collapse = ' ')
  })
  output[['species_plot']] <- renderPlot({
    ggplot(selected_animals(), aes(year)) +
      geom_bar()
  })
  output[['species_table']] <- renderDataTable({
    selected_animals()
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
~~~
{:.text-document .no-eval title="{{ site.handouts[3] }}"}


[Return](#exercise-4)
{:.notes}
