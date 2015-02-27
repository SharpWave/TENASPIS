function [out, t, FiringRate,Pairs,SampleRate,BinSize,nSpikesPerGroup,nGroups,Trange,GSubset] = CCG(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization, Epochs, DoPlotting)
% constructs multiple cross and Auto correlogram
% usage: [out, t, FiringRate,Pairs,SampleRate,BinSize,nSpikesPerGroup,nGroups,Trange,GSubset] = CCG(T, G, BinSize, HalfBins, SampleRate, GSubset, Normalization, Epochs, DoPlotting)
%
% T gives the time of the events, (events need not be sorted by TIME)
% G says which one is in which group
% BinSize gives the size of a bin in input units (i.e. not scaled by SampleRate)
% HalfBins gives the number of bins on each side of 0 - so the total is 1+2*HalfBins
% SampleRate is for x-axis scaling only.  It defaults to 20000
% GSubset says which groups to plot the CCGS of (defaults to all but group 1)
% Normalization indicates the type of y-axis normalization to be used.  
% 'count' indicates that the y axis should show the raw spike count in each bin.
% 'hz' will normalize to give the conditional intensity of cell 2 given that cell 1 fired a spike (default)
% 'hz2' will give the joint intensity, measured in hz^2.
% 'scale' will scale by both firing rates so the asymptotic value is 1.  This gives you
%   the ratio of the coincidence rate to that expected for uncorrelated spike trains
%
% optional input Epochs allows you to compute from only spikes in certain epochs
% and it will bias-correct so you don't see any triangular shape. 
% Warning: if gaps between epochs are shorter than total CCG length, this will mess
% up the edges.
%
% The output array will be 3d with the first dim being time lag and the second two 
% specifying the 2 cells in question (in the order of GSubset)
% If there is no output specified, it will plot the CCGs
%
% This file calls a C program so your CCG is computed fast.
%
% optional output t gives time axis for the bins in ms
% optional output argument pairs gives a nx2 array with the indices of the spikes
% in each train that fall in the CCG.

if nargin<5
	SampleRate = 20000;
end
if nargin<6
	GSubset = unique(G);
	GSubset = setdiff(GSubset, 1);
end
if nargin<7
	Normalization = 'hz';
end;
if nargin<8
    Epochs = [];
end

if nargin<9
    DoPlotting = 0;
end
LowerCutoff = 1;

if length(G)==1
	G = ones(length(T), 1);
	GSubset = 1;
	nGroups = 1;
else
	nGroups = length(GSubset);
end;


% Prepare Res and Clu arrays.
G=G(:);
T=T(:);

if ~isempty(Epochs)
    Included = find(ismember(G,GSubset) & isfinite(T) & WithinRanges(T,Epochs));
    
    % check gaps between epochs are not too short
    GapLen = Epochs(2:end,1) - Epochs(1:(size(Epochs,1)-1),2);
    TooShort = find(GapLen<BinSize*(HalfBins+.5));
    if ~isempty(TooShort)
        fprintf('WARNING: Epochs ');
        fprintf('%d ', TooShort);
        fprintf('are followed by too-short gaps.\n');
    end
else
    Included = find(ismember(G,GSubset) & isfinite(T));
%    Epochs = [min(T)-1 max(T)+1];
end
Res = T(Included);
% if no spikes, return nothing
if length(Res)<=LowerCutoff
    nBins = 1+2*HalfBins;
    out = zeros(nBins, nGroups, nGroups);
    t = 1000*(-HalfBins:HalfBins)*BinSize/SampleRate;
    Pairs = [];
    disp('found no spikes');
    return
end

% To make the Clu array we need a indexing array, which SUCKS!
G2Clu = full(sparse(GSubset,1,1:nGroups));
Clu = G2Clu(G(Included));


% sort by time
[Res ind] = sort(Res);
Clu = Clu(ind);

% Now call the C program...

% call the program
nSpikes = length(Res);
if nargout>=4
    [Counts RawPairs] = CCGHeart(Res, uint32(Clu), BinSize, uint32(HalfBins));
    rsRawPairs = reshape(RawPairs, [2 length(RawPairs)/2])';
