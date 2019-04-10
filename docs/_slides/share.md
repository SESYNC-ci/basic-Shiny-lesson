---
---

## Share Your App

Once you have made an app, there are several ways to share it with others. It is
important to make sure that everything the app needs to run (data and packages)
will be loaded into the R session.

There is a series of articles on the RStudio website [about deploying
apps](http://shiny.rstudio.com/articles/#deployment).

===

## Sharing as Files

- Directly share the source code (app.R, or ui.R and server.R) along with all
  required data files
- Publish to a GitHub repository, and advertise that your app can be cloned
  and run with `runGitHub('<USERNAME>/<REPO>')`

===

## Sharing as a Site

To share just the UI (i.e. the web page), your app will need to be hosted by a
server able to run the R code that powers the app while also acting as a public
web server. There is limited free hosting available through RStudio with
[shinapps.io](http://www.shinyapps.io/). SESYNC maintains a Shiny Apps server
for our working group participants, and many other research centers are doing
the same.
