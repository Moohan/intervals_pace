library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Running interval calculator"),
  fluidRow(
    column(
      width = 4,
      wellPanel(
        fixedRow(
          column(
            width = 4,
            numericInput(
              inputId = "input_hours",
              label = "hh",
              value = 0,
              min = 0,
              max = 2
            )
          ),
          column(
            width = 4,
            numericInput(
              inputId = "input_mins",
              label = "mm",
              value = 0,
              min = 0,
              max = 60
            )
          ),
          column(
            width = 4,
            numericInput(
              inputId = "input_secs",
              label = "ss",
              value = 0,
              min = 0,
              max = 60
            )
          )
        ),
        fluidRow(column(
          width = 12,
          textOutput(outputId = "time_5k")
        ))
      )
    )
  ),
  fluidRow(
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
  fluidRow(column(
    width = 4,
    actionButton(
      inputId = "go",
      label = "Work out target pace",
      icon = icon("running")
    )
  )),
  fluidRow(br()),
  fluidRow(column(
    width = 12,
    verbatimTextOutput(outputId = "final_text")
  ))
))
