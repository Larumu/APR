clear
load tr.dat;
load trlabels.dat;
load ts.dat;
load tslabels.dat;

t=[0 1 2 3];
c=[0.0001 0.001 0.01 0.1 1 10 100 1000 10000];

[x y] = size(t);
[h x] = size(c);
for i = 1:y
  for j = 1:x
  
    param = ["-q -t " num2str(t(i)) " -c " num2str(c(j))]
    res = svmtrain(trlabels, tr, param);
    newlabels = svmpredict(tslabels, ts, res, '');
    aciertos = 0;
    [col x] = size(tslabels);
    
    for k = 1:col
       if tslabels(k) == newlabels(k)
           aciertos = aciertos+1;
       endif
    endfor
    
    error = (1 - (aciertos/col))*100;
    left = error - (1.96 *sqrt(error*(1-error)/col));
    right =error + (1.96 *sqrt(error*(1-error)/col));
    trustrange = [left,right]  
    
  endfor
endfor

indc = res.sv_indices;
Vec_soport = tr(indc,:)' ;
O = Vec_soport*(res.sv_coef);
soport = Vec_soport(:,1);
umbral = sign(res.sv_coef(1)) - (O'*soport);
margen = 2/(norm(O));
