---
---

## Design and Layout

A suite of `*Layout()` functions make for a nicer user interface. You can
organize elements using pre-defined high level layouts such as

- `sidebarLayout()`
- `splitLayout()`
- `verticalLayout()`

===

The more general `fluidRow()` allows any [organization of elements within a
grid](http://shiny.rstudio.com/articles/layout-guide.html#grid-layouts-in-depth).
The folowing UI elements, and more, can be layered on top of each other in
either a fluid page or pre-defined layouts.

- `tabsetPanel()`
- `navlistPanel()`
- `navbarPage()`

===

Here is a schematic of nested UI elements inside the `sidebarLayout()`. Red
boxes represent input objects and blue boxes represent output objects. Each
object is located within one or more nested **panels**, which are nested within
a **layout**. Objects and panels that are at the same level of hierarchy need to
be separated by commas in calls to parent functions. Mistakes in usage of commas
and parentheses between UI elements is one of the first things to look for when
debugging a shiny app!
{:.notes}

![]({% include asset.html path="images/layout3.png" %}){:.nobox}
{:.captioned}

===

To re-organize the elements of the "Species" tab using a sidebar layout, we
modify the UI to specify the sidebar and main elements.



~~~r
side <- sidebarPanel('Options', in1)
main <- mainPanel(out1, out2)
tab1 <- tabPanel(
  title = 'Species',
  sidebarLayout(side, main))
~~~
{:title="{{ site.data.lesson.handouts[2] }}" .no-eval .text-document}


===

## General Layouts

The `fluidPage()` layout design consists of rows which contain columns of
elements.

To use it, first define the width of an element relative to a 12-unit
grid within each column using the function `fluidRow()` and listing columns in
units of 12. The argument `offset` can be used to add extra spacing. For
example:
{:.notes}



~~~r
> fluidPage(
+   fluidRow(
+     column(4, '4'),
+     column(4, offset = 4, '4 offset 4')      
+   ),
+   fluidRow(
+     column(3, offset = 3, '3 offset 3'),
+     column(3, offset = 3, '3 offset 3')  
+   ))
~~~
{:title="Console" .no-eval .input}


===

## Customization

Along with input and output objects, you can add headers, text, images, links,
and other html objects to the user interface using "builder" functions. There
are shiny function equivalents for many common html tags such as `h1()` through
`h6()` for headers. You can use the console to see that the return from these
functions produce HTML code.

===



~~~r
> h5('This is a level 5 header.')
~~~
{:title="Console" .no-eval .input}

~~~
<h5>This is a level 5 header.</h5>
~~~
{:.output}




~~~r
> a(href = 'https://www.sesync.org',
+   'This renders a link')
~~~
{:title="Console" .no-eval .input}

~~~
<a href="https://www.sesync.org">This renders a link</a>
~~~
{:.output}

===

## Layout Tips

- In addition to titles for tabs, you can also use
  [icons](http://shiny.rstudio.com/reference/shiny/latest/icon.html).
- Use the argument `position = 'right'` in the `sidebarLayout()` function if you
  prefer to have the side panel appear on the right.
- See [here](http://shiny.rstudio.com/articles/tag-glossary.html) for additional
  html tags you can use.
- For large blocks of text consider saving the text in a separate markdown,
  html, or text file and use an `include*` function
  ([example](http://shiny.rstudio.com/gallery/including-html-text-and-markdown-files.html)).
- Add images by saving those files in a folder called **www**. Embed it with
  `img(src='<FILENAME>')`
- Use [shinythemes](http://rstudio.github.io/shinythemes/)!
