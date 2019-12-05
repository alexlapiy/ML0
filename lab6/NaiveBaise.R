library(shiny)

ui <- fluidPage(
  titlePanel("Наивный Байесовский классификатор"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("feature1", "Первый признак:",
                   choices = list("Sepal.Length" = 1, 
                                  "Sepal.Width" = 2, 
                                  "Petal.Length" = 3, 
                                  "Petal.Width" = 4), selected = 1),
      radioButtons("feature2", "Второй признак:",
                   choices = list("Sepal.Length" = 1, 
                                  "Sepal.Width" = 2, 
                                  "Petal.Length" = 3, 
                                  "Petal.Width" = 4), selected = 2)
    ),
    mainPanel(
      HTML("<center><h1><b>Карта классификации</b></h1>"),
      textOutput(outputId = "error"),
      plotOutput("plot", width = 500, height = 500)
    )
  )  
)

server <- function(input, output) {
  output$plot <- renderPlot({
    feature1 <- as.numeric(input$feature1)
    feature2 <- as.numeric(input$feature2)
    
    N <- c(feature1, feature2) #вектор признаков
    xl <- iris[, append(N, 5)] #добавляем ответы в обучающую выборку
    n <- length(N) #число признаков
    
    y <- dim(xl)[2]
    classes <- levels(xl[, y])
    numberOfClasses <- length(classes)
    Py <- table(xl[, y]) / dim(xl)[1] #эмпирические оценки априорных вероятностей для каждого класса
    
    #матрица мат. ожидания
    mu <- matrix(0, nrow = numberOfClasses, ncol = n)
    
    #матрица среднеквадратичных отклонений
    sigma <- matrix(0, nrow = numberOfClasses, ncol = n)
    
    for(i in 1:numberOfClasses) {
      for(j in 1:n) {
        temp <- xl[xl[, y] == classes[i], ][, j] #j-й столбец содержащий только признаки i-го класса
        mu[i, j] <- mean(temp)
        sigma[i, j] <- sqrt(var(temp))
      }
    }
    
    #Нормальнвя плотность распределения
    noramalDensity <- function(x, mu, sigma) {
      1 / sqrt(2 * pi) / sigma * exp(-1/2 * (x - mu)^2 / sigma^2)
    }
    
    #Наивный Байесовский классификатор
    naiveBayes <- function(x, classes, Py, mu, sigma) {
      N <- length(classes) #количество классов
      n <- dim(mu)[2] #количество признаков
      scores <- rep(0, N) #вектор плотностей
      for (i in 1:N) {
        scores[i] <- Py[i]
        for (j in 1:n) { #произведение вероятности класса на плотности признаков
          scores[i] <- scores[i] * noramalDensity(x[j], mu[i,j], sigma[i,j])
        }
      }
      which.max(scores) #порядковый номер максимальной вероятности
    }
    
    #процент ошибки классификации
    l <- dim(xl)[1]
    error <- 0.0
    for(i in 1:l){
      error <- error + 100 * (xl[, y][i] != classes[a(c(xl[, 1][i], xl[, 2][i]), classes, Py, mu, sigma)]) / l
    }
    
    colors = c("red", "green", "blue")

    plot(xl[, 1], xl[, 2], col = colors[xl[, y]], xlab = "", ylab = "", pch = 20)
      
    x1_min <- min(xl[, 1]) - 0.1
    x1_max <- max(xl[, 1]) + 0.1
    x2_min <- min(xl[, 2]) - 0.1
    x2_max <- max(xl[, 2]) + 0.1
    
    x1 <- x1_min
    while(x1 < x1_max) {
      x2 <- x2_min
      while(x2 < x2_max) {
        points(x1, x2, col = colors[naiveBayes(c(x1, x2), classes, Py, mu, sigma)], pch = 1)
        x2 <- x2 + 0.1
      }
      x1 <- x1 + 0.1
    }
    
    output$error = renderText({
      paste("Величина ошибки: ", round(error, digits = 3), "%")
    })
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)