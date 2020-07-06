---
---

## Accessing Data

Because the Shiny app is going to be using your local R session to run, it will
be able to recognize anything that is loaded into your working environment. It
won't however find variables in your current environment! Every dependency must
be in the script run by the server.
{:.notes}

To Begin your own Shiny app, read in CSV files from the Portal Dataset, so the
variables are available to definitions of both the `ui` and `server`. The app
script is in the same folder as `data`, and you only need to specify the
_relative_ file path.



~~~r
# Data
popdata <- read.csv('data/citypopdata.csv')
~~~
{:title="{{ site.data.lesson.handouts[1] }}" .no-eval .text-document}


Shiny apps can also be designed to interact with remote data or database servers.
{:.notes}
