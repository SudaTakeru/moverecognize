
function sampledata=Featurepointmtching2(sample,k,n,high,low,No,MT,Ns)

N = k;
mydata = cell(1, N);

for i = 1:N 
  mydata{i} = rgb2gray(sample(i).cdata); 
end

%%SURF ã«èäì¡í•åüèo

matchedPoints=zeros(n,2,2*N);

fvec=zeros(n,2,N-1);
figure;hold on;
for j=1:N-1
    
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

%ïWñ{ê∂ê¨
sampledata=zeros(n,4,N-1);
for j=1:N-1
    sampledata(:,:,j)=[fvec(:,:,j),matchedPoints(:,:,2*j-1)];
end

end




