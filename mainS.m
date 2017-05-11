global data
%% training SOINN step by step
addpath '..';

%%%%%%%%%%%% SOINN parameters %%%%%%%%%%%
lambda = 500;
age=100;
ClusteringSize=2;

%%%%%%%%%%%%Input Data Processing%%%%%%%%%
[d,dd,ddd,N] = size(data); %input data file

for i=1:N
    for k=1:ddd
        for l=1:dd
            X2((dd*d-d+1):dd*d,i)=data(:,l,k,i);
        end
            X3(d*dd*ddd-d*dd+1:d*dd*ddd,i)=X2(:,i);
    end
end

[d,N]= size(X3); %input data file
trainingData=zscore(X3); %Standardization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NN = Soinn('lambda', lambda, 'ageMax', age, 'dim', d);

 for i = 1:3
    NN.inputSignal(trainingData(:,i));   
 end
 
s = i;
for i = s:N
    NN.inputSignal(trainingData(:,i));
end 

UU=NN.clustering(ClusteringSize);
