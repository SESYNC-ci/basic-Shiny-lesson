---
---

## Lesson Goals

This lesson presents an introduction to creating interactive web applications using the R [Shiny](https://cran.r-project.org/web/packages/shiny/index.html) package. It covers:

- The basic building blocks of a Shiny app
- How to create interactive elements, including plots
- How to customize and arrange elements on a page

===

## Data

This lesson makes use of several publicly available datasets that have been customized for teaching purposes, including the [Portal teaching database](https://github.com/weecology/portal-teachingdb).

===

## What is Shiny?

Shiny is a web application framework for R that allows you to create interactive web apps without requiring knowledge of HTML, CSS, or JavaScript. These web apps can be used for exploratory data analysis and visualization, to facilitate remote collaboration, share results, and [much more](http://shiny.rstudio.com/gallery/). The example below, and many [additional examples](http://shiny.rstudio.com/tutorial/lesson1/#Go Further), will open in a new browser window (you may need to prevent your broswer from blocking pop-out windows in order to view the app).
{:.notes}

The `shiny` package includes some built-in examples to demonstrate some of its basic features. When applications are running, they are displayed in a separate browser window or the RStudio Viewer pane. 


~~~r
library(shiny)
runExample('01_hello')
~~~
{:.input}

===

![]({{ site.baseurl }}/images/shiny_stop.png)

Notice back in RStudio that a stop sign appears in the Console window while your app is running. This is because the current R session is busy running your application.

Closing the app window may not stop the app from using your R session. Force the app to close when necessary by clicking the stop sign in the header of the Console window. The Console window prompt `>` should return.
{:.notes}