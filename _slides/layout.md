---
---

## Design and Layout

A suite of `*Layout()` functions make for a nicer user interface. You can organize elements using pre-defined high level layouts such as

- `sidebarLayout()`
- `splitLayout()`
- `verticalLayout()`

<!--split-->

The more general `fluidRow()` allows any [organization of elements within a grid](http://shiny.rstudio.com/articles/layout-guide.html#grid-layouts-in-depth).
The folowing UI elements, and more, can be layered on top of each other in either a fluid page or pre-defined layouts.

- `tabsetPanel()`
- `navlistPanel()`
- `navbarPage()`

<!--split-->

Here is a schematic of nested UI elements inside the `sidebarLayout()`. Red boxes represent input objects and blue boxes represent output objects.

![](images/navbarPage.png)

<aside class="notes" markdown="block">

Each object is located within one or more nested **panels**, which are nested within a **layout**.
Notice that **tab panels** with the sidebar layout's main panel are nested within the **tabset panel**.
Objects and panels that are at the same level of hierarchy need to be separated by commas in calls to parent functions.

Mistakes in usage of commas and parentheses between UI elements is one of the first things to look for when debugging a shiny app! 

</aside>

<!--split-->

To re-organize the elements of the "Species" tab using a sidebar layout, we modify the UI to specify the sidebar and main elements.


~~~r
# User Interface
in1 <- selectInput("pick_species",
                   label = "Pick a species",
                   choices = unique(species[["species_id"]]))
out2 <- plotOutput("species_plot")
side <- sidebarPanel("Options", in1)
main <- mainPanel(out2)
tab <- tabPanel("Species",
                sidebarLayout(side, main))
ui <- navbarPage(title = "Portal Project", tab)						      
~~~
{:.text-document title="lesson-6-3.R"}

<!--split-->

## Exercise 2

Include a tabset within the main panel. Call the first element of the tabset "Plot" and show the current plot. Call the second element of the tabset "Data" and show an interactive table with the surveys data used in the plot.


<aside class="notes" markdown="block">

Notice the many features of the data table output. There are many options that can be controlled within the render function such as pagination and default length. See [here](http://shiny.rstudio.com/gallery/datatables-options.html) for examples and how to extend this functionality using JavaScript.

</aside>

<!--split-->

## General layouts

The `fluidPage()` layout design consists of rows which contain columns of elements. To use it, first define the width of an element relative to a 12-unit grid within each column using the function `fluidRow()` and listing columns in units of 12. The argument `offset` can be used to add extra spacing. For example:


~~~r
fluidPage(
  fluidRow(
    column(4, "4"),
    column(4, offset = 4, "4 offset 4")      
  ),
  fluidRow(
    column(3, offset = 3, "3 offset 3"),
    column(3, offset = 3, "3 offset 3")  
  ))
~~~
{:.input}

<!--split-->

## Customization

Along with input and output objects, you can add headers, text, images, links, and other html objects to the user interface. There are shiny function equivalents for many common html tags such as `h1()` through `h6()` for headers. You can use the console to see that the return from these functions produce HTML code.


~~~r
h5("This is a level 5 header")
~~~
{:.input}


~~~r
a(href="www.sesync.org", "This syntax renders a link")
~~~
{:.input}

## Exercise 3

Turn the title of the sidebar into a formatted header. Use the ability of the shiny::builder functions to specify [HTML attributes](http://www.w3schools.com/tags/tag_hn.asp) that center the heading.

<!--split-->

## Some useful features and resources

- In addition to titles for tabs, you can also use [icons](http://shiny.rstudio.com/reference/shiny/latest/icon.html). 
- Use the argument `position = "right"` in the `sidebarLayout()` function if you prefer to have the side panel appear on the right. 
- See [here](http://shiny.rstudio.com/articles/tag-glossary.html) for additional html tags you can use.
- For large blocks of text consider saving the text in a separate markdown, html, or text file and use an `include*` function ([example](http://shiny.rstudio.com/gallery/including-html-text-and-markdown-files.html)). 
- Add images by saving those files in a folder called **www**. Link to it with `img(src="<file name>")`
- Use a shiny theme with the [shinythemes](http://rstudio.github.io/shinythemes/) package
