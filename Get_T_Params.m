function [varargout] = Get_T_Params(varargin)
% [varargout] = Get_T_Params(varargin)
%
% loads Tenaspis parameters from global variable. Set_T_Params must be
% called before this in order to set this global variable
%
% Copyright 2016 by David Sullivan, Nathaniel Kinsky, and William Mau
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

global T_PARAMS;

varargout = cell(1,length(varargin));

for i = 1:length(varargin)
    if (strcmp(varargin{i},'Xdim'))
        varargout(i) = {T_PARAMS.Xdim};
    end
    
    if (strcmp(varargin{i},'Ydim'))
        varargout(i) = {T_PARAMS.Ydim};
    end
    
    if (strcmp(varargin{i},'NumFrames'))
        varargout(i) = {T_PARAMS.NumFrames};
    end
    
    if (strcmp(varargin{i},'FrameChunkSize'))
        varargout(i) = {T_PARAMS.FrameChunkSize};
    end
    
    if (strcmp(varargin{i},'LowPassRadius'))
        varargout(i) = {T_PARAMS.LowPassRadius};
    end
    
    if (strcmp(varargin{i},'HighPassRadius'))
        varargout(i) = {T_PARAMS.HighPassRadius};
    end
    
    if (strcmp(varargin{i},'threshold'))
        varargout(i) = {T_PARAMS.threshold};
    end
    
    if (strcmp(varargin{i},'threshsteps'))
        varargout(i) = {T_PARAMS.threshsteps};
    end
    
    if (strcmp(varargin{i},'MaxBlobRadius'))
        varargout(i) = {T_PARAMS.MaxBlobRadius};
    end
    
    if (strcmp(varargin{i},'MinBlobRadius'))
        varargout(i) = {T_PARAMS.MinBlobRadius};
    end
    
    if (strcmp(varargin{i},'MaxAxisRatio'))
        varargout(i) = {T_PARAMS.MaxAxisRatio};
    end
    
    if (strcmp(varargin{i},'MinSolidity'))
        varargout(i) = {T_PARAMS.MinSolidity};
    end
    
    if (strcmp(varargin{i},'BlobLinkThresholdCoeff'))
        varargout(i) = {T_PARAMS.BlobLinkThresholdCoeff};
    end
    
    if (strcmp(varargin{i},'MinNumFrames'))
        varargout(i) = {T_PARAMS.MinNumFrames};
    end
    
    if (strcmp(varargin{i},'MaxCentroidTravelDistance'))
        varargout(i) = {T_PARAMS.MaxCentroidTravelDistance};
    end
    
    if (strcmp(varargin{i},'MinPixelPresence'))
        varargout(i) = {T_PARAMS.MinPixelPresence};
    end
    
    if (strcmp(varargin{i},'ROICircleWindowRadius'))
        varargout(i) = {T_PARAMS.ROICircleWindowRadius};
    end
    
    if (strcmp(varargin{i},'DistanceThresholdList'))
        varargout(i) = {T_PARAMS.DistanceThresholdList};
    end
    
    if (strcmp(varargin{i},'MaxTransientMergeCorrP'))
        varargout(i) = {T_PARAMS.MaxTransientMergeCorrP};
    end
    
    if (strcmp(varargin{i},'MinTransientMergeCorrR'))
        varargout(i) = {T_PARAMS.MinTransientMergeCorrR};
    end
    
    if (strcmp(varargin{i},'ROIBoundaryCoeff'))
        varargout(i) = {T_PARAMS.ROIBoundaryCoeff};
    end
    
    if (strcmp(varargin{i},'AmplitudeThresholdCoeff'))
        varargout(i) = {T_PARAMS.AmplitudeThresholdCoeff};
    end
    
    if (strcmp(varargin{i},'CorrPthresh'))
        varargout(i) = {T_PARAMS.CorrPthresh};
    end
    
    if (strcmp(varargin{i},'MaxGapFillLen'))
        varargout(i) = {T_PARAMS.MaxGapFillLen};
    end    
    
    if (strcmp(varargin{i},'SlopeThresh'))
        varargout(i) = {T_PARAMS.SlopeThresh};
    end
    
    if (strcmp(varargin{i},'MinBinSimRank'))
        varargout(i) = {T_PARAMS.MinBinSimRank};
    end 
    
    if (strcmp(varargin{i},'ROIoverlapthresh'))
        varargout(i) = {T_PARAMS.ROIoverlapthresh};
    end
    
    if (strcmp(varargin{i},'MinPSALen'))
        varargout(i) = {T_PARAMS.MinPSALen};
    end
    
    if (strcmp(varargin{i},'SampleRate'))
        varargout(i) = {T_PARAMS.SampleRate};
    end
    
    if (strcmp(varargin{i},'SmoothSize'))
        varargout(i) = {T_PARAMS.SmoothSize};
    end
    
    if (strcmp(varargin{i},'MinNumPSAepochs'))
        varargout(i) = {T_PARAMS.MinNumPSAepochs};
    end
    
    if (strcmp(varargin{i},'MinNumTransients'))
        varargout(i) = {T_PARAMS.MinNumTransients};
    end
    
    if (strcmp(varargin{i},'tstack'))
        varargout(i) = {T_PARAMS.tstack};
    end
    
end

