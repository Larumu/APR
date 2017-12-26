function [error] = p3(datos,etiquetas,datosTest,etiquetasTest,gauss)
warning off all

%Datos de entrenamiento

tr_dat = load(datos,'-ascii');

trlabel = load(etiquetas,'-ascii');
tr_data = zscore(tr_dat);
[numVec dim] = size(tr_data);
numClas = max(trlabel)
etiqApr = trlabel + 1;

%Datos de test

tr_dat_test = load(datosTest,'-ascii');

tr_label_test = load(etiquetasTest,'-ascii');
tr_data_test = zscore(tr_dat_test);
etiqTest = tr_label_test + 1;

%Número de gaussianas por mixtura
gaussianas = arglist{5};

grafo = [0 1 1; 0 0 1;0 0 0];
numNodos = length(grafo);
tallaNodos = [numClas numGaus dim];
nodosDiscretos = [1 2];
seed = 0;
rand('state',seed);
redB = mk_bnet(grafo,tallaNodos,'discrete',nodosDiscretos);
redB.CPD{1} = tabular_CPD(redB,1);
redB.CPD{2} = tabular_CPD(redB,2);
redB.CPD{3} = gaussian_CPD(redB,3,'cov_type','diag');

tr_datos = cell(numNodos,numVec);
tr_datos(numNodos,:)= num2cell(tr_data',1);
tr_datos(1,:)=num2cell(etiqApr',1);
motor = jtree_inf_engine(redB);
maxIter = 16;
epsilon = 1e-20;
[redB2,l1,motor2]=learn_params_em(motor,tr_datos,maxIter,epsilon);

p = zeros(length(tr_data_test),numClas);
evidencia = cell(numNodos,1);
for i =1:length(tr_data_test)
	evidencia{numNodos} = tr_data_test(i,:)';
	[motor3, l1] = enter_evidence(motor2,evidencia);
	m = marginal_nodes(motor3,1);
	p(i,:) = m.T';
end
error = 0;
for(i = 1:length(p)
	[val,ind] =max(p(i,:));
	if(ind ~= etiqTest(i)) error = error +1;
	end
end
errorr = (error(length(p));
left = (errorr - (1.96*sqrt(errorr*(1-errorr)/length(p))));
rigth = (errorr + (1.96*sqrt(errorr*(1-errorr)/length(p))));
range = [100*left,100*right]
errorr = errorr*100;
end
