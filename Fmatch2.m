%% file processing
%%%% number of feature point%%%%
n=50; % number of using points
n2=250; % number of finding points
%%%% inputfiles %%%%

addpath('x');
addpath('functions');
cd x;
movies = dir('B7.MOV'); 

%N = length(movies);

%%%%%%%%%%%%%%%%%%%%
high=100;
low=0.5;

No=3;
MT=20;
Ns=6;
%%%% frame processing %%%%
i=1;
  v = VideoReader(movies(i).name); 
  %Frame divide
  [sample,k]=InportV(v); 
  
%Featurepointmatching

N = k;
mydata = cell(1, N);

for i = 1:N
  mydata{i} = rgb2gray(sample(i).cdata); 
end

%%SURF 局所特徴検出

matchedPoints=zeros(n,2,2*N);
%featurevector=zeros(n2,2,N-1);

fvec=zeros(n,2,N-1);

for j=1:N-1
    figure;hold on;
    %%%%%%%%%%%%%%
    [matchedPoints1,matchedPoints2]=surf2(mydata{j},mydata{j+1},No,MT,Ns);
    %Features Match
    showMatchedFeatures(mydata{j},mydata{j+1},matchedPoints1,matchedPoints2);
    %%%%%%%%%%%%%%
    
    %{
    if size(matchedPoints1.Location,1)<n2
        shortage=n2-size(matchedPoints1.Location,1);
        si=randi(size(matchedPoints1.Location,1),shortage,1);
        matchedPoints(n2-shortage+1:n2,:,2*j-1)=[matchedPoints1.Location(si(:,1),:)];
        matchedPoints(n2-shortage+1:n2,:,2*j)=[matchedPoints2.Location(si(:,1),:)];
        matchedPoints(1:n2-shortage,:,2*j-1)=[matchedPoints1.Location];
        matchedPoints(1:n2-shortage,:,2*j)=[matchedPoints2.Location];   
    else
        matchedPoints(:,:,2*j-1)=[matchedPoints1.Location];
        matchedPoints(:,:,2*j)=[matchedPoints2.Location];
    
    end
    %}
    %Cleate Vector
    featurevector2= matchedPoints2.Location-matchedPoints1.Location;
    
    %BPF
    nvec=zeros(1,size(featurevector2,1));
    count=1;
    
    number2=zeros(1,n);
    for l=1:size(featurevector2,1)
        nvec(1,l)=norm(featurevector2(l,:));
     
        if nvec(1,l)<high && nvec(1,l)>low
           fvec2(count,:,j)=featurevector2(l,:);
           number2(1,count)=l;
           count=count+1;
        end
    end
    
    % vector sort
    data=fvec2(:,:,j);
    vs=zeros(size(data,1),1);
    for kv=1:size(data,1)
        vs(kv,1)=norm(data(kv,1:2,j));
    end
    vs2=sort(vs(:,1));
    for kv=1:size(data,1)
        for kv2=1:size(data,1)
            if vs(kv,1)==vs2(kv2,1)
                fvec3(kv2,:,j)=data(kv,:,j);
            end
        end
    end   
    
    
    %Dicimation for adjust dimension
    ind=randi([1,count-1],n,1);
    number=number2(ind(:,1));
    
    matchedPoints(:,:,2*j-1)=matchedPoints1.Location(number(1,:),:);
    matchedPoints(:,:,2*j)=matchedPoints2.Location(number(1,:),:);
    fvec(:,:,j)=featurevector2(number(1,:),:);
    
    %Show Vector
    quiver(matchedPoints(:,1,2*j-1),matchedPoints(:,2,2*j-1),fvec(:,1,j),fvec(:,2,j));

end


figure;hold on;
for j=1:N-1
    quiver(matchedPoints(:,1,2*j-1),matchedPoints(:,2,2*j-1),fvec(:,1,j),fvec(:,2,j));
end

%標本生成
sampledata=zeros(n,4,N-1);
for j=1:N-1
    sampledata(:,:,j)=[fvec(:,:,j),matchedPoints(:,:,2*j-1)];
end

cd ..;