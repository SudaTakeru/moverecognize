%% vector sort
vs=zeros(size(data,1),2);
datas=zeros(size(data));
for iv=1:size(data,4)
    for jv=1:size(data,3)
        for kv=1:size(data,1)
            vs(kv,1)=norm(data(kv,3:4,jv,iv));
            vs(kv,2)=kv;
        end
        vs2=sort(vs(:,1));
        for kv=1:size(data,1)
            for kv2=1:size(data,1)
                if vs(kv,1)==vs2(kv2,1)
                    datas(kv2,:,jv,iv)=data(kv,:,jv,iv);
                end
            end
        end   
    end
end

for j=1:N
    figure;hold on;
    for ti=1:size(data,3)
        quiver(datas(:,1,ti,j),datas(:,2,ti,j),datas(:,3,ti,j),datas(:,4,ti,j));
    end
end
%}