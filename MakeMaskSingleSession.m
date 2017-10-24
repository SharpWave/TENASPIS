function MakeMaskSingleSession(movie,varargin)
% MakeMaskSingleSession(movie)
% 
%   Makes a mask of the field of view after displaying a maximum
%   projection. Circle over a large area where you see cells. Saves as
%   singlesessionmask.mat with a logical matrix called neuronmask that is
%   true in the area over the mask.
%
%   INPUT
%       movie: file name of movie you want to draw mask on. Must be same
%       dimensions as other movies in directory. 
%
%       optional: 'phoneNumber', Phone number in the form xxxxxxxxxx,
%       xxx-xxx-xxxx, or (xxx)-xxx-xxxx if you want to get a text when this
%       function requires user input. If you want to use this feature,
%       REQUIRES ADDITIONAL SETUP. 
%
%       Set up for texting: Download function from http://bit.ly/2i1XqZn
%       and extract to a directory in your Matlab path. Follow the
%       directions in send_msg.m (help send_msg.m). 
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

close all;

p = inputParser;
p.addRequired('movie'); 
p.addParameter('phoneNumber',[]); 

p.parse(movie,varargin{:});
phoneNumber = p.Results.textme; 

% Get movie information. 
[Xdim,Ydim,NumFrames] = Get_T_Params('Xdim','Ydim','NumFrames');

% step 1 build up a maximum projection, using every 5th frame
newmax = zeros(Xdim,Ydim);
for i = 1:5:NumFrames
    temp = LoadFrames(movie,i);
    newmax(temp > newmax) = temp(temp > newmax);
end

%% Draw mask. 
figure;
ToContinue = 'n';
disp('draw a circle around the area with good cells');
while ~(strcmp(ToContinue,'y'))
    [neuronmask, xi, yi] = roipoly(imadjust(newmax));
    figure;imagesc_gray(imadjust(newmax));
    hold on
    plot(xi, yi,'r')
    
    %Want spend even MORE time analyzing data than you should be?? Neglect
    %your other duties and get roped into the processing 
    if ~isempty(phoneNumber)
        send_msg({phoneNumber},' ','Draw mask please','AT&T');
    end
    
    ToContinue = input('OK with the mask you just drew? [y/n] --->','s');
end

%% Save.
save singlesessionmask.mat neuronmask;

end

