euclidDistance <- function (x1,y1,x2,y2){
  return(sqrt((x2-x1)^2+(y2-y1)^2)) 
}
nn <- function(xl, u){
  l <- dim(xl)[1]
  n <- dim(xl)[2] - 1
  
  dist <- array(l)
  for (i in 1:l){
    dist[i] = euclidDistance(xl[i,1],xl[i,2],u[1],u[2]) 
  } 
  minXl  <- which.min(dist)
  return (xl[minXl, ])
}   


colors <- c("setosa" = "red", "versicolor" = "green3", "virginica" = "blue")
## Для одной точки
#u <- c(2, 0.5)
#class <-nn(iris[, 3:5], u)
#plot(iris[, 3:4], pch = 20, bg = colors[iris$Species], col = colors[iris$Species], asp = 1)
#points(u[1], u[2], pch = 22, bg = colors[class[1,3]], asp = 1)

# Для n точек
plot(iris[, 3:4], pch = 20, bg = colors[iris$Species], col = colors[iris$Species], asp = 1)

## Делаем n случайных точек
makeNRandomDots <- function(n) {
  randomY <- runif(n, 0, 2.5)
  randomX <- runif(n, 0, 7)
  
  for (i in 1:n) {
    u <- c(randomX[i], randomY[i])
    xl <- iris[, 3:5]
    class <- nn(xl, u)
    points(u[1], u[2], pch = 22, bg = colors[class[1,3]], asp = 1)
  }
}

makeNRandomDots(10)