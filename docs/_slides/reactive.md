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
  "city_plot".

===

The app in `{{ site.data.lesson.handouts[3] }}` will have a new input object in the sidebar
panel: a slider that constrains the plotted data to a user defined range of
years



~~~r
in2 <- sliderInput(
  inputId = "my_xlims", 
  label = "Set X axis limits",
  min = 2010, 
  max = 2018,
  value = c(2010, 2018))

side <- sidebarPanel('Options', in1, in2)
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


===

The goal is to limit records to the user's input by adding an additional
filter within the `renderPlot()` function.



~~~r
filter(year %in% ...)
~~~
{:title="" .no-eval .text-document}


In order for `filter()` to dynamically respond to the slider, whatever replaces
`...` must react to the slider.

===

Shiny provides a function factory called `reactive()`. It returns a function
that behaves like elements in the `input` list--they are reactive. We'll use it
to create the function `slider_years()` to dynamically update and pass to the filter.



~~~r
slider_years <- reactive({
    ...
    ...
  })
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


===

The `%in%` test within `filter()` needs a sequence, so we wrap `seq` in
`reactive` to generate a function that creates a sequence based on the user
selected values in the slider bar.



~~~r
slider_years <- reactive({
  seq(input[['my_xlims']][1],
    input[['my_xlims']][2])
})
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


===

Make sure that `slider_years()` is "called", i.e. has parentheses, within the
`renderPlot()` function.



~~~r
output[['city_plot']] <- renderPlot({
    df <- popdata %>% 
      filter(NAME == input[['selected_city']]) %>%
      filter(year %in% slider_years())
    ggplot(df, aes(x = year, y = population)) + 
      geom_line() 
})
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


===

The new reactive can be used in multiple observers, which is easier than
repeating the `seq` definition again, both for you to code and for the server to
process.



~~~r
output[['city_table']] <- renderDataTable({
  df <- popdata %>% 
      filter(NAME == input[['selected_city']]) %>%
      filter(year %in% slider_years())
  df
})
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


===

Too see the data table output, add a corresponding `dataTableOutput()` to the 
user interface and place it in the main panel.



~~~r
out3 <- dataTableOutput('city_table')
main <- mainPanel(out1, out2, out3)
~~~
{:title="{{ site.data.lesson.handouts[3] }}" .no-eval .text-document}


===

Now the `{{ site.data.lesson.handouts[3] }}` file is again a complete app, so go ahead and
**runApp**!
