euclidDist <- function(u, v) {
  sqrt(sum((u - v)^2))
}

KNN <- function(xl, u, k) {
  l <- dim(xl)[1]
  twoDataColumns <- dim(xl)[2] - 1
  
  distanceMatrix <- matrix(NA, l, twoDataColumns)
  for (i in 1:l) {
    distanceMatrix[i,] <- c(i, euclidDist(xl[i, 1:twoDataColumns], u))
  }
  # distanceMatrix содержит индекс объекта в xl и расстояние до искомого объекта
  orderXlByDistance <- xl[order(distanceMatrix[, 2]), ]
  # classesсодержит названия классов в отсортированном порядке первых k соседей
  classes <- orderXlByDistance[1:k, twoDataColumns + 1]
  # Считаем все вхождения
  counts <- summary(classes)
  #Достаем название класса (ответ) из ячейки с максимальным вхождением
  answerClass <- names(which.max(counts))
  
  return(answerClass)
}

knnPlot <- function() {
  colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue")
  
  plot(iris[, 3:4], pch = 20, bg = colors[iris$Species], col = colors[iris$Species], asp = 1)

  u <- c(3.5, 0.5)
  
  class <- KNN(iris[, 3:5], u, 6)
  points(u[1], u[2], pch = 25, bg = colors[class], asp = 1)
}

loo <- function(xl, k) {
  l <- dim(xl)[1]
  correctLoo <- array(0, length(k))
  result <- array(NA, length(k))
  
  for (i in 1:l) {
    xi <- c(xl[i, 1], xl[i, 2])
    for (j in seq(k)) {
      result[j] <- KNN(xl[-i,], xi, k) 
    }
    if (result != xl[i, 3]) {
      correctLoo <- correctLoo + 1
    }
  }
  
  View(result)
  View(correctLoo)  
  View(correctLoo/l)
  
  return (correctLoo/l)
}

loo(iris[3:5], 1:5)
