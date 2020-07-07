---
---

## Exercises

===

### Exercise 1

Starting from {{ site.data.lesson.handouts[1] }}, modify the call to `renderText()` to
create an `output[['city_label']]` with both the city name and its statistical area description. You can find those data in the "LSAD" column of popdata. Hint: The
function `paste()` with argument `collapse = ' '` will convert a data frame row
to a text string. 

[View solution](#solution-1)
{:.notes}

===

### Exercise 2

Modify the app completed in {{ site.data.lesson.handouts[2] }} to include a `tabsetPanel()`
nested within the main panel. Title the first tab in the tabset "Plot" and show
the current plot. Title the second tab in the tabset "Data" and show a
`dataTableOutput()`, which you can borrow from the app completed in {{
site.data.lesson.handouts[3] }}.

[View solution](#solution-2)
{:.notes}

===

### Exercise 3

Use the `img` builder function to add a logo, photo, or other image to your app
in {{ site.handoouts[2] }}. The help under `?img` states that HTML attributes
come from named arguments to `img`, and the ["img" HTML
tag](https://www.w3schools.com/tags/tag_img.asp) requires two attributes, and
you'll probably also want to set a valide `width`. Hint: Use the `www/images`
folder mentioned in the `addResourcesPath()` function at the bottom of {{
dite.handouts[2] }}.

[View solution](#solution-3)
{:.notes}

===

### Exercise 4

Notice the exact same code exists twice within the server function of the app
you completed in {{ site.data.lesson.handouts[3] }}: once for `renderPlot()` and once for
`renderDataTable`. The server has no way to identify an intermediate result, the
filtered data frame, which it could have reused. Replace `slider_years()` with
a new `selection_years()` function that returns the entire `data.frame` needed
by both outputs. Bask in the knowledge of the CPU time saved, and congratulate
yourself for practicing DYR!

[View solution](#solution-4)
{:.notes}

===

## Solutions

===

### Solution 1



~~~r
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
out1 <- textOutput('city_label')
out2 <- plotOutput('city_plot')
tab <- tabPanel(
  title = 'City Population',
  in1, out1, out2)
ui <- navbarPage(
  title = 'Census Population Explorer',
  tab)

# Server
server <- function(input, output) {
  output[['city_label']] <- renderText({
    popdata %>% filter(NAME == input[['selected_city']]) %>%
    slice(1) %>% 
    dplyr::select(NAME, LSAD) %>%
    paste(collapse = ' ')
  })
  output[['city_plot']] <- renderPlot({
    df <- popdata %>% 
      dplyr::filter(NAME == input[['selected_city']])
     ggplot(df, aes(x = year, y = population)) + 
      geom_line() 
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
~~~
{:title="{{ site.data.lesson.handouts[1] }}" .no-eval .text-document}


[Return](#exercise-1)
{:.notes}

===

### Solution 2



~~~r
# Packages
library(dplyr)
library(ggplot2)

# Data
popdata <- read.csv('citypopdata.csv')

# User Interface
in1 <- selectInput(
  inputId = 'selected_city',
  label = 'Select a city',
  choices = unique(popdata[['NAME']]))
side <- sidebarPanel('Options', in1)
out1 <- textOutput('city_label')
out2 <- tabPanel(
  title = 'Plot',
  plotOutput('city_plot'))
out3 <- tabPanel(
  title = 'Data',
  dataTableOutput('city_table'))                 
main <- mainPanel(out1, tabsetPanel(out2, out3))
tab <- tabPanel(
  title = 'City Population',
  sidebarLayout(side, main))
ui <- navbarPage(
  title = 'Census Population Explorer',
  tab)

# Server
server <- function(input, output) {
  output[['city_label']] <- renderText({
    popdata %>% filter(NAME == input[['selected_city']]) %>%
    slice(1) %>% 
    dplyr::select(NAME, LSAD) %>%
    paste(collapse = ' ')
  })
  output[['city_plot']] <- renderPlot({
    df <- popdata %>% 
      dplyr::filter(NAME == input[['selected_city']])
     ggplot(df, aes(x = year, y = population)) + 
      geom_line() 
  })
  output[['city_table']] <- renderDataTable({
    popdata %>%
      dplyr::filter(NAME == input[['selected_city']])
  })
}

# Create the Shiny App
addResourcePath('images', 'www/images')
shinyApp(ui = ui, server = server)
~~~
{:title="{{ site.data.lesson.handouts[2] }}" .no-eval .text-document}


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
# Packages
library(dplyr)
library(ggplot2)

# Data
popdata <- read.csv('data/citypopdata.csv')

# User Interface
in1 <- selectInput(
  inputId = 'selected_city',
  label = 'Select a city',
  choices = unique(popdata[['NAME']]))
img <- img(
  src = 'images/outreach.jpg',
  alt = 'Census outreach flyer',
  width = '100%')
side <- sidebarPanel('Options', img, in1)
out1 <- textOutput('city_label')
out2 <- tabPanel(
  title = 'Plot',
  plotOutput('city_plot'))
out3 <- tabPanel(
  title = 'Data',
  dataTableOutput('city_table'))                 
main <- mainPanel(out1, tabsetPanel(out2, out3))
tab <- tabPanel(
  title = 'City Population',
  sidebarLayout(side, main))
ui <- navbarPage(
  title = 'Census Population Explorer',
  tab)

# Server
server <- function(input, output) {
  output[['city_label']] <- renderText({
    popdata %>% filter(NAME == input[['selected_city']]) %>%
      slice(1) %>% 
      dplyr::select(NAME, LSAD) %>%
      paste(collapse = ' ')
  })
  output[['city_plot']] <- renderPlot({
    df <- popdata %>% 
      dplyr::filter(NAME == input[['selected_city']])
    ggplot(df, aes(x = year, y = population)) + 
      geom_line() 
  })
  output[['city_table']] <- renderDataTable({
    popdata %>%
      dplyr::filter(NAME == input[['selected_city']])
  })
}

# Create the Shiny App
addResourcePath('images', 'www/images')
shinyApp(ui = ui, server = server)
~~~
{:title="{{ site.data.lesson.handouts[2] }}" .no-eval .text-document}


[Return](#exercise-3)
{:.notes}

===

### Solution 4



~~~r
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
in2 <- sliderInput(
  "my_xlims", 
  label = "Set X axis limits",
  min = 2010, 
  max = 2018,
  value = c(2010, 2018))
side <- sidebarPanel('Options', in1, in2)									    
out1 <- textOutput('city_label')
out2 <- tabPanel(
  title = 'Plot',
  plotOutput('city_plot'))
out3 <- tabPanel(
  title = 'Data',
  dataTableOutput('city_table'))                 
main <- mainPanel(out1, tabsetPanel(out2, out3))
tab1 <- tabPanel(
  title = 'City Population',
  sidebarLayout(side, main))
ui <- navbarPage(
  title = 'Census Population Explorer',
  tab1)

# Server
server <- function(input, output) {
  selected_years <- reactive({
    popdata %>%
      filter(NAME == input[['NAME']]) %>%
      filter(
        year >= input[['slider_years']][1],
        year <= input[['slider_years']][2])
  })
  output[['city_label']] <- renderText({
    popdata %>% 
      filter(NAME == input[['selected_city']]) %>%
      slice(1) %>% 
      dplyr::select(NAME, LSAD) %>%
      paste(collapse = ' ')
  })
  output[['city_plot']] <- renderPlot({
   ggplot(selected_years(), aes(x = year, y = population)) + 
      geom_line() 
  })
  output[['city_table']] <- renderDataTable({
    selected_years()
  })
}

# Create the Shiny App
shinyApp(ui = ui, server = server)
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


[Return](#exercise-4)
{:.notes}
