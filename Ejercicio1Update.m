clear

if (nargin~=5)
	printf('Wrong number of parameters');
	exit(1);
endif

%Datos de entrenamiento
arglist=argv();
arg_1=arglist{1};
disp('Loading data 1...');
tr_dat = load(arg_1,'-ascii');
disp('Data 1 load complete.');

arg_2=arglist{2};
disp('Loading data 2...');
trlabel = load(arg_2,'-ascii');
disp('Data 2 load complete.');
tr_data = zscore(tr_dat);
[numVec dim] = size(tr_data);
numClas = max(trlabel)

%Datos de test
arg_3 = arglist{3};
disp('Loading data 3...');
tr_dat_test = load(arg_3,'-ascii');
disp('Data 3 load complete.');

arg_4 = arglist{4};
disp('Loading data 4...');
tr_label_test = load(arg_4,'-ascii');
disp('Data 4 load complete.');
tr_data_test = zscore(tr_dat_test);

%Número de gaussianas por mixtura
gaussianas = arglist{5};

numGaus = gaussianas;
grafo = [0 1 1; 0 0 1;0 0 0];
numNodos = length(grafo);
tallaNodos = [numClas numGaus dim];
nodosDiscretos = [1 2];
redB = mk_bnet(grafo,tallaNodos,'discrete',nodosDiscretos);
redB.CPD{1} = tabular_CPD(redB,1);
redB.CPD{2} = tabular_CPD(redB,2);
redB.CPD{3} = gaussian_CPD(redB,3,'cov_type','diag');

tr_datos = cell(numNodos,numVec);
tr_datos(numNodos,:)= num2cell(tr_data',1);
tr_datos(1,:)=num2cell(etiqApr',1);
motor = jtree_inf_engine(redB);
maxIter = 16;
[redB2,l1,motor2]=learn_params_em(motor,tr_datos,maxIter);

p = zeros(length(tr_data_test),numClas);
evidencia = cell(numNodos,1);
for i =1:length(tr_data_test)
	evidencia{numNodos} = tr_data_test(i,:)';
	[motor3, l1] = enter_evidence(motor2,evidencia);
	m = marginal_nodes(motor3,1);
	p(i,:) = m.T';
end
