---
---

## Accessing data

Because the Shiny app is going to be using your local R session to run, it will be able to recognize anything that is loaded into your working environment.

<!--split-->

Here, we read in CSV files from the Portal dataset, so it is available to both the ui and server definitions.
The app script is in the same folder as `data`, and you only need to specify the _relative_ file path.


~~~r
# Data
species <- read.csv("data/species.csv", stringsAsFactors = FALSE)
surveys <- read.csv("data/surveys.csv", na.strings = "", stringsAsFactors = FALSE)

# User Interface
ui <- ...

# Server
server <- ...

# Run app
shinyApp(ui = ui, server = server)
~~~
{:.text-document title="{{ site.worksheet[2] }}"}

Shiny apps can also be designed to interact with remote data or shared databases.
