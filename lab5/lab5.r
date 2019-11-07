library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("x",
                  "Задайте знанчения x:",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 1),
      sliderInput("mu",
                  "Задайте значения μ:",
                  min = 0,
                  max = 5,
                  value = 0,
                  step = 1),
      sliderInput("y",
                  "Задайте значения y:",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 1         
      )
    ),
    mainPanel(
      HTML("<center><h1><b>График линий уровня нормального распределения</b></h1>"),
      textOutput(outputId = "error"),
      plotOutput("plot")
    )
  )  
)

server <- function(input, output) {
  
  output$plot <- renderPlot({
    x <- input$x
    y <- input$y
    mu <- input$mu
    sigma = matrix(c(x, mu, mu, y), 2, 2)
    
    if (det(sigma) <= 0) {
      output$error <- renderText({"Определитель меньше или равен 0"})
    } else {
      output$error <- renderText({""})
      
      normDistr = function(x, y, mu, sigma) {
        x = matrix(c(x, y), 1, 2)
        n = 2
        k = 1 / sqrt((2 * pi) ^ n * det(sigma))
        e = exp(-0.5 * (x - mu) %*% solve(sigma) %*% t(x - mu))
        k * e
      }
      
      zfunc <- function(x, y) {
        sapply(1:length(x), function(i) normDistr(x[i], y[i], mu, sigma))
      }
      
      
      radius <- 3
      minX <- -sigma[1, 1] - radius
      maxX <- sigma[1, 1] + radius
      minY <- -sigma[2, 2] - radius
      maxY <- sigma[2, 2] + radius
      
      x = seq(minX, maxX, len=150)
      y = seq(minY, maxY, len=150)
      z = outer(x, y, zfunc)
      
      contour(x, y, z, asp = 1)
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

