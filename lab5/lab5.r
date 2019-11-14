library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("x1",
                  "Значение x1:",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 1),
      sliderInput("x2",
                  "Значение x2:",
                  min = 0,
                  max = 5,
                  value = 1,
                  step = 1         
      ),
      sliderInput("mu",
                  "Значение μ:",
                  min = 0,
                  max = 5,
                  value = 0,
                  step = 1),
      
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
    x1 <- input$x1
    x2 <- input$x2
    mu <- input$mu
    sigma <- matrix(c(x1, 0, 0, x2), 2, 2)
    View(sigma)
    if (det(sigma) <= 0) {
      output$error <- renderText({"Определитель меньше или равен 0"})
    } else {
      output$error <- renderText({""})
      
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

