---
---

## Shiny components

Depending on the purpose and computing requirements of any Shiny app, you may set it up to run R code on your computer, a remote server, or in the cloud.
However all Shiny apps consists of the same two main components:

- The **user interface (UI)** which defines what users will see in the app and its design.

- The **server** which defines the instructions for how to assemble components of the app like plots and input widgets.

<!--split-->

For big projects, these components may be defined in separate files called `ui.R` and `server.R` and saved in a folder representing the app.

~~~r
dir("my_app")
~~~
{:.input}

~~~r
[1] "ui.R"  "server.R"  "data" "www"
~~~
{:.output}

<!--split-->

For ease of demonstration, we'll use the alternative approach of defining UI and server objects in a R script representing the app.


~~~r
# User Interface
ui <- ... 

# Server
server <- ...

# Create the Shiny App
shinyApp(ui = ui, server = server)
~~~
{:.text-document title="my_app.R"}

<!--split-->

## But, what's going on?

- The UI is always web page whose content is controlled by a running R session.

- When you run an app through RStudio, that session is running on your laptop or desktop.

- Your browser opens to a port, say it's port # 1234, on your personal computer acting like a web server, which will be at <http://127.0.0.1:1234>

- The R session responds when you interact with the web page, processing R commands and updating UI objects according to their result.

<!--split-->

## Hello, Shiny World!

Open `lesson-6-1.R` in your handouts repository.
In this file, define objects `ui` and `server` with the assignment operator `<-` and then pass them to the function `shinyApp()`.
These are the basic components of a shiny app.


~~~r
# User Interface
ui <- navbarPage(title = "Hello, Shiny World!")

# Server
server <- function(input, output){}

# Create the Shiny App
shinyApp(ui = ui, server = server)
~~~
{:.text-document title="lesson-6-1.R"}

Notice the green **Run App** button appear when the file is saved.
This button also allows you to control whether the app runs in a browser window, in the RStudio Viewer pane, or in an external RStudio window.

![](images/runapp.png)

<aside class="notes" markdown="block">

The `shiny` package must be installed for RStudio to identify files associated with a Shiny App and put up a green arrow with a **Run App** button.
Note that the file names must be `ui.R` and `server.R` if these components are scripted in separate files.

</aside>
