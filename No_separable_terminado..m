clear
load data/mini/tr.dat;
load data/mini/trlabels.dat;

#entrenamiento de un SVM lineal sin kernel no separable
res = svmtrain(trlabels, tr, '-t 0 -c 1000');

# a) multiplicadores de Lagrange
mult = res.sv_coef;
# b) indices de los vectores soporte
indc = res.sv_indices;
# vectores soporte columnas
Vec_soport = tr(indc,:)' ;
# c) vector de pesos (sumatorio de multiplicar cada vector soporte por su alfa correspondiente)
O = Vec_soport*mult
# vector soporte arbitrario
soport = Vec_soport(:,1);
# signo de su alfa asociado (clase +-1)
signo = sign(mult(1));
umbral = signo - (O'*soport);
# d) margen optimo es igual a 2 / modulo vector de pesos
margen = 2/(norm(O));

# frontera lineal de la recta de separación y margenes
	recta=0:1:7;
	Sup=-recta*O(1)/O(2) - (umbral+1)/O(2);
	cent=-(O(1)/O(2))*recta-(umbral/O(2));
	Inf=-recta*O(1)/O(2) - (umbral-1)/O(2);
  
  #calculo de la seta
  v = [];
  plotmas = [];
  plotcruz = [];
  for i = 1:size(res.sv_indices)
    sig= sign(res.sv_coef(i));
    seta = 1 - sig*((tr(res.sv_indices(i),:)*O)+umbral);
    if int32(seta) == 0;
      v(i) = 0;
    plotmas = vertcat(plotmas,[tr(res.sv_indices(i),:)]);
    else
    v(i) = seta;
    plotcruz = vertcat(plotcruz,[tr(res.sv_indices(i),:)]);
    endif
  endfor 

 	plot(
	tr(trlabels==1,1),tr(trlabels==1,2),"s",
	tr(trlabels==2,1),tr(trlabels==2,2),"o",
  plotmas(:,1),plotmas(:,2),"+k",
  plotcruz(:,1),plotcruz(:,2),"xk",
	recta,Sup,"g",recta,cent,"k",recta,Inf,"g")
	axis([0,7,0,7])
  title('  + -> vect soport correctos   x -> vec soport fallo c=1000 ')
  xlabel('Eje_x')
  ylabel('Eje_y')

