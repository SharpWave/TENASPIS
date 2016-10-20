function [varargout] = Get_T_Params(varargin)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

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
        


end

