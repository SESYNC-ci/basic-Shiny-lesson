---
---

## Share your app

Once you have made an app, there are several ways to share it with others. It is important to make sure that everything the app needs to run (data and packages) will be loaded into the R session. 

There is a series of articles on the RStudio website [here](http://shiny.rstudio.com/articles/) about deploying apps.

<!--split-->

### Share as files

- email or copy app.R, or ui.R and server.R, and all required data files
- host the same files and data as a GitHub repository and advertise its accessbility through calls to `shiny::runGitHub("%repo%", "%username%")`

---

### Share as a website

To share just the UI (i.e. the web page) it will need to be hosted by a computer able to run the R code that powers the app while acting as a public web server. There is limited free hosting available through RStudio with [shinapps.io](http://www.shinyapps.io/). SESYNC maintains a Shiny Apps server for our working group participants, and many other research centers are doing the same.
