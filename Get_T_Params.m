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
        


end

