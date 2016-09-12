---
---

## User submitted data

A particularly useful type of user input is a file, made possible with the `fileInput()` function.

- reates a data frame with column `datapath` giving the path to each uploaded file
- allows explicity control over permissible data (by specification of MIME type, an internet standard)

<!--split-->

## Data download

It is also possible to let users download files from a Shiny app, such as a csv file of the currently visible data.

The `downloadHandler()` function, analagous to the `render*()` functions that create output objects, requires two arguments:

- **filename**, a string or a function that returns a string ending with a file extention
- **content**, a function to generate the content of the file and write it to a temporary file


~~~r
# Server
  ...
  output[["download_data"]] <- downloadHandler(
    filename = "species.csv",
    content = function(file) {
      surveys %>%
      filter(species_id == input[["pick_species"]]) %>%
      filter(month %in% reactive_range()) %>%
      write.csv(file)
    }
  )
}
~~~
{:.text-document title="lesson-6-4.R"}

<!--split-->

The UI now gets a download button!


~~~r
# User Interface
  ...
  dl <- downloadButton("download_data", label = "Download")
  side <- sidebarPanel(h3("Options", align="center"), in1, in2, dl)
  ...
~~~
{:.text-document title="lesson-6-4.R"}

<!--split-->

## Exercise 4

Notice the exact same code exists twice within the server function ... what a waste of CPU time! Extract the data processing to its own reactive object, which updates when and only when the input objects it references are updated.
