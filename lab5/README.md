# Линии уровня нормального распределения
Случайная величина <a href="https://www.codecogs.com/eqnedit.php?latex=\mathbf{x}&space;=&space;(x_1,&space;...,&space;x_d)&space;\in&space;\mathbb{R}^d" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\mathbf{x}&space;=&space;(x_1,&space;...,&space;x_d)&space;\in&space;\mathbb{R}^d" title="\mathbf{x} = (x_1, ..., x_d) \in \mathbb{R}^d" /></a>
имеет многомерное нормальное распределение с параметрами <a href="https://www.codecogs.com/eqnedit.php?latex=\mu&space;\in&space;\mathbb{R}^d" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\mu&space;\in&space;\mathbb{R}^d" title="\mu \in \mathbb{R}^d" /></a>
и <a href="https://www.codecogs.com/eqnedit.php?latex=\Sigma&space;\in&space;\mathbb{R}^{d&space;\cdot&space;d}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\Sigma&space;\in&space;\mathbb{R}^{d&space;\cdot&space;d}" title="\Sigma \in \mathbb{R}^{d \cdot d}" /></a>
, если ее плотность задается выражением:
![](https://github.com/alexlapiy/ML0/blob/master/screens/lab5/n_dimen_normilized_gauss.png)
Параметр μ является мат.ожиданием, а Σ — матрицей ковариации нормального распределения. Матрица Σ является симметричной 
и положительно определенной. <br/>

Линии уровня плотности нормального распределения соответствуют линиям уровня квадратичной формы <a href="https://www.codecogs.com/eqnedit.php?latex=(x&space;-&space;\mu)^T&space;\Sigma^{-1}&space;(x&space;-&space;\mu)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?(x&space;-&space;\mu)^T&space;\Sigma^{-1}&space;(x&space;-&space;\mu)" title="(x - \mu)^T \Sigma^{-1} (x - \mu)" /></a> и представляют собой эллипсы. <br/>

Матрица квадратичной формы <a href="https://www.codecogs.com/eqnedit.php?latex=(x&space;-&space;\mu)^T&space;\Sigma^{-1}&space;(x&space;-&space;\mu)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?(x&space;-&space;\mu)^T&space;\Sigma^{-1}&space;(x&space;-&space;\mu)" title="(x - \mu)^T \Sigma^{-1} (x - \mu)" /></a> 
является симметричной и если является положительно определенной, то ковариционная матрица соответствует эллипсам общего вида.

Всего возможно 3 случая :  
1) Если признаки некоррелируемы, то коварициаонаая матрица является диагональной и ее линии уровня
имеют форму эллипсоидов с центром в μ, оси которых паралелльны системе координат.
2) Если признаки имеют одинаковые дисперсии, то линиями уровня представляют из себя сферу.
3) Если признаки коррелируемы, то ковариционная матрица не диагональна и ее линии уровня 
имеют форму эллипсоидов, оси которых повернуты вдоль собсвенных векторов ковариционной
матрицы.

Ссылка на shiny - https://alexlapiy.shinyapps.io/lab5/
