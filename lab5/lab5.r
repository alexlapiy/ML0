library(shiny)

ui <- fluidPage(
  titlePanel("Коэффициенты ковариционной матрицы"),
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
      textOutput(outputId = "formula"),
      plotOutput("plot", height = 550)
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
    detSigma <- det(sigma)
    
    output$sigmaMess1 = renderText({
      paste(sigma[1,1],sigma[1,2],sep=" ")
    })
    
    output$sigmaMess2 = renderText({
      paste(sigma[2,1],sigma[2,2],sep=" ")
    })
    
    output$detSigma = renderText({
      paste("Определитель ", detSigma)
    })
    
    if (detSigma <= 0) {
      output$error <- renderText({"Определитель меньше или равен 0, кривая второго порядка параболического или гиперболического типа"})
    } else {
      output$error <- renderText({"Определитель больше 0, кривая второго порядка эллиптического типа"})
      
      a <- sigma[1, 1]
      b <- sigma[1, 2]
      c <- sigma[2, 1]
      d <- sigma[2, 2]
      A <- d / detSigma
      B <- (-b - c) / detSigma
      C <- a / detSigma
      D <- (-2 * d * mu[1, 1] + b * mu[1, 2] + c * mu[1, 2]) / detSigma
      E <- (b * mu[1, 1] + c * mu[1, 1] - 2 * a * mu[1, 2]) / detSigma
      f <- (d * mu[1, 1] * mu[1, 1] - b * mu[1, 1] * mu[1, 2] - c * mu[1, 1] * mu[1, 2] + a * mu[1, 2] * mu[1, 2]) / detSigma
      
      zfunc <- function(x, y) {
        1 / sqrt(2 * pi * d) * exp(-0.5 * (A * x * x + B * y *x + C * y * y + D * x + E * y + f))
      }
      
      radius <- 3
      minX <- -sigma[1, 1] - radius
      maxX <- sigma[1, 1] + radius
      minY <- -sigma[2, 2] - radius
      maxY <- sigma[2, 2] + radius
      
      x <- seq(minX, maxX, len=150)
      y <- seq(minY, maxY, len=150)
      z <- outer(x, y, zfunc)
      
      contour(x, y, z, asp = 1)
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

