---
---

## Input/Output Objects

The user interface and the server interact with each other through **input** and
**output** objects. The user's interaction with input objects alters parameters
in the server's instructions -- instructions for creating output objects shown
in the UI.
{:.notes}

Writing an app requires careful attention to how input and output objects
relate to each other, i.e. knowing what actions will initiate what sections of
code to run when.

===

This diagrams input and output relationships within the UI and server objects:

![]({% include asset.html path="images/arrows3.png" %}){:.nobox}
{:.captioned}

===

- Input objects are created and named in the UI with `*Input()` functions like
  `selectInput()` or `radioButtons()`.
- Data from input objects affects `render*()` functions, like `renderPlot()` or
  `renderText()`, in the server that create output objects.
- Output objects are placed in the UI using `*Output()` functions like
  `plotOutput()` or `textOutput()`.

===

## Input Objects

Input objects collect information from the user, and are passed to the server as
a list. Input values change when a user changes the input, and the server is
immediately notified. Inputs can be many different things: single values, text,
vectors, dates, or even files uploaded by the user.
{:.notes}

The best way to find the object you want is through Shiny's [gallery of input
objects](http://shiny.rstudio.com/gallery/widget-gallery.html) with sample code.

===

The first two arguments for all input objects are:

- `inputId` (notice the capitalization here!), for giving the input
  object a name to refer to in the server
- `label` or the text to display for the user

===

Create an input object to let users select a species ID from the species table.



~~~r
# User Interface
in1 <- selectInput(
  inputId = 'pick_species',
  label = 'Pick a species',
  choices = unique(species[['id']]))
~~~
{:title="{{ site.data.lesson.handouts[1] }}" .no-eval .text-document}


===

Add the input to the `tabPanel()` in the `ui`. There's more to come for that panel!



~~~r
...
tab1 <- tabPanel(
  title = 'Species',
  in1, ...)
ui <- navbarPage(
  title = 'Portal Project',
  tab1)
~~~
{:title="{{ site.data.lesson.handouts[1] }}" .no-eval .text-document}


Use the `selectInput()` function to create an input object called
`pick_species`. Use the `choices = ` argument to define a vector with the unique
values in the species id column. Make the input object an argument to the
function `tabPanel()`, preceded by a title argument. We will learn about design
and layout in a subsequent section.
{:.notes}

===

## Input Object Tips

- "choices"" for inputs can be named using a list matching a display name to its
  value, such as `list(Male = 'M', Female = 'F')`.
- [Selectize](http://shiny.rstudio.com/gallery/selectize-vs-select.html) inputs
  are a useful option for long drop down lists.
- Always be aware of what the default value is for input objects you create.

===

## Output Objects

Output objects are created by a `render*()` function in the server and displayed
by a the paired `*Output()` function in the UI. The server function adds the
result of each `render*()` function to a list of output objects.
{:.notes}

| Desired UI Object | `render*()`       | `*Output()`           |
|-------------------+-------------------+----------------------|
| plot              | renderPlot()      | plotOutput()         |
| text              | renderPrint()     | verbatimTextOutput() |
| text              | renderText()      | textOutput()         |
| static table      | renderTable()     | tableOutput()        |
| interactive table | renderDataTable() | dataTableOutput()    |

===

## Text Output

Render the species ID as text using `renderText()` in the server function,
identifying the output as `species_label`.



~~~r
# Server
server <- function(input, output) {
  output[['species_label']] <- renderText({
    input[['pick_species']]
  })
}
~~~
{:title="{{ site.data.lesson.handouts[1] }}" .no-eval .text-document}


===

Display the species ID as text in the user interface's `tabPanel` as a
`textOutput` object.



~~~r
out1 <- textOutput('species_label')
tab1 <- tabPanel(
  title = 'Species',
  in1, out1)
~~~
{:title="{{ site.data.lesson.handouts[1] }}" .no-eval .text-document}


===

Now the `{{ site.data.lesson.handouts[1] }}` file is a complete app, so go ahead and
**runApp**!

Render functions tell Shiny how to build an output object to display in the user
interface. Output objects can be data frames, plots, images, text, or most
anything you can create with R code to be visualized.
{:.notes}

Use `outputId` names in quotes to refer to output objects within `*Output()`
functions. Other arguments to `*Output()` functions can control their size in
the UI as well as add advanced interactivity such as [selecting observations to
view data by clicking on a
plot](http://shiny.rstudio.com/articles/selecting-rows-of-data.html).
{:.notes}

Note that it is also possible to render reactive input objects using the
`renderUI()` and `uiOutput()` functions for situations where you want the type
or parameters of an input object to change based on another input. For an
exmaple, see "Creating controls on the fly"
[here](http://shiny.rstudio.com/articles/dynamic-ui.html).
{:.notes}

===

## Graphical Output

The app in `{{ site.data.lesson.handouts[2] }}`, will use the "animals" table to plot
abundance of the selected species, rather than just printing its id.

First, the server must filter the survey data based on the selected species, and
then create a bar plot **within** the `renderPlot()` function. Don't forget to
import the necessary libraries.
{:.notes}

===



~~~r
# Server
server <- function(input, output) {
  output[['species_label']] <- renderText({
    input[['pick_species']]
  })
  output[['species_plot']] <- renderPlot({
    df <- animals %>%
      filter(species_id == input[['pick_species']])
    ggplot(df, aes(year)) +
      geom_bar()
  })
}
~~~
{:title="{{ site.data.lesson.handouts[2] }}" .no-eval .text-document}


===

Second, use the corresponding `plotOutput()` function in the UI to display the
plot in the app.



~~~r
out1 <- textOutput('species_label')
out2 <- plotOutput('species_plot')
tab1 <- tabPanel(
  title = 'Species',
  in1, out1, out2)
ui <- navbarPage(
  title = 'Portal Project',
  tab1)
~~~
{:title="{{ site.data.lesson.handouts[2] }}" .no-eval .text-document}

