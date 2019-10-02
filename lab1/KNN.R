euclidDist <- function(u, v) {
  sqrt(sum((u - v)^2))
}

sortObjectsByDist <- function(xl, u) {
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  # формируем матрицу расстояний состоящую из индекса и расстояния евклида из выборки для некоторой точки
  distances <- matrix(NA, l, 2)
  for (i in 1:l) {
    distances[i, ] <- c(i, euclidDist(xl[i, 1:n], u))
  }
  
  # сортируем по расстоянию
  orderedXl <- xl[order(distances[, 2]), ]
  return (orderedXl);
}

KNN <- function(xl, k) {
  n <- dim(xl)[2]
  # Получаем классы первых k соседей
  classes <- xl[1:k, n]
  # Составляем таблицу встречаемости каждого класса
  counts <- table(classes)
  # Находим класс, который доминирует среди первых k соседей
  class <- names(which.max(counts))
  return (class)
}

# график с точкой KNN
knnPlot <- function(k, u) {
  colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue")
  
  plot(iris[, 3:4], pch = 20, bg = colors[iris$Species], col = colors[iris$Species], asp = 1)
  
  class <- KNN(sortObjectsByDist(iris[, 3:5], u), k)
  points(u[1], u[2], pch = 25, bg = colors[class], asp = 1)
}


# loocv
loo <- function(xl, k) {
  l <- dim(xl)[1]
  LOO <- array(0, k)
  K <- array(0, k)
  quality <- array(0, k)
  
  for(i in 1:l) {
    u <- c(xl[i, 1], xl[i, 2])
    
    # берем все элементы из обучающей выборки кроме 1
    x <- sortObjectsByDist(xl[, 1:3][-i, ], u) 
    
    # проверяем KNN алгоритм на контрольном объекте из выборки, который не входит в x
    # правильно ли он классифицируется по своим k ближайшим соседям
    for(j in 1:k) {
      class <- KNN(x, k = j)
      if(class != xl[i, 3]) 
        LOO[j] <- LOO[j] + 1
    }
  }
  
  for (i in 1:k) {
    K[i] <- i
    quality[i] <- LOO[i] / l
  }
  
  looData <- data.frame(K, quality)
  
  # берем k с минимальным числом ошибок
  minK = looData[which.min(looData$quality),]
  
  #looPlot(looData, minK)
  
  return(minK$K)
}

# график для loocv
looPlot <- function(looData, minK) {
  plot(looData, xlab = "K", ylab = "LOO(K)", type = "l")
  points(minK, pch=21, bg="red")
  
  text(minK$K, minK$quality + 0.1 , labels = (paste("min k = ", minK$K)) )
}

classiFicationMap <- function(xl) {
  colors <- c("setosa" = "red", "versicolor" = "green", "virginica" = "blue")
  plot(xl[1:2], pch = 21, col = colors[xl$Species], bg = colors[xl$Species])
  
  for (i in seq(1.0, 7.0, 0.1)) {
    for (j in seq(0.1, 2.5, 0.1)) {
      u <- c(i, j)
      cl <- KNN(sortObjectsByDist(xl, u), 6)
      points(i, j, pch = 21, col = colors[cl])
    }
  }
} 


xl <- iris[, 3:5]

#k <- loo(xl, dim(xl)[1])
#u <- c(3.5, 1)
#knnPlot(k, u)

#classiFicationMap(xl)


