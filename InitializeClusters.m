function [] = InitializeClusters(SegChain, cc, NumFrames, Xdim, Ydim, PeakPix, min_trans_length)
% [] = InitializeClusters(NumSegments, SegChain, cc, NumFrames, Xdim, Ydim)
%
% Initial shot at stringing together transients from all Segments
% identified in MakeTransients
%
% Copyright 2015 by David Sullivan and Nathaniel Kinsky
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of Tenaspis.
%
%     Tenaspis is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     Tenaspis is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with Tenaspis.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If min_trans_length is not specified, set it as default (5).
if ~exist('min_trans_length','var')
    min_trans_length = 5;
end

CircRad = 20;

NumTransients = length(SegChain);
GoodTr = zeros(1,NumTransients);

PixelList = cell(1,NumTransients);
Xcent = zeros(1,NumTransients);
Ycent = zeros(1,NumTransients);
frames = cell(1,NumTransients);
PixelAvg = cell(1,NumTransients);

resol = 1; % Percent resolution for progress bar, in this case 10%
p = ProgressBar(100/resol);
update_inc = round(NumTransients/(100/resol)); % Get increments for updating ProgressBar

disp('Finding initial ROI outline for each putative transient')
parfor i = 1:NumTransients
    % find initial ROI and organize the frames list
    [PixelList{i},frames{i},Xcent(i),Ycent(i)] = AvgTransient(SegChain{i},cc,Xdim,Ydim);
    
    % Note transients where no ROI could be drawn
    GoodTr(i) = ~isempty(PixelList{i}); % If trace has valid active pixels, keep
    
    % Update ProgressBar
    if round(i/update_inc) == (i/update_inc)
        p.progress; % Also percent = p.progress;
    end
end
p.stop; % Terminate progress bar

% edit out the faulty transients
GoodTrs = find(GoodTr);
PixelList = PixelList(GoodTrs);
frames = frames(GoodTrs);
Xcent = Xcent(GoodTrs);
Ycent = Ycent(GoodTrs);

% Booleanize frame lists for cross indexing
TransientBool = zeros(length(GoodTrs),NumFrames);

for i = 1:length(GoodTrs)
    TransientBool(i,frames{i}) = 1;
end

display('finding circle masks');

% get circular masks
for i = 1:length(GoodTrs)
    cm{i} = CircMask(Xdim,Ydim,CircRad,Xcent(i),Ycent(i));
    BigPixelAvg{i} = zeros(size(cm{i}));
    PixelAvg{i} = zeros(size(PixelList{i}));
end

% for each transient, across all of its frames, make an average within a certain radius
resol = 1; % Percent resolution for progress bar, in this case 10%
p = ProgressBar(100/resol);
update_inc = round(NumFrames/(100/resol)); % Get increments for updating ProgressBar
display('averaging a circular window around each transient');

for i = 1:NumFrames
    ActList = find(TransientBool(:,i));
    inframe = loadframe('SLPDF.h5',i);
    for j = 1:length(ActList)
        curr = ActList(j);
        BigPixelAvg{curr} = BigPixelAvg{curr} + inframe(cm{curr});
        PixelAvg{curr} = PixelAvg{curr} + inframe(PixelList{curr});
    end

    % Update ProgressBar
    if round(i/update_inc) == (i/update_inc)
        p.progress; % Also percent = p.progress;
    end
end
p.stop;

for i = 1:length(GoodTrs)
    BigPixelAvg{i} = BigPixelAvg{i}./length(frames{i});
    PixelAvg{i} = PixelAvg{i}./length(frames{i});
end

% FOR SOME REASON I RUN THIS THING HERE
c = (1:length(GoodTrs))';

save InitClu.mat c Xdim Ydim PixelList Xcent Ycent frames NumFrames PixelAvg BigPixelAvg cm min_trans_length -v7.3;



end

