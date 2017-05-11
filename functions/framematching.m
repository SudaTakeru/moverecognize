function [p,q,matchpoint]=framematching(A,B)
    FA=size(A,3);
    FB=size(B,3);
    %matchpoint=zeros(2,FA);
    D=zeros(FA,FB);
    %E=zeros(FA,FB);
    for i=1:FA
        for j=1:FB
            D(i,j)=det((A(:,:,i)-B(:,:,j))'*(A(:,:,i)-B(:,:,j)));
        end
    end
    
    [p,q,matchpoint]=dp(D);
    
    
    %{
    for i=1:FA
        matchpoint(1,i)=min(D(i,:));
        
        for j=1:FB
           if D(i,j)==matchpoint(1,i)
               p=j;
               E(i,j)=E(i,j)+1;
           end
        end
        matchpoint(2,i)=p;
        
    end
    %}
end