library(shiny)

shinyServer(function(input, output) {
  time_5k <- reactive({
    if (all(input$input_secs == "0", input$input_mins == "0", input$input_hours == "0")) {
      NA
    } else {
    hms::hms(
      seconds = as.integer(input$input_secs),
      minutes = as.integer(input$input_mins),
      hours = as.integer(input$input_hours)
    )
    }
  }) |>
    bindCache(input$input_hours, input$input_mins, input$input_secs)

  output$time_5k <- renderText(
    if (is.na(time_5k())) {
      "Enter your current 5K time above."} else {

    glue::glue("Current 5K time {ifelse(time_5k() > 3600, strftime(time_5k(), format = '%H:%M:%S'), strftime(time_5k(), format = '%M:%S'))}")
      }
        )


  pace_5k <- reactive(hms::as_hms(round(time_5k() / 5)))

  pct_faster_recommended <- reactive({
    pct_faster_recommended <- switch(input$input_distance,
      "100m" = 15,
      "200m" = 12,
      "400m" = 10,
      "800m" = 8
    )

    updateSliderInput(
      inputId = "input_faster",
      value = pct_faster_recommended
    )

    return(pct_faster_recommended)
  })

  adjust <- reactive({
    (input$input_faster / 100) + 1
  })

  pct_faster <- reactive(input$input_faster)


  output$pct_faster_text <- renderText(glue::glue("The recommendation for {input$input_distance} is to run {pct_faster_recommended()}% faster than your 5K pace."))

  target_pace <- reactive({
    hms::as_hms(round(pace_5k() / adjust()))
  })

  target_time <- reactive({
    fraction_of_km <- switch(input$input_distance,
      "100m" = 0.1,
      "200m" = 0.2,
      "400m" = 0.4,
      "800m" = 0.8
    )

    hms::as_hms(round(pace_5k() / adjust() * fraction_of_km))
  })


  v <- reactiveValues(clearText = TRUE)

  output$final_text <- renderText({
    ""
  }) |>
    bindEvent(c(
      input$input_hours,
      input$input_mins,
      input$input_secs,
    ))

  observeEvent(
    input$go,
    v$clearText <- FALSE
  )

  observeEvent(
    c(time_5k()),
    v$clearText <- TRUE
  )

  output$final_text <- renderText(
    {
      if (v$clearText) {
        return()
      } else {
        c(
          glue::glue("Your current 5K pace is {strftime(pace_5k(), format = '%M:%S')} mins/km"),
          glue::glue("If you aim to do {input$input_distance} paced {pct_faster()}% faster"),
          glue::glue("Your target pace should be {strftime(target_pace(), format = '%M:%S')} mins/km"),
          glue::glue("Alternatively the interval time should be {strftime(target_time(), format = '%M:%S')}")
        )
      }
    },
    sep = "\n"
  )
})
