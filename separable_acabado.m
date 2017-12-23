clear
#primero hay que cambiar el nombre de los sep que les falta el set en el archivo
load data/mini/trSep.dat;
load data/mini/trSeplabels.dat;

#EJERCICIO 1:
#entrenamiento de un SVM lineal sin kernel 
res = svmtrain(trSeplabels, trSep, '-t 0 -c 1000');

#EJERCICIO 2:
# a) multiplicadores de Lagrange
mult = res.sv_coef;
# b) indices de los vectores soporte
indc = res.sv_indices;
# vectores soporte columnas
Vec_soport = trSep(indc,:)' ;
# c) vector de pesos (sumatorio de multiplicar cada vector soporte por su alfa correspondiente)
O = Vec_soport*mult
# vector soporte arbitrario
soport = Vec_soport(:,1);
# signo de su alfa asociado (clase +-1)
signo = sign(mult(1));
umbral = signo - (O'*soport);
# d) margen optimo es igual a 2 / modulo vector de pesos
margen = 2/(norm(O));

#EJERCICIO 3:
# frontera lineal de la recta de separación
	recta=0:1:7; 
	cent=-(O(1)/O(2))*recta-(umbral/O(2));
  
#EJERCICIO 4:
	plot(
	trSep(trSeplabels==1,1),trSep(trSeplabels==1,2),"s",
	trSep(trSeplabels==2,1),trSep(trSeplabels==2,2),"o",
  Vec_soport'(:,1),Vec_soport'(:,2),"+k",
	recta,cent,"g")
	axis([0,7,0,7])
  title('cuadrados y circulos = clases    simbolo + = vectores soporte')
  xlabel('Eje X')
  ylabel('Eje Y')


