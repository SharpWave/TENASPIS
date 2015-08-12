function [init_date,init_sess] =  GetInitRegMaskInfo(animal_id)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

AI(1).animal = 'GCaMP6f_31';
AI(1).init_date = '09_29_2014';
AI(1).init_sess = 1;

AI(2).animal = 'GCamp6f_30';
AI(2).init_date = '11_11_2014';
AI(2).init_sess = 1;

AI(3).animal = 'GCamp6f_44';
AI(3).init_date = '07_10_2015';
AI(3).init_sess = 2;

AI(4).animal = 'GCamp6f_45';
AI(4).init_date = '08_05_2015';
AI(4).init_sess = 1;

for i = 1:length(AI)
    if (strcmpi(AI(i).animal,animal_id))
        init_date = AI(i).init_date;
        init_sess = AI(i).init_sess;
        return;
    end
end
        

end