else
    Counts = CCGHeart(Res, uint32(Clu), BinSize, uint32(HalfBins));
end
% shape the results
nBins = 1+2*HalfBins;
% if there are no spikes in the top cluster, CCGEngine will produce a output the wrong size
nPresent = max(Clu);
Counts = double(reshape(Counts,[nBins nPresent nPresent]));
if nPresent<nGroups
    % extent array size with zeros
    Counts(nBins, nGroups, nGroups) = 0;
end
    
if nargout>=4
    Pairs = Included(ind(double(rsRawPairs) + 1));
end

% OK so we now have the bin counts.  Now we need to rescale it.

% remove bias due to edge effects - this should be vectorized
if isempty(Epochs)
    Bias = ones(nBins,1);
else
    nTerm = [HalfBins:-1:1 , 0.25 , 1:HalfBins];
	Bias = zeros(nBins,1);
    TotLen = 0;
	for e=1:size(Epochs,1)
        EpochLen = Epochs(e,2)-Epochs(e,1);
        EpochBias = clip(EpochLen - nTerm*BinSize,0,inf)*BinSize;
        Bias = Bias+EpochBias';
        TotLen = TotLen + EpochLen;
	end
    Bias = Bias/TotLen/BinSize;
end

Trange = max(Res) - min(Res);
if ~isempty(Epochs) Trange = TotLen; end
% total time
%Trange = sum(diff(Epochs,[],2));
t = 1000*(-HalfBins:HalfBins)*BinSize/SampleRate;

% count the number of spikes in each group:
for g=1:nGroups
	nSpikesPerGroup(g) = sum(Clu==g);
end;

% normalize each group
for g1=1:nGroups, for g2=1:nGroups
	switch Normalization
		case 'hz'
			Factor = SampleRate / (BinSize * nSpikesPerGroup(g1));
			AxisUnit = '(Hz)';
		case 'hz2'
			Factor = SampleRate * SampleRate / (Trange*BinSize);	
			AxisUnit = '(Hz^2)';
		case 'count';
			Factor = 1;
			AxisUnit = '(Spikes)';
		case 'scale'
			Factor = Trange / (BinSize * nSpikesPerGroup(g1) * nSpikesPerGroup(g2));
			AxisUnit = '(Scaled)';
		otherwise
			warning(['Unknown Normalization method ', Normalization]);
	end;
% 	ccg(:,g1,g2) = flipud(Counts(:,g1,g2)) * Factor ./repmat(Bias,[1 nGroups,nGroups]); 
 	ccg(:,g1,g2) = flipud(Counts(:,g1,g2)) * Factor ./Bias; 
	
	
	
	  FigureIndex = g1 + nGroups*(nGroups-g2);
	  
	  if (g1 <= g2)
	    if ((nargout == 0) || (DoPlotting == 1))
	      subplot(nGroups,nGroups,FigureIndex);
	      bar(t, ccg(:,g1,g2),'BarWidth',1);shading flat;		
            end
	  
	  % label y axis
	   if g1==g2
             
    	     FiringRate(g1) = SampleRate * nSpikesPerGroup(g1) / Trange;
      	     %Ttitle = sprintf('%d (%5.2fHz)',GSubset(g1),FiringRate);
             %title(Ttitle,'FontSize',6);
	     if ((nargout == 0) || (DoPlotting == 1))
    	       xlabel('ms');
	     end
           end
	   if (g2 ~= g1)
             if ((nargout == 0) || (DoPlotting == 1))
	       set(gca,'XTickLabel',[]);
             end
	   end
	     
	     
           if g2==nGroups
	    if ((nargout == 0) || (DoPlotting == 1))
    	      Ttitle = sprintf('%d \n (%5.2fHz)',GSubset(g1),FiringRate(g1));
	      title(Ttitle,'FontSize',6);
	    end
           end
           if ((nargout == 0) || (DoPlotting == 1))
 
	     axis tight
           end
	 end
	
end,end;

% only make an output argument if its needed (to prevent command-line spew)
if (nargout>0)
	out = ccg;
end


