---
---

## Accessing Data

Because the Shiny app is going to be using your local R session to run, it will
be able to recognize anything that is loaded into your working environment. It
won't however find variables in your current environment! Every dependency must
be in the script run by the server.
{:.notes}

To begin building your own Shiny app, first read in a CSV file with data that
we will explore in the app. These data are yearly population estimates for U.S. 
cities between 2010-2019 from the [U.S. Census Bureau](https://www.census.gov/data/tables/time-series/demo/popest/2010s-total-metro-and-micro-statistical-areas.html). 
Once the data is in your R environment, it will be available to use in
both the `ui` and `server` objects.



~~~r
# Data
popdata <- read.csv('data/citypopdata.csv')
~~~
{:title="{{ site.data.lesson.handouts[1] }}" .no-eval .text-document}


Shiny apps can also be designed to interact with remote data or database servers.
{:.notes}
