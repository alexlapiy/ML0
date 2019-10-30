require("plotrix")

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
  
  return (orderedXl <- cbind(xl, euclidDist = distances[, 2]))
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

potentialFunc <- function(xl, u, gammaVar, h, kernelFunc) {
  l <- dim(xl)[1]
  dataXl <- sortObjectsByDist(xl, u)
  n <- dim(dataXl)[2] - 1
  classes <- dataXl[1:l, n]
  counts <- table(dataXl[0, 3])
  
  for (i in 1:l) {
    counts[classes[i]] <- counts[classes[i]] + (gammaVar[i] * kernelFunc(dataXl[i, 4], h))
  }
  
  if(sum(counts) > 0) {
    class <- names(which.max(counts))
  } else {
    class <- "noClass"
  } 
  
  return(class)
}

getError <- function(xl, gammaVar, h, kernelFunc) {
  error <- 0
  l <- dim(xl)[1]
  n <- dim(xl)[2]
  for (i in 1:l) {
    u <- xl[i, 1:n-1]
    class <- potentialFunc(xl, u, gammaVar, h, kernelFunc)
    if (class != xl[i, n]) {
      error <- error + 1
    }
  }
  cat("error: ", error, "\n")
  return(error)
}

getGamma <- function(xl, h, kernelFunc, eps) {
  l <- dim(xl)[1]
  n <- dim(xl)[2]
  gammaVar <- rep(0, l)
  i <- 1
  while(getError(xl, gammaVar, h, kernelFunc) > eps) {
    u <- xl[i, 1:n-1]
    class <- potentialFunc(xl, u, gammaVar, h, kernelFunc)
    if (class != xl[i, n]) {
      gammaVar[i] <- gammaVar[i] + 1
    }
    i <- sample(seq(l), 1)
    cat("i: ", i, "\n")
  }
  return(gammaVar)
}

potentialFuncPlot <- function(xl, gammaVar, h) {
  colors <- c("setosa" = "red", "versicolor" = "green", "virginica" = "blue")
  plot(xl[1:2], pch = 21, col = colors[xl$Species], bg = colors[xl$Species])
  
  m <- max(gammaVar)
  for (i in seq(length(gammaVar))) {
    coords <- xl[i, ]
    if (gammaVar[i] > 0) {
      c <- adjustcolor(colors[coords$Species], gammaVar[i] / m * 0.3)
      draw.circle(coords[, 1], coords[, 2], h, col = c, border = "black")
    }
  }
  
  points(xl[1:2], pch = 21, col = colors[xl$Species], bg = colors[xl$Species])
}

potentialFuncClassificationMap <- function(xl, gammaVar, h, kernelFunc) {
  colors <- c("setosa" = "red", "versicolor" = "green", "virginica" = "blue", 
              "noClass" = "white")
  plot(xl[1:2], pch = 21, col = colors[xl$Species], bg = colors[xl$Species])
  
  for (i in seq(1.0, 7.0, 0.1)) {
    for (j in seq(0.1, 2.5, 0.1)) {
      u <- c(i, j)
      class <- potentialFunc(xl, u, gammaVar, h, kernelFunc)
      points(i, j, pch = 21, col = colors[class])
    }
  }
}

xl <- iris
#xl <- rbind(iris[6:30,], iris[61:85,], iris[126:150,])
l <- dim(xl)[1]
h <- 0.6
gammaVar <- getGamma(xl[3:5], h, gauss_kernel, 5)
#potentialFuncPlot(xl[3:5], gammaVar, h)
potentialFuncClassificationMap(xl[3:5], gammaVar, h, rect_kernel)
