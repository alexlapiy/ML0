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
  return (orderedXl <- cbind(orderedXl, euclidDist = sort(distances[, 2], decreasing = FALSE)))
}

# Прямоугольное ядро
rect_kernel <- function(r, h) {
  if(abs(r / h) <= 1) {
    return (1 / 2)
  } else {
    return(0)
  }
}

parzenWindow <- function(xl, u, h, kernelFunc) {
  n <- dim(xl)[2] - 1
  l <- dim(xl)[1]
  orderedXl <- sortObjectsByDist(xl, u)
  View(orderedXl)
  classes <- orderedXl[1:l, n]
  
  counts <- table(orderedXl[0, 3])
  
  for (i in seq(1:l)) {
    counts[classes[i]] <- counts[classes[i]] + kernelFunc(orderedXl[i, 4], h)
  }
  
  View(counts)
  
  class <- names(which.max(counts))
  return(class)
}

xl <-iris[, 3:5]
u <- c(1, 2)
h <- 3

print(parzenWindow(xl, u, h, rect_kernel))



