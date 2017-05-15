
function sampledata=Featurepointmtching2(sample,k,n,n2,high,low)

N = k;
mydata = cell(1, N);

for i = 1:N 
  mydata{i} = rgb2gray(sample(i).cdata); 
end

%%SURF ã«èäì¡í•åüèo

matchedPoints=zeros(n2,2,2*N);
featurevector=zeros(n2,2,N-1);
%{
matchedPointsM=zeros(n2,1,N-1);
matchedPointsO=zeros(n2,1,N-1);
matchedPointsM2=zeros(n,1,N-1);
matchedPointsO2=zeros(n,1,N-1);
%}
fvec=zeros(n,2,N-1);

for j=1:N-1
    [matchedPoints1,matchedPoints2]=surf(mydata{j},mydata{j+1});
    %Features Match
    %figure;hold on;
    %showMatchedFeatures(mydata{j},mydata{j+1},matchedPoints1,matchedPoints2);
    %hold on;
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
    
    %matchedPointsM2(:,:,j)=matchedPointsM(number(1,:),:,j);
    %matchedPointsO2(:,:,j)=matchedPointsO(number(1,:),:,j);

    %Show Vector
    %quiver(matchedPoints(number(1,:),1,2*j-1),matchedPoints(number(1,:),2,2*j-1),fvec(:,1,j),fvec(:,2,j));
    %hold off;
end

%{
figure;hold on;
for j=1:N-1
    quiver(matchedPoints(number(1,:),1,2*j-1),matchedPoints(number(1,:),2,2*j-1),fvec(:,1,j),fvec(:,2,j));
end
%}
%ïWñ{ê∂ê¨
sampledata=zeros(n,4,N-1);
for j=1:N-1
    sampledata(:,:,j)=[fvec(:,:,j),matchedPoints(number(1,:),:,2*j-1)];%, matchedPointsM2(:,:,j),matchedPointsO2(:,:,j)];
end

end




