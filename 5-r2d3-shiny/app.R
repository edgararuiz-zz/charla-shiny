library(shiny)
library(dplyr)
library(r2d3)
library(datos)
library(DT)
library(rlang)

ui <- fluidPage(
  selectInput("var", "Variable",
              list("estado_civil", "ingreso", "partido", "religion", "denominacion"),
              selected = "estado_civil"),
  d3Output("d3"),
  DT::dataTableOutput("table"),
  textInput("val", "Value")
)

server <- function(input, output, session) {
  output$d3 <- renderD3({
    encuesta %>%
      mutate(label = !!sym(input$var)) %>%
      group_by(label) %>%
      tally() %>%
      arrange(desc(n)) %>%
      mutate(
        y = n,
        ylabel = prettyNum(n, big.mark = ","),
        fill = ifelse(label != input$val, "#E69F00", "red"),
        mouseover = "#0072B2"
      ) %>%
      r2d3("grafica.js")
  })
  observeEvent(input$bar_clicked, {
    updateTextInput(session, "val", value = input$bar_clicked)
  })
  output$table <- renderDataTable({
    encuesta %>%
      filter(!!sym(input$var) == input$val) %>%
      datatable()
  })
}

shinyApp(ui = ui, server = server)