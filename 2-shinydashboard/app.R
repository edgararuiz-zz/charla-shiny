library(shinydashboard)
library(DT)
library(datos)

ui <- dashboardPage(
  dashboardHeader(title = "Mi shinydashboard"),
  dashboardSidebar(selectInput("trans", "Transmision", c("Automatico", "Manual"))),
  dashboardBody(
    valueBoxOutput("millas"),
    valueBoxOutput("peso"),
    dataTableOutput("mensual")
  )
)

server <- function(input, output, session) {
  sel_autos <- reactive(mtautos[mtautos$transmision == ifelse(input$trans == "Manual", 1, 0), ])
  output$millas  <- renderValueBox(valueBox(round(mean(sel_autos()$millas), 2), subtitle = "Promedio Millas"))
  output$peso    <- renderValueBox(valueBox(round(mean(sel_autos()$peso  ), 2), subtitle = "Promedio Peso", color = "blue"))
  output$mensual <- renderDataTable(datatable(sel_autos()))
}

shinyApp(ui, server)
