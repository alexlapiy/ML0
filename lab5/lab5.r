library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("x1",
                  "Значение [1, 1]:",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 1),
      sliderInput("x2",
                  "Значение [2, 2]:",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 1         
      ),
      sliderInput("x3",
                  "Значение [1, 2], [2, 1]:",
                  min = 0,
                  max = 5,
                  value = 0,
                  step = 1)
    ),
    mainPanel(
      HTML("<center><h1><b>График линий уровня нормального распределения</b></h1>"),
      textOutput(outputId = "sigmaMess1"),
      textOutput(outputId = "sigmaMess2"),
      h4(textOutput(outputId = "detSigma")),
      textOutput(outputId = "error"),
      plotOutput("plot")
    )
  )  
)

server <- function(input, output) {
  
  output$plot <- renderPlot({
    x1 <- input$x1
    x2 <- input$x2
    x3 <- input$x3
    mu <- matrix(0, 1, 2) # центр 0, 0
    sigma <- matrix(c(x1, x3, x3, x2), 2, 2)
    
    output$sigmaMess1 = renderText({
      paste(sigma[1,1],sigma[1,2],sep=" ")
    })
    
    output$sigmaMess2 = renderText({
      paste(sigma[2,1],sigma[2,2],sep=" ")
    })
    
    output$detSigma = renderText({
      paste("Определитель ", det(sigma))
    })
    
    if (det(sigma) <= 0) {
      output$error <- renderText({"Определитель меньше или равен 0, кривая второго порядка параболического или гиперболического типа"})
    } else {
      output$error <- renderText({"Определитель больше 0, кривая второго порядка эллиптического типа"})
      
      normDistr = function(x1, x2, mu, sigma) {
        x <- matrix(c(x1, x2), 1, 2)
        n <- 2
        k <- 1 / sqrt((2 * pi) ^ n * det(sigma))
        e <- exp(-0.5 * (x - mu) %*% solve(sigma) %*% t(x - mu))
        k * e
      }
      
      zfunc <- function(x1, x2) {
        sapply(1:length(x1), function(i) normDistr(x1[i], x2[i], mu, sigma))
      }
      
      radius <- 3
      minX <- -sigma[1, 1] - radius
      maxX <- sigma[1, 1] + radius
      minY <- -sigma[2, 2] - radius
      maxY <- sigma[2, 2] + radius
      
      x1 <- seq(minX, maxX, len=150)
      x2 <- seq(minY, maxY, len=150)
      z <- outer(x1, x2, zfunc)
      
      contour(x1, x2, z, asp = 1)
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

