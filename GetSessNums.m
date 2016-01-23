function [SessNums] = GetSessNums(animalID)
% [SessNums] = GetSessNums(animalID,userID)
% Returns session index numbers for a particular animal for a particular
% user
% for use in multi-session data analysis
close all;
cd('C:\MasterData');
load MasterDirectory;
SessNums = [];

for i = 1:length(MD)
    if (strcmp(MD(i).Animal,animalID) & ~isempty(MD(i).Location))
        SessNums = [SessNums,i];
    end
    

end

