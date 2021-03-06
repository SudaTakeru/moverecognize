addpath('x');
addpath('functions');

%% file processing
%%%% number of feature point%%%%
n=50; % number of using points
n2=150; % number of finding points
%%%% filter wides %%%%
high=400;
low=1;
%%%% inputfiles %%%%
cd x;
movies = dir('*.MOV'); 

N = length(movies);
%%%%%%%%%%%%%%%%%%%%
sampledata=cell(1,N);

k=zeros(1,N+1);
k(1,1)=inf;
%%%% frame processing %%%%

for i = 1:N 
  tic
  v = VideoReader(movies(i).name); 
  %Frame divide
  [sample,k(1,i+1)]=InportV(v); 
  %Featurepointmatching
  %sampledata{i}=Featurepointmtching(sample,k(1,i+1),n);
  sampledata{i}=Featurepointmtching2(sample,k(1,i+1),n,n2,high,low);
  if k(1,i+1)<k(1,i)
      t=i;
  end
  fprintf('Feature point Matching Time\n');
  toc
  %{
  figure;
  for ti=1:size(sampledata{i},3)
    hold on;
    quiver(sampledata{i}(:,1,ti),sampledata{i}(:,2,ti),sampledata{i}(:,3,ti),sampledata{i}(:,4,ti));
  end
  %}
end

cd ..

%% vector sort
datas=cell(1,N);
for iv=1:N
    data=sampledata{iv};
    vs=zeros(size(data,1),1);
    for jv=1:size(data,3)
        for kv=1:size(data,1)
            vs(kv,1)=norm(data(kv,3:4,jv));
        end
        vs2=sort(vs(:,1));
        for kv=1:size(data,1)
            for kv2=1:size(data,1)
                if vs(kv,1)==vs2(kv2,1)
                    datas{iv}(kv2,:,jv)=data(kv,:,jv);
                end
            end
        end   
    end
end
%{
for j=1:N
    figure;hold on;
    for ti=1:size(data,3)
        quiver(datas{j}(:,1,ti),datas{j}(:,2,ti),datas{j}(:,3,ti),datas{j}(:,4,ti));
    end
end
%}
%% DP proess
tic
B=sampledata{t};
[b1,b2,b3]=size(B);
data=zeros(b1,b2,b3,N);
for j=1:N
    A=datas{j};
    %A=sampledata{j};
    
    [p,q,D]=framematching(A,B);

    r=size(p,2);
    count=2;

    data(:,:,1,j)=A(:,:,1);

    for i=2:r
        if q(1,i)~=q(1,i-1) 
            data(:,:,count,j)=A(:,:,p(1,i));
            count=count+1;     
        end
    end

end
fprintf('DP process Time\n');
toc
%{
for j=1:N
    figure;hold on;
    for ti=1:size(data,3)
        quiver(data(:,3,ti,j),data(:,4,ti,j),data(:,1,ti,j),data(:,2,ti,j));
    end
end
%}
%% training SOINN step by step
addpath '..';
tic
%%%%%%%%%%%% SOINN parameters %%%%%%%%%%%
lambda = 500;
age=100;
ClusteringSize=2;


%%%%%%%%%%%%Input Data Processing%%%%%%%%%
data4=zscore(data); %Standardization
[d,dd,ddd,N] = size(data4); %input data file

for i=1:N
    for k=1:ddd
        for l=1:dd
            X2((dd*d-d+1):dd*d,i)=data4(:,l,k,i);
        end
            X3(d*dd*ddd-d*dd+1:d*dd*ddd,i)=X2(:,i);
    end
end

[d,N]= size(X3); %input data file
trainingData=X3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NN = Soinn('lambda', lambda, 'ageMax', age, 'dim', d);

 for i = 1:N
    NN.inputSignal(trainingData(:,i));   
 end

fprintf('SOINN process Time\n');
toc

UU=NN.clustering(ClusteringSize);
NUM=NN.signalnum2;