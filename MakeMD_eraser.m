function [MD, session_ref] = MakeMD_eraser(userstr)
% this function makes a list of the location of all sessions on disk
% session_ref: gives you the start and end indices of session types, and currently are:
%   'G31_2env', 'G30_alternation'

CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

Marble3(1) = 1;

i = 1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_05_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field -2';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180205_1_openfield\Imaging';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_05_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box -2';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180205_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_06_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field -1';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180206_1_openfield\Imaging';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_06_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box -1';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180206_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_07_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 0';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180207_1_openfield\Imaging';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_07_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 0';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180207_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';


i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_07_2018';
MD(i).Session = 3;
MD(i).Env = 'Square Open Field 4hr';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180207_3_openfield\Imaging';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_07_2018';
MD(i).Session = 4;
MD(i).Env = 'Shock Box 4hr';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180207_4_fcbox\Imaging';
end
MD(i).Notes = 'Missing';

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_08_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 1';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180208_1_openfield\Imaging';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_08_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 1';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180208_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_09_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 2';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180209_1_openfield\Imaging';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_09_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 2';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180209_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_15_2018';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field 7';
MD(i).Room = '610 Comm 721A';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180215_1_openfield\Imaging';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Marble3';
MD(i).Date = '02_15_2018';
MD(i).Session = 2;
MD(i).Env = 'Shock Box 7';
MD(i).Room = '610 Comm 721F';
if (strcmp(userstr,'norval'))
    MD(i).Location = 'E:\Eraser\Marble3\20180215_2_fcbox\Imaging';
end
MD(i).Notes = 'Missing';

Marble3(2) = i;

%% Compile session_ref

session_ref.Marble3 = Marble3;

%%
save MasterDirectory.mat MD;

cd(CurrDir);