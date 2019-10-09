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

KWNN <- function(xl, u, k, q) {
  n <- dim(xl)[2]
  orderedXl <- sortObjectsByDist(xl, u)
  
  classes <- orderedXl[1:k, n]
  counts <- table(orderedXl[0, 3])
  
 # View(classes)
  
  for(i in 1:k) {
    w <- q^i
    counts[classes[i]] <- counts[classes[i]] + w
  }
  
  #View(counts)
  
  class <- names(which.max(counts))
  return(class)
}

kwnnPlot <- function(xl, u, k, q) {
  colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue")
  
  plot(iris[, 3:4], pch = 20, bg = colors[iris$Species], col = colors[iris$Species], asp = 1)
  
  class <- KWNN(xl, u, k, q)
  points(u[1], u[2], pch = 25, bg = colors[class], asp = 1)
}

classiFicationMap <- function(xl) {
  colors <- c("setosa" = "red", "versicolor" = "green", "virginica" = "blue")
  plot(xl[1:2], pch = 21, col = colors[xl$Species], bg = colors[xl$Species])
  
  for (i in seq(1.0, 7.0, 0.1)) {
    for (j in seq(0.1, 2.5, 0.1)) {
      u <- c(i, j)
      cl <- KWNN(xl, u, 6, 0.5)
      points(i, j, pch = 21, col = colors[cl])
    }
  }
} 

# Приведение примера о преимуществе kwNN над kNN
dominatingExample <- function(xl, u) {
  colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue")
  
  sampleData <- rbind(xl[2:3, 1:3], xl[51:58, 1:3])
  
  plot(sampleData[1:2], pch = 21, bg = colors[sampleData$Species], col = colors[sampleData$Species])
  
  class <- KWNN(sampleData, u, 6, 0.5)
  points(u[1], u[2], pch = 25, bg = colors[class], asp = 1)
}

xl <- iris[, 3:5]
u <- c(1.5, 0.6)
k <- 6
q <- 0.5

#kwnnPlot(xl, u, k, q)

#classiFicationMap(xl)
dominatingExample(xl, u)
