function [] = DWS_WidebandPlx2dat(inname,outname,NumChannels)
% [] = DWS_WidebandPlx2dat(inname,channels)
% this function takes a .plx file containing wideband data, extracts the
% wideband data, and compiles it into the datamax .dat binary format that
% is compatible with the Neuroscope/Klusters/NdManager suite


CurrChan = 1;
[ns,s] = plx_adchan_samplecounts(inname);
NumSamples = s(1);
fout = fopen([outname,'.dat'],'w');
ChunkSize = 100000;
NumFullChunks = floor(NumSamples/ChunkSize);
CurrStart = 1;

for j = 1:NumFullChunks
    j/NumFullChunks
    for i = 1:NumChannels
        
        % read the wideband signal for channel i
        [adfreq,n,temp] = plx_ad_span(inname,i-1,CurrStart,CurrStart+ChunkSize-1);
        ad(i,:) = temp;
        
    end
    
    fwrite(fout,ad,'int16');
end
fclose(fout);



