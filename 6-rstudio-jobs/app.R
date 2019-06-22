library(shiny)
library(datos)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
    titlePanel("Géiser Viejo Fiel (Old Faithful)"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("compartimientos",
                        "Número de Compartimientos:",
                        min = 1,
                        max = 20,
                        value = 10
            )
        ),
        mainPanel(
            plotOutput("distPlot")
        )
    )
)

server <- function(input, output) {
    output$distPlot <- renderPlot(
        fiel %>%
            ggplot() +
            geom_histogram(aes(espera),
                           color = "white",
                           bins = input$compartimientos
            ) 
    )
}

shinyApp(ui = ui, server = server)
