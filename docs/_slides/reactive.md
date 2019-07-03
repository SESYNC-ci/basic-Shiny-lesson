---
---

## Reactivity

Input objects are **reactive** which means that an update to this value by a
user will notify objects in the server that its value has been changed.

The outputs of render functions are called **observers** because they observe
all "upstream" reactive values for relevant changes.

===

## Reactive Objects

The code inside the body of `render*()` functions will re-run whenever a
reactive value (e.g. an input objet) inside the code is changed by the user.
When any observer is re-rendered, the UI is notified that it has to update.

===

Question
: Which element is an **observer** in the app within `{{ site.data.lesson.handouts[2] }}`?

Answer
: {:.fragment} The object created by `renderPlot()` and stored with outputId
  "species_plot".

===

The app in `{{ site.data.lesson.handouts[3] }}` will have a new input object in the sidebar
panel, a slider that constrains the plotted data to a user defined range of
months.



~~~r
in2 <- sliderInput(
  inputId = 'slider_months',
  label = 'Month Range',
  min = 1, max = 12,
  value = c(1, 12))
side <- sidebarPanel('Options', in1, in2)
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


===

The goal is to limit animals records to the user's input by adding an additional
filter within the `renderPlot()` function.



~~~r
filter(month %in% ...)
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


In order for `filter()` to dynamically respond to the slider, whatever replaces
`...` must react to the slider.

===

Shiny provides a function factory called `reactive()`. It returns a function
that behaves like elements in the `input` list--they are reactive. We'll use it
to create the function `slider_months()` to dynamically update the filter.



~~~r
slider_months <- reactive({
    ...
    ...
  })
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


===

The `%in%` test within `filter()` needs a sequence, so we wrap `seq` in
`reactive` to generate a function that responds to a user input.



~~~r
slider_months <- reactive({
  seq(input[['slider_months']][1],
    input[['slider_months']][2])
})
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


===

Make sure that `slider_months()` is "called", i.e. has parentheses, within the
`renderPlot()` function.



~~~r
output[['species_plot']] <- renderPlot({
  df <- animals %>%
    filter(species_id == input[['pick_species']]) %>%
    filter(month %in% slider_months()) %>%
  ggplot(df, aes(year)) +
    geom_bar()
})
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


===

The new reactive can be used in multiple observers, which is easier than
repeating the `seq` definition again, both for you to code and for the server to
process.



~~~r
output[['species_table']] <- renderDataTable({
  df <- animals %>%
    filter(species_id == input[['pick_species']]) %>%
    filter(month %in% slider_months())
  df
})
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


===

Don't forget to add a corresponding `dataTableOutput()` to the user interface.



~~~r
out3 <- dataTableOutput('species_table')
main <- mainPanel(out1, out2, out3)
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}

