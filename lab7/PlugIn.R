## Подключаем библиотеку MASS для генерации многомерного нормального распределения 
library(MASS) 
library(shiny)

ui <- fluidPage(
  titlePanel("Plug-in алгоритм"),
  sidebarLayout(
    sidebarPanel(
     
      sliderInput(
        inputId = "n",
        label = "Количество элементов",
        min = 100,
        max = 400,
        value = 200,
        step = 50
      ), 
      sliderInput(
        inputId = "mu1x",
        label = "Отклонение по X для 1го класса",
        min = -10,
        max = 10,
        value = -5,
        step = 1
      ),
      sliderInput(
        inputId = "mu1y",
        label = "Отклонение по Y для 1го класса",
        min = -10,
        max = 10,
        value = 3,
        step = 1
      ),
      sliderInput(
        inputId = "sigma11_class1",
        label = "Sigma[1, 1] 1го класса",
        min = 1,
        max = 30,
        value = 3,
        step = 1
      ),
      sliderInput(
        inputId = "sigma22_class1",
        label = "Sigma[2, 2] для 1го класса",
        min = 1,
        max = 30,
        value = 1,
        step = 1
      ),
      
      sliderInput(
        inputId = "mu2x",
        label = "Отклонение по X для 2го класса",
        min = -10,
        max = 10,
        value = 10,
        step = 1
      ),
      sliderInput(
        inputId = "mu2y",
        label = "Отклонение по Y для 2го класса",
        min = -10,
        max = 10,
        value = 2,
        step = 1
      ),
      sliderInput(
        inputId = "sigma11_class2",
        label = "Sigma[1, 1] 2го класса",
        min = 1,
        max = 30,
        value = 10,
        step = 1
      ),
      sliderInput(
        inputId = "sigma22_class2",
        label = "Sigma[2, 2] для 2го класса",
        min = 1,
        max = 30,
        value = 15,
        step = 1
      )
    ),
    mainPanel(
      textOutput(outputId = "error"),
      plotOutput("plot", width = 600, height = 600)
    )
  )  
)

# Восстановление мат. ожидания
estimateMu <- function(objects) {     
  ## mu = 1 / m  *  sum_{i=1}^m(objects_i)     
  rows <- dim(objects)[1]     
  cols <- dim(objects)[2]          
  mu <- matrix(NA, 1, cols)     
  for (col in 1:cols)      {         
    mu[1, col] <- mean(objects[, col])     
  }          
  return(mu) 
} 

#  Восстановление ковариационной матрицы
estimateSigma <- function(objects, mu) {     
  rows <- dim(objects)[1]     
  cols <- dim(objects)[2]     
  sigma <- matrix(0, cols, cols)          
  for (i in 1:rows)     {         
    sigma <- sigma + (t(objects[i, ] - mu) %*% (objects[i, ] - mu)) / (rows - 1)     
  }          
  return (sigma) 
} 

# Получение коэффициентов подстановочного алгоритма 
getPlugInDiskriminantCoeffs <- function(mu1, sigma1, mu2, sigma2)  {     
  # функция линнии: a*x1^2 + b*x1*x2 + c*x2 + d*x1 + e*x2 + f = 0     
  invSigma1 <- solve(sigma1) 
  invSigma2 <- solve(sigma2) 
  
  f <- log(abs(det(sigma1))) - log(abs(det(sigma2))) + mu1 %*% invSigma1 %*% t(mu1) - mu2 %*% invSigma2 %*% t(mu2);          
  alpha <- invSigma1 - invSigma2     
  a <- alpha[1, 1]     
  b <- 2 * alpha[1, 2]     
  c <- alpha[2, 2]         
  beta <- invSigma1 %*% t(mu1) - invSigma2 %*% t(mu2)      
  d <- -2 * beta[1, 1]    
  e <- -2 * beta[2, 1] 
  return (c("x^2" = a, "xy" = b, "y^2" = c, "x" = d, "y" = e, "1" = f)) 
} 

server <- function(input, output) {
  output$plot <- renderPlot({
    ## Количество объектов в каждом классе 
    objectsCountOfEachClass <- input$n
    
    ## Генерируем тестовые данные 
    sigma1 <- matrix(c(input$sigma11_class1, 0, 0, input$sigma22_class1), 2, 2) 
    sigma2 <- matrix(c(input$sigma11_class2, 0, 0, input$sigma22_class2), 2, 2) 
    mu1 <- c(input$mu1x, input$mu1y) 
    mu2 <- c(input$mu2x, input$mu2y) 
    
    xy1 <- mvrnorm(n = objectsCountOfEachClass, mu1, sigma1) 
    xy2 <- mvrnorm(n = objectsCountOfEachClass, mu2, sigma2) 
    
    ## Собираем два класса в одну выборку 
    xl <- rbind(cbind(xy1, 1), cbind(xy2, 2)) 
    
    ## Рисуем обучающую выборку  
    colors <- c("red", "blue") 
    plot(xl[,1], xl[,2], pch = 21, bg = colors[xl[,3]], asp = 1, xlab = "X", ylab = "Y", main = "Подстановочный алгоритм(Plug-in)") 
    
    ## Оценивание 
    objectsOfFirstClass <- xl[xl[,3] == 1, 1:2] 
    objectsOfSecondClass <- xl[xl[,3] == 2, 1:2] 
    
    mu1 <- estimateMu(objectsOfFirstClass) 
    mu2 <- estimateMu(objectsOfSecondClass) 
    
    sigma1 <- estimateSigma(objectsOfFirstClass, mu1) 
    sigma2 <- estimateSigma(objectsOfSecondClass, mu2) 
    
    coeffs <- getPlugInDiskriminantCoeffs(mu1, sigma1, mu2, sigma2) 
    
    ## Рисуем дискриминантую функцию – красная линия 
    x <- y <- seq(-10, 20, len = 100)  
    z <- outer(x, y, function(x, y) coeffs["x^2"] * x^2 + coeffs["xy"] * x * y + coeffs["y^2"] * y^2 + coeffs["x"] * x + coeffs["y"] * y + coeffs["1"])  
    contour(x, y, z, levels = 0, drawlabels = FALSE, lwd = 3, col = "red", add = TRUE)   
  })
 
}

shinyApp(ui, server)