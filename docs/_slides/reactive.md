---
---

## Reactivity

Input objects are **reactive** which means that an update to this value by a user will notify objects in the server that its value has been changed.

The outputs of render functions are called **observers** because they observe all "upstream" reactive values for changes.

===

## Reactive objects

The code inside the body of `render*()` functions will re-run whenever a reactive value (e.g. an input objet) inside the code is changed by the user. When any observer is re-rendered, the UI is notified that it has to update.

===

Question
: Which element is an **observer** in the app within `{{ site.handouts[2] }}`.

Answer
: {:.fragment} The object created by `renderPlot()` and stored with outputId "species_plot".

===

In `{{ site.handouts[3] }}` we're going to create a new input object in the sidebar panel that constrains the plotted data to a user defined range of months.



~~~r
in2 <- sliderInput('slider_months',
                   label = 'Month Range',
                   min = 1,
                   max = 12,
                   value = c(1, 12))
img <- img(src = 'image-filename.png', alt = 'short image description')
side <- sidebarPanel(img, 'Options', in1, in2)									    
~~~
{:.text-document .no-eval title="{{ site.handouts[3] }}"}


===

To limit animals to the user specified months, an additional filter is needed within the `renderPlot()` function like



~~~r
> filter(month %in% ...)
~~~
{:.input title="Console"}


In order for `filter()` to dynamically respond to the slider, whatever replaces `...` must react to the slider.

===

Shiny provides the `reactive()` function for such times when an appropriate `*Input()` object isn't available. The value returned by `reactive()` will also be a function.



~~~r
> filter(month %in% reactive_seq())
~~~
{:.input title="Console"}


===

The `%in%` test within `filter()` needs a sequence, so we wrap `seq` in `reactive` to generate a function that takes no direct input.



~~~r
reactive_seq <- reactive(
    seq(input[['slider_months']][1],
        input[['slider_months']][2])
    )
~~~
{:.text-document .no-eval title="{{ site.handouts[3] }}"}


===

The `reactive_seq` can now be embedded in the `renderPlot()` and `renderDataTable()` functions.



~~~r
# Server
server <- function(input, output) {

    reactive_seq <- reactive(
        seq(input[['slider_months']][1],
            input[['slider_months']][2])
    )
    output[['species_label']] <- renderText(
      species %>%
        filter(id == input[['pick_species']]) %>%
        select(genus, species) %>%
        paste(collapse = ' ')
    )
    output[['species_plot']] <- renderPlot(
        animals %>%
            filter(species_id == input[['pick_species']]) %>%
            filter(month %in% reactive_seq()) %>%
        ggplot(aes(year)) +
            geom_bar()
    )
    output[['species_table']] <- renderDataTable(
        animals %>%
            filter(species_id == input[['pick_species']]) %>%
            filter(month %in% reqctive_seq())
    )
}
~~~
{:.text-document .no-eval title="{{ site.handouts[3] }}"}


===

## Exercise 4

Notice the exact same code exists twice within the server function, once for `renderPlot()` and once for `renderDataTable`. Replace `reactive_seq` with a new `reactive_data_frame` that returns the filtered `data.frame`. Bask in the knowledge of how much CPU time you'll save.
