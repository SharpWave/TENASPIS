function [MD, session_ref] = MakeMouseSessionList(userstr)
% this function makes a list of the location of all sessions on disk
% session_ref: gives you the start and end indices of session types, and currently are:
%   'G31_2env', 'G30_alternation'

CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

i = 1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '09_29_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\09_29_2014\working';
elseif strcmp(userstr,'Nat_laptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G31\09_29_2014';
elseif strcmp(userstr,'Nat')
    MD(i).Location = 'J:\GCamp Mice\Working\G31\09_29_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_01_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_01_2014\working';
elseif strcmp(userstr,'Nat_laptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G31\10_01_2014';
elseif strcmp(userstr,'Nat')
    MD(i).Location = 'J:\GCamp Mice\Working\G31\10_01_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_03_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_03_2014\working';
elseif strcmp(userstr,'Nat_laptop')
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G31\10_03_2014';
elseif strcmp(userstr,'Nat')
    MD(i).Location = 'J:\GCamp Mice\Working\G31\10_03_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_06_2014';
MD(i).Session = 1;
MD(i).Env = 'Home Cage';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_06_2014\1 - homecage 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_06_2014';
MD(i).Session = 2;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_06_2014\2 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_08_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_08_2014\1 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_08_2014';
MD(i).Session = 2;
MD(i).Env = 'Home Cage';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_08_2014\2 - homecage 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_10_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201A';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_10_2014\1 - triangle track 201A\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_10_2014';
MD(i).Session = 2;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_10_2014\2 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_14_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_14_2014\1 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_14_2014';
MD(i).Session = 2;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_14_2014\2 - triangle track rotated plus 120 201B\working';
end
MD(i).Notes = 'rotated +120 degrees';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_17_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_17_2014\1 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_17_2014';
MD(i).Session = 2;
MD(i).Env = 'Triangle Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_17_2014\2 - triangle open-field 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_20_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_20_2014\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_22_2014';
MD(i).Session = 1;
MD(i).Env = 'Triangle Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_22_2014\1 - triangle track 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_22_2014';
MD(i).Session = 2;
MD(i).Env = 'Triangle Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_22_2014\2 - triangle 201B\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_24_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_24_2014\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_27_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_27_2014\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_29_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_29_2014\working';
end
MD(i).Notes = 'Rotated 90 deg CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '10_31_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\10_31_2014\1 - square 201B';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_03_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\11_03_2014\1 - square track\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_03_2014';
MD(i).Session = 2;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\11_03_2014\2 - square\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_10_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Open Field';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\11_10_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_12_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Track';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_31\11_12_2014\working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_24_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\11_24_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_25_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\11_25_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_26_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\11_26_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_02_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_02_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_03_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_03_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_04_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_04_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_05_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_05_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_09_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_09_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_11_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'j:\GCamp Mice\Working\G31\alternation\12_11_2014\Working';
end
MD(i).Notes = [];

%% G31 2 env sessions
G31_2env(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_15_2014';
MD(i).Session = 1;
MD(i).Env = '2 env square right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_15_2014\1 - 2env square right\Working';
end
MD(i).Notes = 'Right';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_15_2014';
MD(i).Session = 2;
MD(i).Env = '2 env square left 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_15_2014\2 - 2env square left 90CW\Working';
end
MD(i).Notes = 'Left, Rotated 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_16_2014';
MD(i).Session = 1;
MD(i).Env = '2 env octagon left';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_16_2014\1 - 2env octagon left\Working';
end
MD(i).Notes = 'Left';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_16_2014';
MD(i).Session = 2;
MD(i).Env = '2 env octagon right 90CCW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_16_2014\2 - 2env octagon right 90CCW\Working';
end
MD(i).Notes = 'Right, Rotated 90CCW - Also, TONS of dropped frames in 2nd session - see .mat file on Pork_09';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_17_2014';
MD(i).Session = 1;
MD(i).Env = '2 env octagon right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_17_2014\1 - octagon right\Working';
end
MD(i).Notes = 'Right';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_17_2014';
MD(i).Session = 2;
MD(i).Env = '2 env octagon mid 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_17_2014\2 - octagon mid 90CW\Working';
end
MD(i).Notes = 'Mid, Rotated 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_18_2014';
MD(i).Session = 1;
MD(i).Env = '2 env square right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_18_2014\1 - 2env square right\Working';
end
MD(i).Notes = 'Right';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_18_2014';
MD(i).Session = 2;
MD(i).Env = '2 env square mid 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_18_2014\2 - 2env square mid 90CW\Working';
end
MD(i).Notes = 'Mid, Rotated 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_19_2014';
MD(i).Session = 1;
MD(i).Env = '2 env - standard square';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_19_2014\2env standard\Working\square';
end
MD(i).Notes = 'Mid, Standard';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_19_2014';
MD(i).Session = 2;
MD(i).Env = '2 env - standard octagon';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_19_2014\2env standard\Working\octagon';
end
MD(i).Notes = 'Mid, Standard';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_20_2014';
MD(i).Session = 1;
MD(i).Env = '2 env - 180 octagon';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_20_2014_nb\2 env 180\Working\octagon';
end
MD(i).Notes = 'Rotated 180';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_20_2014';
MD(i).Session = 2;
MD(i).Env = '2 env - 180 square';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_20_2014_nb\2 env 180\Working\square';
end
MD(i).Notes = 'Rotated 180';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_21_2014';
MD(i).Session = 1;
MD(i).Env = '2 env - square left';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_21_2014_nb\1 - 2env square left\Working';
end
MD(i).Notes = 'Left';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_21_2014';
MD(i).Session = 2;
MD(i).Env = '2 env - square mid 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_21_2014_nb\2 - 2env square mid 90CW\Working';
end
MD(i).Notes = 'Mid, Rotated 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_22_2014';
MD(i).Session = 1;
MD(i).Env = '2 env - octagon mid';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_22_2014_nb\1 - 2env octagon mid\Working';
end
MD(i).Notes = 'Mid';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_22_2014';
MD(i).Session = 2;
MD(i).Env = '2 env - octagon left 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_22_2014_nb\2 - 2env octagon left 90CW\Working';
end
MD(i).Notes = 'Left, Rotated 90CW';

G31_2env(2) = i;

%% Start of G30

G30_alternation(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_16_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_16_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\10_16_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_17_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_17_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\10_17_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_21_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_21_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\10_21_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_23_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_23_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\10_23_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_28_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_28_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\10_28_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '10_31_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\10_31_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\10_31_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_04_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'j:\GCamp Mice\Working\G30\alternation\11_04_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_04_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_06_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'j:\GCamp Mice\Working\G30\alternation\11_06_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_06_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_07_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'j:\GCamp Mice\Working\G30\alternation\11_07_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_07_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_10_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'j:\GCamp Mice\Working\G30\alternation\11_10_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_10_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_11_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_11_2014\Working';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_11_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_11_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_12_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_12_2014\Working';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_12_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_12_2014';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_13_2014';
MD(i).Session = 1;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_13_2014\Working';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_30\Alternation\11_13_2014';
end
MD(i).Notes = [];

G30_alternation(2) = i;

%% G30 2env experiment

G30_2env(1) = (i+1);

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_19_2014';
MD(i).Session = 1;
MD(i).Env = '2env - square left';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working';
end
MD(i).Notes = 'Left';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_19_2014';
MD(i).Session = 2;
MD(i).Env = '2env - square mid';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\2 - 2env square mid 201B\Working';
end
MD(i).Notes = 'Mid';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_20_2014';
MD(i).Session = 1;
MD(i).Env = '2env - octagon left';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_20_2014\1 - 2env octagon left\Working';
end
MD(i).Notes = 'Left';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_20_2014';
MD(i).Session = 2;
MD(i).Env = '2env - octagon right 90CCW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_20_2014\2 - 2env octagon right 90CCW\Working';
end
MD(i).Notes = 'Right, Rotated 90CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_21_2014';
MD(i).Session = 1;
MD(i).Env = '2env - octagon mid';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_21_2014\1 - 2env octagon mid 201B\Working';
end
MD(i).Notes = 'Mid';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_21_2014';
MD(i).Session = 2;
MD(i).Env = '2env - octagon left 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_21_2014\2 - 2env octagon left 90CW 201B\Working';
end
MD(i).Notes = 'Left, rotated 90CW';


i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_22_2014';
MD(i).Session = 1;
MD(i).Env = '2env - square right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_22_2014\1 - 2env square right 201B\Working';
end
MD(i).Notes = 'Right';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_22_2014';
MD(i).Session = 2;
MD(i).Env = '2env - square mid 90CW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_22_2014\2 - 2env square mid 90CW 201B\Working';
end
MD(i).Notes = 'Mid 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_23_2014';
MD(i).Session = 1;
MD(i).Env = '2env - combined';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_23_2014\Working';
end
MD(i).Notes = 'Mid - Standard';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_24_2014';
MD(i).Session = 1;
MD(i).Env = '2env - combined';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_24_2014\Working\rotate 180';
end
MD(i).Notes = 'Mid, Rotated 180';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_25_2014';
MD(i).Session = 1;
MD(i).Env = '2env - square left';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_25_2014\1 - 2env square left 201B\Working';
end
MD(i).Notes = 'Mid';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_25_2014';
MD(i).Session = 2;
MD(i).Env = '2env - square right 90CCW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_25_2014\2 - 2env square right 90CCW 201B\Working';
end
MD(i).Notes = 'Right 90CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_26_2014';
MD(i).Session = 1;
MD(i).Env = '2env - octagon right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_26_2014\1 - 2env octagon right 201B\Working';
end
MD(i).Notes = 'Right';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_26_2014';
MD(i).Session = 2;
MD(i).Env = '2env - octagon mid';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_26_2014\2 - 2 env octagon mid 201B\Working';
end
MD(i).Notes = 'Mid';

G30_2env(2) = i;

%% GCamp6f_44 starts here

G44(1) = (i+1);

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_08_2015';
MD(i).Session = 1;
MD(i).Env = 'homecage';
MD(i).Room = 'surgery';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_08_2015\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_09_2015';
MD(i).Session = 1;
MD(i).Env = 'homecage';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_09_2015\Session 1';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_10_2015';
MD(i).Session = 1;
MD(i).Env = 'homecage';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_10_2015\Session 1';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_10_2015';
MD(i).Session = 2;
MD(i).Env = 'homecage';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_10_2015\Session 2\Working';
end
MD(i).Notes = '';

G44_homecage(2) = i;

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_13_2015';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_13_2015\Session 1\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_13_2015';
MD(i).Session = 2;
MD(i).Env = 'square';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_13_2015\Session 2\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_14_2015';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_14_2015\Session 1\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_14_2015';
MD(i).Session = 2;
MD(i).Env = 'square';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_14_2015\Session 2\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_15_2015';
MD(i).Session = 1;
MD(i).Env = 'square';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_15_2015\Session 1\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_15_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_15_2015\Session 2\Working';
end
MD(i).Notes = 'Continuous reward';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_16_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_16_2015\Session 1\Working';
end
MD(i).Notes = 'continuous reward';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_16_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_16_2015\Session 2\Working';
end
MD(i).Notes = 'Rotated 120 CW, continuous reward';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_17_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_17_2015\Session 1\Working';
end
MD(i).Notes = 'Rotated 120 CW, fixed reward location';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_17_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_17_2015\Session 2\Working';
end
MD(i).Notes = 'fixed reward location';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_20_2015';
MD(i).Session = 1;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_20_2015\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_21_2015';
MD(i).Session = 1;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_21_2015\Session 1 - square\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_21_2015';
MD(i).Session = 2;
MD(i).Env = 'square track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_21_2015\Session 2 - square track\Working';
end
MD(i).Notes = '';



i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_22_2015';
MD(i).Session = 1;
MD(i).Env = 'square track';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_22_2015\Session 1 - square track\Working';
end
MD(i).Notes = '';


i = i+1;
MD(i).Animal = 'GCamp6f_44';
MD(i).Date = '07_22_2015';
MD(i).Session = 2;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G44\07_22_2015\Session 2 - square\Working';
end
MD(i).Notes = '';

G44(2) = i;

%% Start G45

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_05_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\1 - triangle\Working';
end
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_05_2015\1 - triangle';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_05_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2 - triangle\Working';
end
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_05_2015\2 - triangle';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_06_2015';
MD(i).Session = 1;
MD(i).Env = 'square track';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_06_2015\1 - square track';
elseif strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Square track\08_06_2014';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_06_2015';
MD(i).Session = 2;
MD(i).Env = 'square track';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_06_2015\2 - square track';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_10_2015';
MD(i).Session = 1;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_10_2015\1 - square open field';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_11_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_11_2015\1 - triangle open field';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_12_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_12_2015\1 - triangle open field';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_12_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_12_2015\2 - triangle track';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_13_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_13_2015\1 - triangle track';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_13_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_13_2015\2 - triangle open field';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_14_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle track';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_14_2015\1 - triangle track';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_18_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a';
if (strcmp(userstr,'Dave'))
    MD(i).Location = 'E:\GCaMP6f_45\8_18_2015\1 - alternation';
end
MD(i).Notes = '';



%% Start G41

i = i+1;
MD(i).Animal = 'GCamp6f_41';
MD(i).Date = '08_05_2015';
MD(i).Session = 1;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G41\08_05_2015\1 - square\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_41';
MD(i).Date = '08_05_2015';
MD(i).Session = 2;
MD(i).Env = 'square open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G41\08_05_2015\2 - square\Working';
end
MD(i).Notes = '';



%% Start G45

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_05_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\1 - triangle\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_05_2015';
MD(i).Session = 2;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\2 - triangle\Working';
end
MD(i).Notes = '';

%% Will's treadmill experiments
i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_02_2015';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_02_2015';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_03_2015';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_03_2015\1 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_03_2015';
MD(i).Session = 2;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_03_2015\2 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_04_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_04_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_04_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_04_2015\2 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_04_2015';
MD(i).Session = 3;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_04_2015\3 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_05_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_05_2015\1 - Homecage 1';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_05_2015';
MD(i).Session = 2;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_05_2015\2 - Homecage 2';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_05_2015';
MD(i).Session = 3;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_05_2015\3 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_06_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_06_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_06_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_06_2015\2 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_09_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_09_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_09_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_09_2015\2 - Acclimation';
end
MD(i).Notes = ['Actually treadmill shaping. Directory would not let me change folder name'];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_10_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_10_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_10_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_10_2015\2 - Treadmill shaping';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_11_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_11_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_11_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_11_2015\2 - Treadmill shaping';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_12_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_12_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_12_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_12_2015\2 - Treadmill shaping';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_13_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_13_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '11_13_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_13_2015\2 - Treadmill shaping';
end
MD(i).Notes = [];

%% Start of G48 in Will's Treadmill Experiments
i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_02_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_02_2015\';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_02_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_02_2015';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_03_2015';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_03_2015\1 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_03_2015';
MD(i).Session = 2;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_03_2015\2 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_04_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_04_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_04_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_04_2015\2 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_05_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_05_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_05_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_05_2015\2 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_06_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_06_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_06_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_06_2015\2 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_09_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_09_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_09_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_09_2015\2 - Treadmill shaping';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_10_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_10_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_10_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_10_2015\2 - Treadmill shaping';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_11_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_11_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_11_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_11_2015\2 - Treadmill shaping';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_12_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_12_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_12_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_12_2015\2 - Treadmill shaping';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_13_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_13_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '11_13_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_13_2015\2 - Treadmill shaping';
end
MD(i).Notes = [];

%% Compile session_ref

session_ref.G31_2env = G31_2env;
session_ref.G30_alternation = G30_alternation; 
session_ref.G44_homecage = G44_homecage;

%%
save MasterDirectory.mat MD;

cd(CurrDir);