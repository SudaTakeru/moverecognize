%global sampledata

% DP matching

%%%% inputfiles %%%%

movies = dir('*.MOV'); 

n=50;
N = length(movies);
v = VideoReader(movies(1).name);
v2 = VideoReader(movies(2).name);
[sample,k]=InportV(v);
[sample2,k2]=InportV(v2);
A=Featurepointmtching(sample,k,n);

B=Featurepointmtching(sample2,k2,n);

[p,q,D]=framematching(A,B);

r=size(p,2);
count=2;

A2(:,:,1)=A(:,:,1);

for i=2:r
    if q(1,i)~=q(1,i-1) 
        A2(:,:,count)=A(:,:,p(1,i));
        count=count+1;      
    end
end




