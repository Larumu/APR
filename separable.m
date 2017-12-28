clear
load trSep.dat;
load trSeplabels.dat;

#1; Entrenamiento de un SVM lineal sin kernel 
res = svmtrain(trSeplabels, trSep, '-t 0 -c 1000');

# 2a: Multiplicadores de Lagrange
mult = res.sv_coef;
# 2b: Vectores soporte
indc = res.sv_indices;
Vec_soport = trSep(indc,:)' ;
# 2c: vector de pesos
O = Vec_soport*mult
soport = Vec_soport(:,1);
signo = sign(mult(1));
umbral = signo - (O'*soport);
# 2d: margen 
margen = 2/(norm(O));

# 3: Frontera lineal de la recta de separación
recta=0:1:8; 
cent=-(O(1)/O(2))*recta-(umbral/O(2));
  
# 4: Gráfico de los resultados
plot(
trSep(trSeplabels==1,1),trSep(trSeplabels==1,2),"s",
trSep(trSeplabels==2,1),trSep(trSeplabels==2,2),"o",
Vec_soport'(:,1),Vec_soport'(:,2),"+k",recta,cent,"g")
axis([0,8,0,8])
xlabel('Eje X')
ylabel('Eje Y')
