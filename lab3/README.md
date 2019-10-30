# Метод потенциальных функций
Метод потенциальных функций является модификацией метода парзеновского окна. В отличии от парзеновского окна, где ядро **K**
помещается в классифицируемый объект **u**, в методе потенциальных функций ядро помещается в каждый обучающий объект 
**x<sub>i</sub>**
Алгоритм использует следующую формулу - <img src="https://github.com/alexlapiy/ML0/blob/master/screens/lab3/potential_func_formula.png" width="600" height="70">

_K_ - заданная, убывающая с ростом аргумента, функция; ядро;  
_p_ - расстояние от u до _i_-го ближайшего объекта;  
_h_ - ширина окна для потенциала, которая может зависить от обучающего объекта **x<sub>i</sub>**;  
![](https://latex.codecogs.com/gif.latex?%5Cgamma) - "заряд", степень важность объекта выборки при классификации.

### Распределение потенциалов и карта классификации для прямоугольника ядра, допустимая ошибка - 5

<img src="https://github.com/alexlapiy/ML0/blob/master/screens/lab3/potential_rect_classification_visualisation.png" width="1200" height="400">

### Распределение потенциалов и карта классификации для гауссова ядра, допустимая ошибка - 5

<img src="https://github.com/alexlapiy/ML0/blob/master/screens/lab3/potential_gauss_classification_visualisation.jpg" width="1200" height="400">
