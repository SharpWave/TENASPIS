function [ output_args ] = TS_Lowpass_Divide(infile,LPfile)

smoothfr = 20;

info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

finaloutfile = [infile(1:end-3),'_LowpassDivide.h5'];
h5create(finaloutfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','double');
% run movie smoother, save to temp file

% for each frame:

for i = 1:NumFrames
    i
%  % load original, load smoothed, divide, save to outfile
  rawframe = double(h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1]));
  smframe = double(h5read(LPfile,'/Object',[1 1 i 1],[XDim YDim 1 1]));
  newframe = (rawframe)./(smframe);
%   subplot(1,3,1);imagesc(rawframe);
%   subplot(1,3,2);imagesc(smframe);
%   subplot(1,3,3);imagesc(newframe);caxis([0.9 1.1]);
%   pause;close;
  h5write(finaloutfile,'/Object',newframe,[1 1 i 1],[XDim YDim 1 1]);

end

