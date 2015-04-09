function [] = DWS_WidebandPlx2dat(inname,NumChannels,endsample)
% [] = DWS_WidebandPlx2dat(inname,channels)
% this function takes a .plx file containing wideband data, extracts the
% wideband data, and compiles it into the datamax .dat binary format that
% is compatible with the Neuroscope/Klusters/NdManager suite
% special note: if the .plx file is 'Dave.plx', then inname should be
% 'Dave'

CurrChan = 1;

for i = 1:NumChannels
    i
    % read the wideband signal for channel i
    [adfreq,n,ts,fn,ad] = plx_ad([inname,'.plx'],i-1);
    
    NumSamps = n; % assumed to be the same for all channels
    
    % write the channel to a temporary file
    fid = fopen(['tmp.',int2str(CurrChan)],'w');
    if nargin < 3
        lastS = NumSamps
    else
        lastS = endsample;
    end
    
    fwrite(fid,ad(1:lastS),'int16');
    
    fclose(fid);
    
    CurrChan = CurrChan+1;
end

% open the temporary files
for i = 1:NumChannels
    fin(i) = fopen(['tmp.',int2str(i)],'r');
end

% open the file to write to
fout = fopen([inname,'.dat'],'w');
Blocksize = 10000000;
NumBlocks = floor(lastS/Blocksize);
Remainder = lastS-(Blocksize*NumBlocks);

for i = 1:NumBlocks
   for j = 1:NumChannels
       temp(j,1:Blocksize) = fread(fin(j),Blocksize,'int16');
   end
   fwrite(fout,temp(:),'int16');
end
clear temp;
   for j = 1:NumChannels
       temp(j,1:Remainder) = fread(fin(j),Remainder,'int16');
   end
   fwrite(fout,temp(:),'int16');

for i = 1:NumChannels
    fclose(fin(i));
end
fclose(fout);


    