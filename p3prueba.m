%function [error] = p3(datos,etiquetas,datosTest,etiquetasTest,gauss)
warning off all
addpath('~/asigDSIC/ETSINF/apr/p2/BNT')
addpath(genpathKPM('~/asigDSIC/ETSINF/apr/p2/BNT'))


%Datos de entrenamiento

datApr = load('tr.dat','-ascii');
etqApr = load('trlabels.dat','-ascii');
dataApr = zscore(datApr);
etiqApr = etqApr + 1;
[numVec dim] = size(dataApr);
numClas = max(etiqApr)


%Datos de test



%Número de gaussianas por mixtura
numGaus = 2;

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

datosApr = cell(numNodos,numVec);
datosApr(numNodos,:)= num2cell(dataApr',1);
datosApr(1,:)=num2cell(etiqApr',1);
motor = jtree_inf_engine(redB);
maxIter = 16;
epsilon = 1e-20;
[redB2,l1,motor2]=learn_params_em(motor,datosApr,maxIter,epsilon);

datTest = load('ts.dat','-ascii');
etqTest = load('tslabels.dat','-ascii');
dataTest = zscore(datTest);
etiqTest = etqTest + 1;

p = zeros(length(dataTest),numClas);
evidencia = cell(numNodos,1);
for i =1:length(dataTest)
	evidencia{numNodos} = dataTest(i,:)';
	[motor3, l1] = enter_evidence(motor2,evidencia);
	m = marginal_nodes(motor3,1);
	p(i,:) = m.T';
end
err = 0;
for i = 1:length(p)
	[val,ind] =max(p(i,:));
	if(ind ~= etiqTest(i)) err = err +1;
	end
end
error = (err/length(p));
left = (error - (1.96*sqrt(error*(1-error)/length(p))));
right = (error + (1.96*sqrt(error*(1-error)/length(p))));
range = [100*left,100*right]
error = error*100;
