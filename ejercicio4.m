clear
load data/spam/tr.dat;
load data/spam/trlabels.dat;
load data/spam/ts.dat;
load data/spam/tslabels.dat;

%t=[0 1 2 3];
%c=[0.00001 0.001 0.01 0.1 1 10 100 1000];

t=0;
c=1000;
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
    error = 1 - (aciertos/col);
    error*100
    trustrangeleft = (error - (1.96 *sqrt(error*(1-error)/col)))*100;
    trustrangeright = (error + (1.96 *sqrt(error*(1-error)/col)))*100;
    trustrange = [trustrangeleft,trustrangeright]  
  endfor
endfor
indc = res.sv_indices;
Vec_soport = tr(indc,:)' ;
O = Vec_soport*(res.sv_coef);
soport = Vec_soport(:,1);
umbral = sign(res.sv_coef(1)) - (O'*soport);
margen = 2/(norm(O));



  xr = reshape(ts,16,16);
  imshow(xr',[]);

 