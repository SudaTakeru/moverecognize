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
high=400;
low=1;

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

for i = 1:3 
  mydata{i} = rgb2gray(sample(i).cdata); 
end

%%SURF วมฅo

matchedPoints=zeros(n2,2,2*N);
featurevector=zeros(n2,2,N-1);
%{
matchedPointsM=zeros(n2,1,N-1);
matchedPointsO=zeros(n2,1,N-1);
matchedPointsM2=zeros(n,1,N-1);
matchedPointsO2=zeros(n,1,N-1);
%}
fvec=zeros(n,2,N-1);
figure;hold on;
for j=1:2
    
    %%%%%%%%%%%%%%
    [matchedPoints1,matchedPoints2]=surf2(mydata{j},mydata{j+1},No,MT,Ns);
    %Features Match
    showMatchedFeatures(mydata{j},mydata{j+1},matchedPoints1,matchedPoints2);
    %%%%%%%%%%%%%%
    
    
    matchedPoints1=matchedPoints1.selectStrongest(n2);
    matchedPoints2=matchedPoints2.selectStrongest(n2);
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
    %Features Metric and Orientation
    %matchedPointsM(:,:,j)=[matchedPoints1.Metric];
    %matchedPointsO(:,:,j)=[matchedPoints1.Orientation];
    %Cleate Vector
    featurevector(:,:,j)= matchedPoints(:,:,2*j-1)-matchedPoints(:,:,2*j);
    
    %BPF
    nvec=zeros(1,size(featurevector,1));
    count=1;
    
    number=zeros(1,n);
    for l=1:size(featurevector,1)
        nvec(1,l)=norm(featurevector(l,:,j));
        if fvec(n,:,j)~=0
            break
        end
        if nvec(1,l)<high && nvec(1,l)>low
           fvec(count,:,j)=featurevector(l,:,j);
           number(1,count)=l;
           count=count+1;
        end
    end
    
<<<<<<< HEAD
    % vector sort and adjust dimension
    data=fvec2(:,:,j);
    vs=zeros(size(data,1),1);
    for kv=1:size(data,1)
        vs(kv,1)=norm(data(kv,1:2,j));
    end
    vs2=sort(vs(:,1));
    for kv=1:size(data,1)
        for kv2=1:size(data,1)
            if vs(kv2,1)==vs2(kv,1)
                fvec3(kv,:,j)=data(kv2,:,j);
                number(1,kv)=kv2;
            end
        end
    end
    number3=number2(1,number(1,:));
    
    matchedPoints(:,:,2*j-1)=matchedPoints1.Location(number3(1,1:n),:);
    matchedPoints(:,:,2*j)=matchedPoints2.Location(number3(1,1:n),:);
    fvec(:,:,j)=fvec3(1:n,:,j);
    
=======
    %matchedPointsM2(:,:,j)=matchedPointsM(number(1,:),:,j);
    %matchedPointsO2(:,:,j)=matchedPointsO(number(1,:),:,j);

>>>>>>> parent of 979f493... ็นๅพด็นใฎๅใๆนๆนๅ
    %Show Vector
    quiver(matchedPoints(number(1,:),1,2*j-1),matchedPoints(number(1,:),2,2*j-1),fvec(:,1,j),fvec(:,2,j));

end


figure;hold on;
for j=1:N-1
    quiver(matchedPoints(number(1,:),1,2*j-1),matchedPoints(number(1,:),2,2*j-1),fvec(:,1,j),fvec(:,2,j));
end

%W{ถฌ
sampledata=zeros(n,4,N-1);
for j=1:N-1
    sampledata(:,:,j)=[fvec(:,:,j),matchedPoints(number(1,:),:,2*j-1)];%, matchedPointsM2(:,:,j),matchedPointsO2(:,:,j)];
end

cd ..;