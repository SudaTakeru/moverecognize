
function sampledata=Featurepointmtching(sample,k,n)
N = k;
mydata = cell(1, N);

for i = 1:N 
  mydata{i} = rgb2gray(sample(i).cdata); 
end

%%SURF ã«èäì¡í•åüèo

matchedPoints=zeros(n,2,2*N);
featurevector=zeros(n,2,N-1);
matchedPointsM=zeros(n,1,N-1);
matchedPointsO=zeros(n,1,N-1);

for j=1:N-1
    matchedPoints1=surf(mydata{j},mydata{j+1});
    matchedPoints2=surf2(mydata{j},mydata{j+1});
    %Features Match
    %figure;hold on;
    %showMatchedFeatures(mydata{j},mydata{j+1},matchedPoints1,matchedPoints2);
    matchedPoints1=matchedPoints1.selectStrongest(n);
    matchedPoints2=matchedPoints2.selectStrongest(n);
   
    
    matchedPoints(:,:,2*j-1)=[matchedPoints1.Location];
    matchedPoints(:,:,2*j)=[matchedPoints2.Location];
    %Features Metric and Orientation
    matchedPointsM(:,:,j)=[matchedPoints1.Metric];
    matchedPointsO(:,:,j)=[matchedPoints1.Orientation];
    %Cleate Vector
    featurevector(:,:,j)= matchedPoints(:,:,2*j-1)-matchedPoints(:,:,2*j);
    %Show Vector
    %quiver(matchedPoints(:,1,2*j-1),matchedPoints(:,2,2*j-1),featurevector(:,1,j),featurevector(:,2,j));
end


figure;hold on;
for j=1:N-1
    quiver(matchedPoints(:,1,2*j-1),matchedPoints(:,2,2*j-1),featurevector(:,1,j),featurevector(:,2,j));
end

%ïWñ{ê∂ê¨
sampledata=zeros(n,6,N-1);
for j=1:N-1
    sampledata(:,:,j)=[featurevector(:,:,j),matchedPoints(:,:,2*j-1), matchedPointsM(:,:,j),matchedPointsO(:,:,j)];
end

end




