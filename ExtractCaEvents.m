function [] = ExtractCaEvents(file)

info = h5info(file,'/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

av = zeros(Xdim,Ydim);
for i = 1:NumFrames
    tempFrame = h5read(file,'/Object',[1 1 i 1],[Xdim Ydim 1 1]);
    [bw,cc{i},thresh(i)] = SegmentFrame2(tempFrame,0);
    av = av+bw;
    i/NumFrames
end

% Iterate through the file and identify unambiguous segments that appear on
% consecutive frames



save CC.mat cc thresh;



            
