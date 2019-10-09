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
rect_kernel <- function(dist, h) {
  if(abs(dist / h) <= 1) {
    return (1 / 2)
  } else {
    return(0)
  }
}

# Епанечникова ядро
epanech_kernel <- function(dist, h) {
  if(abs(dist / h) <= 1) {
    return(3 / 4 * (1 - (dist / h)^2))
  } else {
    return(0)
  }
}

# Квартическое ядро
quartic_kernel <- function(dist, h) {
  if(abs(dist / h) <= 1) {
    return(15 / 16 * (1 - (dist / h)^2)^2)
  } else {
    return(0)
  }
}

# Треугольное ядро
triang_kernel <- function(dist, h) {
  if(abs(dist / h) <= 1) {
    return(1 - abs(dist / h))
  } else {
    return(0)
  }
}

# Гауссовское ядро
gauss_kernel <- function(dist, h) {
  (2*pi)^(1/2) * exp((-1/2) * (dist / h)^2)
}

parzenWindow <- function(xl, u, h, kernelFunc) {
  l <- dim(xl)[1]
  orderedXl <- sortObjectsByDist(xl, u)
  n <- dim(orderedXl)[2] - 1
  classes <- orderedXl[1:l, n]
  
  counts <- table(orderedXl[0, 3])
  
  for (i in seq(1:l)) {
    counts[classes[i]] <- counts[classes[i]] + kernelFunc(orderedXl[i, 4], h)
  }
  
  class <- names(which.max(counts))
  return(class)
}

loo <- function(xl, seqH, kernelFunc) {
  l <- dim(xl)[1]
  hLooArray <- array(0, length(seqH))
  j <- 1
  for(h in seqH) {
    cnt <- 0
    for(i in 1:l) {
      u <- c(xl[i, 1], xl[i, 2])
      x <- xl[-i, 1:3]
      class <- parzenWindow(x, u, h, kernelFunc)
      
      if(xl[i, 3] != class) {
        cnt <- cnt + 1
      }
    }
    hLooArray[j] <- cnt / l
    j <- j + 1
    print(j)
  }
  View(hLooArray)
  return(hLooArray)
}

parzenPlot <- function(xl, u, h, kernelFunc) {
  colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue")
  
  plot(iris[, 3:4], pch = 20, bg = colors[iris$Species], col = colors[iris$Species], asp = 1)
  
  class <- parzenWindow(xl, u, h, kernelFunc)
  points(u[1], u[2], pch = 25, bg = colors[class], asp = 1)
}

looPlot <- function(seqH, looData) {
  plot(seqH, looData, xlab = "h", ylab = "LOO(h)", type = "l")
  
  looDataFrame <- data.frame(seqH, looData)
  minH <- looDataFrame[which.min(looDataFrame$looData),]
  print(minH)
  points(minH, pch=21, bg="red")
}

classificationMap <- function(xl, h, kernelFunc) {
  colors <- c("setosa" = "red", "versicolor" = "green", "virginica" = "blue")
  plot(xl[1:2], pch = 21, col = colors[xl$Species], bg = colors[xl$Species])
  
  for (i in seq(1.0, 7.0, 0.1)) {
    for (j in seq(0.1, 2.5, 0.1)) {
      u <- c(i, j)
      class <- parzenWindow(xl, u, h, kernelFunc)
      points(i, j, pch = 21, col = colors[class])
    }
  }
}

#xl <-iris[sample(1:150, 30, replace=FALSE), 3:5]
xl <- iris[, 3:5]
#u <- c(5, 2)
#h <- 0.5
seqH <- seq(0.5, 5, 0.1)

#parzenPlot(xl, u, h, rect_kernel)

#looRectKernel <- loo(xl, seqH, rect_kernel)
#looEpanechKernel <- loo(xl, seqH, epanech_kernel)
#looQuarticKernel <- loo(xl, seqH, quartic_kernel)
#looTriangKernel <- loo(xl, seqH, triang_kernel)
#looGaussKernel <- loo(xl, seqH, gauss_kernel)

# График LOO
#looPlot(seqH, looGaussKernel)

#Карта классификации
classificationMap(xl, 0.1, gauss_kernel)












