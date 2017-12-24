clear
load tr.dat;
load trlabels.dat;

#1: SVM lineal sin kernel
res = svmtrain(trlabels, tr, '-t 0 -c 1000');

# a) Multiplicadores de Lagrange
mult = res.sv_coef;
# b) Vectores soporte
indc = res.sv_indices;
Vec_soport = tr(indc,:)' ;
# c) vector de pesos y umbral de la función discriminante lineal
O = Vec_soport*mult
soport = Vec_soport(:,1);
signo = sign(mult(1));
umbral = signo - (O'*soport);
# d) margen correspondiente
margen = 2/(norm(O));

#3. Frontera lineal de la recta de separación y márgenes asociados
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
