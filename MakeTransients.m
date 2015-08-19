function [] = MakeTransients(file,todebug,varargin)
% [] = MakeTransients(file,cc )
% Take all of those blobs found in ExtractBlobs.m and figure out, for each
% one, whether there was one on the previous frame that matched it and if
% so which one, thus deducing calcium transients across frames
%
% varargins:
%   'min_trans_length':minimum number of frames a transient must last in
%   order to be included, enter as MakeTransients(...,'min_trans_length,3)

%% Calcium transient inclusion criteria
min_trans_length = 5; % minimum number of frames a transient must last in order to be included
max_trans_dist = 5; % maximum number of pixels a transient can travel without being discarded

%% Get vargins
for j = 1:length(varargin)
   if strcmpi(varargin{j},'min_trans_length')
       min_trans_length = varargin{j+1};
   end
%    if strcmpi(varargin{j},'max_trans_dist')
%       max_trans_dist = varargin{j+1};
%    end
end

%%

load CC.mat

if (nargin < 2)
    todebug = 0;
end

info = h5info(file,'/Object');
NumFrames = info.Dataspace.Size(3);
Xdim = info.Dataspace.Size(1);
Ydim = info.Dataspace.Size(2);

NumSegments = 0;
SegChain = [];
SegList = zeros(NumFrames,100);

for i = 2:NumFrames
    i
    stats = regionprops(cc{i},'all');
    oldstats = regionprops(cc{i-1},'all');
    for j = 1:cc{i}.NumObjects
        if (todebug)
            % plot frame and neuron outline of neuron in question
            f = loadframe(file,i);
            temp = zeros(Xdim,Ydim);
            temp(cc{i}.PixelIdxList{j}) = 1;
            b = bwboundaries(temp);
            y = b{1}(:,1);
            x = b{1}(:,2);
            
            subplot(1,2,1)
            imagesc(f);colormap gray;caxis([-500 500]);hold on;
            plot(x,y,'-r','LineWidth',3);hold off;
            title ('blob that we are trying to match (red)');
            
            % plot all of the neurons on the previous frame
            f = loadframe(file,i-1);
            subplot(1,2,2);
            imagesc(f);colormap gray;caxis([-500 500]);hold on;
            title('previous blobs in green, matched blob in red');
            for k = 1:cc{i-1}.NumObjects
                temp = zeros(Xdim,Ydim);
                temp(cc{i-1}.PixelIdxList{k}) = 1;
                b = bwboundaries(temp);
                y = b{1}(:,1);
                x = b{1}(:,2);
                plot(x,y,'-g');
            end
        end
        
        % find match
        [MatchingSeg,idx] = MatchSeg(stats(j),oldstats,SegList(i-1,:));
        if (MatchingSeg == 0)
            % no match found, make a new segment
            NumSegments = NumSegments+1;
            SegChain{NumSegments} = {[i,j]};
            SegList(i,j) = NumSegments;
        else
            % a match was found, add to segment
            SegChain{MatchingSeg} = [SegChain{MatchingSeg},{[i,j]}];
            SegList(i,j) = MatchingSeg;
            if (todebug)
                subplot(1,2,2);
                hold on;
                temp = zeros(Xdim,Ydim);
                temp(cc{i-1}.PixelIdxList{idx}) = 1;
                b = bwboundaries(temp);
                y = b{1}(:,1);
                x = b{1}(:,2);
                plot(x,y,'-r');
                hold off;pause;
            end
            
        end
    end
end

for i = 1:length(SegChain)
    ns(i) = length(SegChain{i});
end

DistTrav = TransientStats(SegChain);

goodlen = find(ns >= min_trans_length);
gooddist = find(DistTrav < max_trans_dist);

goodseg = intersect(goodlen,gooddist);

SegChain = SegChain(goodlen);
NumSegments = length(SegChain);


if min_trans_length == 5
    save Segments.mat NumSegments SegChain cc NumFrames Xdim Ydim min_trans_length max_trans_dist
else
    save_name = ['Segments_minlength_' num2str(min_trans_length) '.mat'];
    save(save_name, 'NumSegments', 'SegChain', 'cc', 'NumFrames', 'Xdim', 'Ydim', 'min_trans_length', 'max_trans_dist')
end


end

