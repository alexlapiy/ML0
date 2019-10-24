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
    w <- gammaVar[i] * kernelFunc(dataXl[i, 4], h)
    counts[classes[i]] <- counts[classes[i]] + w
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
  cat("err: ", error, "\n")
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

potentialFuncPlot <- function(xl, g, h) {
  colors <- c("setosa" = "red", "versicolor" = "green", "virginica" = "blue")
  plot(xl[1:2], pch = 21, col = colors[xl$Species], bg = colors[xl$Species], main="Карта классификации")
  
  # draw potential circles
  coef <- 0.2
  m <- max(g)
  for (i in seq(length(g))) {
    e <- xl[i,]
    if (g[i] < 1) {
      next
    }
    c <- adjustcolor(colors[e$Species], g[i] / m * coef)
    draw.circle(e[,1], e[,2], h[i], col = c, border = c)
  }
  
  
  #points(dat[1:2], pch = 21, col = colors[dat$Species], bg = colors[dat$Species], main=title)
  points(xl[1:2], pch = 21, col = "black", bg = colors[xl$Species], main=title)
}

xl <- iris[, 3:5]
l <- dim(xl)[1]
#h <- c(rep(1, ld/3), rep(0.25, (ld-ld/3)))
h <- 1

g <- getGamma(xl, h, rect_kernel, 8)
View(g)
potentialFuncPlot(xl, g, h)


