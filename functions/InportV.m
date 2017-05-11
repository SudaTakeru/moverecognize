
function [sample,k]=InportV(video)

vwidth=video.Width;
vheight=video.Height;

sample = struct('cdata',zeros(vheight,vwidth,3),'colormap',[]);

k = 1;
while hasFrame(video)
    sample(k).cdata = readFrame(video);
    k = k+1;
end
k = k-1;
%%% show frames%%%
%{
hf = figure;
set(hf,'position',[150 150 vwidth vheight]);

movie(hf,sample,1,v.FrameRate);
%}

end