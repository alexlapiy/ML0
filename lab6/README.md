Наивный байесовский алгоритм - алгоритм классификации, основанный на принципе максимума апостериорной вероятности. 
Для классифицируемого объекта вычисляются функции правдоподобия каждого из классов, по ним вычисляются апостериорные
вероятности классов. Объект относится к тому классу, для которого апостериорная вероятность максимальна. 
Наивным его делает то, что каждый объект описывается независимыми признаками, что бывает не очень часто. 
Оптимальная формула байесовского классификатора выглядит следующим образом:
<a href="https://www.codecogs.com/eqnedit.php?latex=arg&space;\underset{y&space;\in&space;Y}{\mathrm{max}}(\lambda_y&space;\rho_y&space;\prod_{i&space;=&space;1}^n&space;P_{y_i}&space;(f_i))" target="_blank"><img src="https://latex.codecogs.com/gif.latex?arg&space;\underset{y&space;\in&space;Y}{\mathrm{max}}(\lambda_y&space;\rho_y&space;\prod_{i&space;=&space;1}^n&space;P_{y_i}&space;(f_i))" title="arg \underset{y \in Y}{\mathrm{max}}(\lambda_y \rho_y \prod_{i = 1}^n P_{y_i} (f_i))" /></a>

Где <a href="https://www.codecogs.com/eqnedit.php?latex=\rho_y" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\rho_y" title="\rho_y" /></a> априорная вероятность,
<a href="https://www.codecogs.com/eqnedit.php?latex=P_{y_i}&space;(f_i)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?P_{y_i}&space;(f_i)" title="P_{y_i} (f_i)" /></a>
\- п  плотность распределения __i__ признака, <a href="https://www.codecogs.com/eqnedit.php?latex=\lambda_y" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\lambda_y" title="\lambda_y" /></a>
\- цена ошибки за отнесение объекта класса __y__ к какому-либо другому классу.

Для вычисления плотности распределения можно воспользоваться гауссовским нормальным распределением.
