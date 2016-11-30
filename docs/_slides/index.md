---
title: "Interactive web applications with RShiny"
author: "Kelly Hondula"
output: 
    html_document:
      toc: true
      toc_depth: 2
---
  
# Part II: Shiny extensions

You can enhance and extend the functionality and sophistication of Shiny apps using existing tools and platforms. Javascript visualizations can be used in RShiny with a framework called [htmlwidgets](http://www.htmlwidgets.org/index.html), which lets you access powerful features of tools like Leaflet, [plot.ly](https://plot.ly/r/shiny-tutorial/#plotly-graphs-in-shiny),and d3 within R. Since these frameworks are bridges to, or wrappers, for the original libraries and packages that may have been written in another programming language, deploying them requires becoming familiar with the logic and structure of the output objects being created. You can also incorporate Javascript code in apps. Read more about how to create bindings to Javascript libraries [here](http://shiny.rstudio.com/tutorial/js-lesson1/).

The [Leaflet package for R](https://rstudio.github.io/leaflet/) which we will use is well-integrated with other R packages like Shiny and sp however it is also useful to refer to the more extensive documentation of its [JavaScript library](http://leafletjs.com/reference.html). 

**Some shiny extensions**

* [shinyjs](https://github.com/daattali/shinyjs): Enhance user experience in Shiny apps using JavaScript functions without knowing JavaScript
* [ggvis](http://ggvis.rstudio.com/): Similar to ggplot2, but the plots are focused on being web-based and are more interactive
* [leaflet](https://rstudio.github.io/leaflet/): geospatial mapping
* [dygraphs](https://rstudio.github.io/dygraphs/): time series charting
* [metricsgraphics](https://hrbrmstr.github.io/metricsgraphics/): scatterplots and line charts with D3
* [networkD3](https://christophergandrud.github.io/networkD3/): graph data visualization with D3
* [d3heatmap](http://rpubs.com/jcheng/mtcars-heatmap): interactive heatmaps with D3
* [threejs](http://bwlewis.github.io/rthreejs/): 3D scatterplots and globes
* [DiagrammeR](http://rich-iannone.github.io/DiagrammeR/): Diagrams and flowcharts

## Leaflet 

Install and load the `leaflet` package and make a simple interactive map to view within RStudio's Viewer Pane. Learn about how "slippy" or zoomable web maps work on the Mapbox website [here](https://www.mapbox.com/help/how-web-maps-work/).


~~~r
install.packages("leaflet")
library(leaflet)
leaflet() %>% addTiles() 
~~~
{:.input}


~~~r
install.packages("leaflet")
library(leaflet)
leaflet() %>% addTiles() %>%
  setView(lng = -76.505206, lat = 38.9767231, zoom = 5) %>%
  addWMSTiles(
  "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
  layers = "nexrad-n0r-900913", group = "base_reflect",
  options = WMSTileOptions(format = "image/png", transparent = TRUE),
  attribution = "Weather data © 2012 IEM Nexrad"
)
~~~
{:.input}

Just like plots, text, and data frames, UI elements created with htmlwidgets are based on the combination of a render function and an output function. For Leaflet, these functions are `renderLeaflet()` and `leafletOutput()`. Leaflet map output objects are defined in the render function and can incorporate input objects. 

The code inside the render function describes how to create the leaflet map object based on functions in the leaflet package. It starts with the function `leaflet()` which returns a map object, and then adds to and modifies elements of that object using the [pipe operator](https://cran.r-project.org/web/packages/magrittr/vignettes/magrittr.html) `%>%`. Elements include background map tiles, markers, polygons, lines, and other geographical features. 

> Add a new panel to the navbar called "Map" that contains a Leaflet map object with a marker at SESYNC's location. Note that it may take some time for the map to appear. 


~~~r
# in server
  output$sesync_map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(lng = -76.505206, lat = 38.9767231, popup = "SESYNC")
  })

# in UI
   tabPanel("Map", leafletOutput("sesync_map"))
)
~~~
{:.input}

![](images/map1.png)

Using `addTiles()` displays the default background map tiles. However there are many more options to pick from. There is a list of the free background tiles available and what they look like [here](http://leaflet-extras.github.io/leaflet-providers/preview/index.html). To use a different background specify which `ProviderTiles` to display. (Or if you are ambitious, you can create your own tiles for example using free data from [OpenStreetMap](http://osm2vectortiles.org/maps/).

> Change the background image from the default to Esri's free World Imagery.


~~~r
  output$sesync_map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("Esri.WorldImagery") %>%
      addMarkers(lng = -76.505206, lat = 38.9767231, popup = "SESYNC")
  })

tabPanel("Map", leafletOutput("sesync_map"))
~~~
{:.input}

![](images/map2.png)

Leaflet uses the [Web Mercator](http://epsg.io/3857) projection. The use of a (pseudo)-conformal projection is useful for "slippy" web map features of panning and zooming since it preserves a north-up orientation. However because of some [mathematical intricacies of Web Mercator](http://www.hydrometronics.com/downloads/Web%20Mercator%20-%20Non-Conformal,%20Non-Mercator%20(notes).pdf), Leaflet will only convert objects to EPSG:3857 if it can. The Leaflet package in R does [not yet have](https://github.com/rstudio/leaflet/issues/233) the capability to handle objects that are not in common projections like WGS84.

In order to plot the `huc_md` object created in the [geospatial lesson](https://SESYNC-ci.github.com/geospatial-packages-in-R-lesson/), we will need to use non-projected coordinates instead of the Alber's equal area projection.

> Read in the counties, watershed boundaries, and NLCD datasets as in the geospatial lesson. Subset the counties to those in MD.


~~~r
library(sp)
library(rgdal)
library(rgeos)
library(raster)

# make sure you are in your %sandbox% directory!

counties <- readOGR(dsn = "data/cb_2014_us_county_500k/cb_2014_us_county_500k.shp",
                    layer = "cb_2014_us_county_500k", 
                    stringsAsFactors = FALSE)

huc <- readOGR(dsn = "data/huc250k/huc250k.shp", 
               layer = "huc250k",
               stringsAsFactors = FALSE)

nlcd <- raster("data/nlcd_agg.grd")


counties_md <- counties[counties$STATEFP == "24", ]  
~~~
{:.input}

In order to perform the union and intersection operations but preserve compatability with leaflet, transform the watershed boundaries and Maryland counties to unprojected coordinate systems.


~~~r
huc <- spTransform(huc, CRS("+proj=longlat +datum=WGS84"))
counties_md <- spTransform(counties_md, CRS("+proj=longlat +datum=WGS84"))
state_md <- gUnaryUnion(counties_md)
huc_md <- gIntersection(huc, state_md, byid = TRUE, 
                        id = paste(1:length(huc), huc$HUC_NAME))
~~~
{:.input}

Add the watershed boundaries in Maryland layer to the map using `addPolygons()`. Overlay the NLCD data using `addRasterImage()`.


~~~r
# in server
  output$sesync_map <- renderLeaflet({
    leaflet(huc_md) %>% 
      setView(lng = -76.505206, lat = 38.9767231, zoom = 7) %>%
      addProviderTiles("Esri.WorldImagery") %>%
      addMarkers(lng = -76.505206, lat = 38.9767231, popup = "SESYNC") %>%
      addPolygons(fill = FALSE)  %>%
      addRasterImage(nlcd, opacity = 0.5, maxBytes = 10*1024*1024)
  })
~~~
{:.input}

![](images/map3.png) The values of the `zoom` argument in `setView()` are based on zoom levels in tile management schemes. Get a sense for zoom levels of tiles [here](http://www.maptiler.org/google-maps-coordinates-tile-bounds-projection/)

Since drawing maps can be computationally intensive, interactivity within the map is typically handed outside of the main render function using a function in the server called `leafletProxy()`, and the static map elements are handled within the first render function. See an example of how to implement this [here](http://www.r-bloggers.com/r-shiny-leaflet-using-observers/) and [here](http://www.r-bloggers.com/climate-projections-by-cities-r-shiny-rcharts-leaflet/).

We can add some simple interactivity by assigning groups to **layers** and using the `addLayersControl()` function. See how this works by adding 2 different masks of the nlcd data with an additional argument `group =` in the `addRasterImage()` function. For grouped layers, add a feature to toggle between them with layers control. See documentation on this feature [here](https://rstudio.github.io/leaflet/showhide.html).


~~~r
  output$sesync_map <- renderLeaflet({
     leaflet(huc_md) %>% 
      setView(lng = -76.505206, lat = 38.9767231, zoom = 7) %>%
      addProviderTiles("Esri.WorldImagery") %>%
      addMarkers(lng = -76.505206, lat = 38.9767231, popup = "SESYNC") %>%
      addPolygons(fill = FALSE, group = "MD watersheds")   %>%
      addRasterImage(mask(nlcd, nlcd == 41, maskvalue = FALSE), opacity = 0.5, 
                     group = "Deciduous Forest", colors = "green") %>%
      addRasterImage(mask(nlcd, nlcd == 81, maskvalue = FALSE), opacity = 0.5, 
                     group = "Pasture", colors = "yellow") %>%
      addLayersControl(baseGroups=c("Deciduous Forest", "Pasture"),
                       overlayGroups = c("MD watersheds"))
  })
~~~
{:.input}

# Additional references

## From RStudio

* [Shiny cheat sheet by RStudio](http://www.rstudio.com/wp-content/uploads/2016/01/shiny-cheatsheet.pdf)
* [Shiny tutorial by RStudio](http://shiny.rstudio.com/tutorial/)
* [Input widget gallery](http://shiny.rstudio.com/gallery/widget-gallery.html)
* [Advanced interactions for plots](https://gallery.shinyapps.io/095-plot-interaction-advanced/)
* [Shiny modules](http://shiny.rstudio.com/articles/modules.html)
* [shinyURL](https://aoles.shinyapps.io/ShinyDevCon/#1)


## Other/ tutorials

* [Building shiny app tutorial by Dean Attali](https://docs.google.com/presentation/d/1dXhqqsD7dPOOdcC5Y7RW--dEU7UfU52qlb0YD3kKeLw/edit#slide=id.p)
* [Principles of Reactivity](https://cdn.rawgit.com/rstudio/reactivity-tutorial/master/slides.html#/) by Joe Cheng
* [Reactivity tutorial](https://github.com/rstudio/reactivity-tutorial) by Joe Cheng
* [NEON Shiny tutorial](http://neondataskills.org/R/Create-Basic-Shiny-App-In-R/)
* [Geospatial libraries for R](http://www.r-bloggers.com/ropensci-geospatial-libraries/)
* [Computerworld tutorial Create maps in R in 10 easy steps](http://www.computerworld.com/article/3038270/data-analytics/create-maps-in-r-in-10-fairly-easy-steps.html?page=2)
* [How web maps work](https://www.mapbox.com/help/how-web-maps-work/)
* https://github.com/aoles/ShinyDevCon-notes
* [debugging in shiny](http://rpubs.com/jmcphers/149638)
* http://egallic.fr/maps-with-r/
* [Shiny articles on r-bloggers](http://www.r-bloggers.com/?s=shiny)
  * http://www.r-bloggers.com/interactive-mapping-with-leaflet-in-r/
  * http://www.r-bloggers.com/upload-shapefile-to-r-shiny-app-to-extract-leaflet-map-data/
* [Top rated questions about shiny on stackoverflow](http://stackoverflow.com/questions/tagged/shiny?sort=votes&pageSize=15)
* [Shiny dashboards](https://rstudio.github.io/shinydashboard/get_started.html)

## Example Shiny apps

  * http://daattali.com/shiny/cancer-data/
  * https://uasnap.shinyapps.io/nwtapp/
