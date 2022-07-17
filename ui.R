library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Running interval calculator"),
  fluidRow(
    column(
      width = 4,
      wellPanel(
        div(HTML("<strong>Instructions</strong>
<ul>
<li>Enter you current 5K time using the drop downs.</li>
<li>Choose an interval distance with the dropdown.</li>
<li>(Optional) - choose how much faster you'd like to run the interval, this will be auto-filled with a distance-based recommendation.</li>
<li>Click the button!</li>
</ul>")),
        fluidRow(column(
          width = 12,
          actionButton(
            inputId = "go",
            label = "Work out target pace",
            icon = icon("running")
          )
        )),
      )
    ),
    column(
      width = 4,
      wellPanel(
        strong("Current 5K time"),
        fixedRow(
          column(
            width = 4,
            selectInput(
              inputId = "input_hours",
              label = "hh",
              choices = 0:2,
              selected = "0"
            )
          ),
          column(
            width = 4,
            selectInput(
              inputId = "input_mins",
              label = "mm",
              choices = 0:60,
              selected = "0"
            )
          ),
          column(
            width = 4,
            selectInput(
              inputId = "input_secs",
              label = "ss",
              choices = 0:60,
              selected = "0"
            )
          )
        ),
        fluidRow(column(
          width = 12,
          textOutput(outputId = "time_5k")
        ))
      )
    ),
    column(
      width = 4,
      wellPanel(
        selectInput(
          inputId = "input_distance",
          label = "Interval distance",
          choices = c("100m", "200m", "400m", "800m"),
          selected = "400m"
        ),
        sliderInput(
          inputId = "input_faster",
          label = "% faster",
          min = 0,
          max = 50,
          value = 10,
          step = 1
        ),
        textOutput(outputId = "pct_faster_text")
      )
    )
  ),
  fluidRow(br()),
  fluidRow(column(
    width = 12,
    verbatimTextOutput(outputId = "final_text")
  ))
))
