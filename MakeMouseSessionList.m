function [MD, session_ref] = MakeMouseSessionList(userstr)
% this function makes a list of the location of all sessions on disk
% session_ref: gives you the start and end indices of session types, and currently are:
%   'G31_2env', 'G30_alternation'

CurrDir = pwd;

MasterDirectory = 'C:\MasterData';
cd(MasterDirectory);

G31.all(1) = 1;

i = 1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '09_29_2014';
MD(i).Session = 1;
MD(i).Env = 'Square Track';% 
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

%% G31 2 env sessions
G31.two_env(1) = i+1;

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
MD(i).Env = '2 env square left 90CCW';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_15_2014\2 - 2env square left 90CCW\Working';
end
MD(i).Notes = 'Left, Rotated 90CCW';

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
MD(i).Notes = 'Rotated 180 - Note that we lose basically half our data here because of the dropped frames, resulting in lower info scores, pvalues, etc.';
MD(i).exclude_frames = 13134:18969;

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
MD(i).exclude_frames = 13134:18969;

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

G31.two_env(2) = i;

%%

G31.two_env_debug(1) = i + 1;
i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_20_2014';
MD(i).Session = 3;
MD(i).Env = '2 env - 180 square';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_20_2014_nb\2 env 180\Working\debug square';
end
MD(i).Notes = 'Rotated 180 - trying to look at only first time in the square';
MD(i).exclude_frames = 24000:31614;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_20_2014';
MD(i).Session = 4;
MD(i).Env = '2 env - 180 octagon';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_20_2014_nb\2 env 180\Working\debug octagon';
end
MD(i).Notes = 'Rotated 180 - trying to look at only first time in the octagon';
MD(i).exclude_frames = 6500:31614;

G31.two_env_debug(2) = i;

%% G31 Alternation Sessions

G31.alternation(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_24_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\11_24_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\11_24_2014';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_25_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\11_25_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\11_25_2014';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '11_26_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\11_26_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\11_26_2014';
end
MD(i).Notes = '';
i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_02_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_02_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_02_2014';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_03_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_03_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_03_2014';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_04_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_04_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_04_2014';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_05_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_05_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_05_2014';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_05_2014';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_05_2014\Working\left trials';
end
MD(i).Notes = 'Correct Left Trials Only';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_05_2014';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_05_2014\Working\right trials';
end
MD(i).Notes = 'Correct Right Trials Only';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_09_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_09_2014\Working';
elseif (strcmp(userstr,'Will'))
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_31\Alternation\12_09_2014';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = '12_11_2014';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\alternation\12_11_2014\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'j:\GCamp Mice\Working\G31\alternation\12_11_2014\Working';
end
MD(i).Notes = '';

G31.alternation(2) = i;
G31.all(2) = i;

%% Transient Tweaking
G31.transient_tweak(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_31';
MD(i).Date = 'G31_trans_tweak';
MD(i).Session = 1;
MD(i).Env = '2 env square right';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G31\2env\12_15_2014\1 - 2env square right\Working';
end
MD(i).Notes = 'Use this folder for QCing transient length limit tweaking';

G31.transient_tweak(2) = i;

%% Start of G30

G30.all(1) = i+1;
G30.alternation(1) = i+1;

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
MD(i).Date = '11_12_2014';
MD(i).Session = 2;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_12_2014\Working\left trials';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_12_2014\Working';
end
MD(i).Notes = 'Correct Left Trials Only';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_12_2014';
MD(i).Session = 3;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_12_2014\Working\right trials';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_12_2014\Working';
end
MD(i).Notes = 'Correct Right Trials Only';

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

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_13_2014';
MD(i).Session = 2;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_13_2014\Working\left trials';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working';
end
MD(i).Notes = 'Correct Left Trials Only';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_13_2014';
MD(i).Session = 3;
MD(i).Env = 'Alternation';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\alternation\11_13_2014\Working\right trials';
elseif (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working';
end
MD(i).Notes ='Correct Right Trials Only';

G30.alternation(2) = i;

%% G30 2env experiment

G30.two_env(1) = (i+1);

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_19_2014';
MD(i).Session = 1;
MD(i).Env = '2env - square left';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working';
elseif strcmpi(userstr,'mouseimage')
    MD(i).Location = 'F:\GCamp6f_30\11_19_2014_nb\1 - 2env square left 201B\Working';
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
    elseif strcmpi(userstr,'mouseimage')
    MD(i).Location = 'F:\GCamp6f_30\11_19_2014_nb\2 - 2env square mid 201B\Working';
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
MD(i).Env = '2env - combined square';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_23_2014\2env standard\Working\square';
end
MD(i).Notes = 'Mid - Standard';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_23_2014';
MD(i).Session = 2;
MD(i).Env = '2env - combined octagon';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_23_2014\2env standard\Working\octagon';
end
MD(i).Notes = 'Mid - Standard';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_24_2014';
MD(i).Session = 1;
MD(i).Env = '2env - combined octagon';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_24_2014\rotate 180\Working\octagon';
end
MD(i).Notes = 'Mid, Rotated 180';

i = i+1;
MD(i).Animal = 'GCamp6f_30';
MD(i).Date = '11_24_2014';
MD(i).Session = 2;
MD(i).Env = '2env - combined square';
MD(i).Room = '2 Cu 201B';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\2env\11_24_2014\rotate 180\Working\square';
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
elseif strcmpi(userstr,'mouseimage');
    MD(i).Location = 'F:\GCamp6f_30\11_25_2014_nb\1 - 2env square left 201B\Working';
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
elseif strcmpi(userstr,'mouseimage');
    MD(i).Location = 'F:\GCamp6f_30\11_25_2014_nb\2 - 2env square right 90CCW 201B\Working';
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
elseif strcmpi(userstr,'mouseimage')
    MD(i).Location = 'F:\GCamp6f_30\11_26_2014_nb\2 - 2 env octagon mid 201B\Working';
end
MD(i).Notes = 'Mid';

G30.two_env(2) = i;
G30.all(2) = i;

%% G30 FC Pilot - note listed ast 30_2 because imaging looks very different than original G30 recordings...

G30.FC_pilot(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_30_2';
MD(i).Date = '06_10_2015';
MD(i).Session = 1;
MD(i).Env = 'FC';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\FC Pilot\06_10_2015\1 - shock baseline\Working';
end
MD(i).Notes = 'Day 1 - FC environment baseline';

i = i+1;
MD(i).Animal = 'GCamp6f_30_2';
MD(i).Date = '06_10_2015';
MD(i).Session = 2;
MD(i).Env = 'neutral';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\FC Pilot\06_10_2015\2 - neutral baseline\Working';
end
MD(i).Notes = 'Day 1 - neutral environment baseline';

i = i+1;
MD(i).Animal = 'GCamp6f_30_2';
MD(i).Date = '06_10_2015';
MD(i).Session = 3;
MD(i).Env = 'shock';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\FC Pilot\06_10_2015\3 - shock shock\Working';
end
MD(i).Notes = 'Day 1 - FC environment shock session';

i = i+1;
MD(i).Animal = 'GCamp6f_30_2';
MD(i).Date = '06_10_2015';
MD(i).Session = 4;
MD(i).Env = 'neutral';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\FC Pilot\06_10_2015\4 - neutral 3 hr\Working';
end
MD(i).Notes = 'Day 1 - neutral environment 3hr session';

i = i+1;
MD(i).Animal = 'GCamp6f_30_2';
MD(i).Date = '06_10_2015';
MD(i).Session = 5;
MD(i).Env = 'shock';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G30\FC Pilot\06_10_2015\5 - shock 3 hr\Working';
end
MD(i).Notes = 'Day 1 - FC environment 3hr session';

G30.FC_pilot(2) = i;

%% GCamp6f_44 starts here

G44.all(1) = (i+1);

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

G44.all(2) = i;

%% Start G45

G45.all(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_05_2015';
MD(i).Session = 1;
MD(i).Env = 'triangle open field';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat_laptop'))
    MD(i).Location = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G45\1 - triangle\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\08_05_2015\1 - triangle\Working';
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
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\08_05_2015\2 - triangle\Working';
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

%% G45 2env
G45.twoenv(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_28_2015';
MD(i).Session = 1;
MD(i).Env = '2env - square right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_28_2015\1 - square right\Working';
end
MD(i).Notes = 'square right';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_28_2015';
MD(i).Session = 2;
MD(i).Env = '2env - square left 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_28_2015\2 - square left 90CCW\Working';
end
MD(i).Notes = 'square left 90CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_29_2015';
MD(i).Session = 1;
MD(i).Env = '2env - octagon right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_29_2015\1 - oct right\Working';
end
MD(i).Notes = 'octagon right';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_29_2015';
MD(i).Session = 2;
MD(i).Env = '2env - octagon mid 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_29_2015\2 - oct mid 90CCW\Working';
end
MD(i).Notes = 'octagon mid 90CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_30_2015';
MD(i).Session = 1;
MD(i).Env = '2env - octagon mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_30_2015\1 - oct mid\Working';
end
MD(i).Notes = 'octagon mid';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_30_2015';
MD(i).Session = 2;
MD(i).Env = '2env - octagon mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_30_2015\2 - oct left 90CW\Working';
end
MD(i).Notes = 'octagon left 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_31_2015';
MD(i).Session = 1;
MD(i).Env = '2env - square left';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_31_2015\1 - square left\Working';
end
MD(i).Notes = 'square left';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '08_31_2015';
MD(i).Session = 2;
MD(i).Env = '2env - square mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\08_31_2015\2 - square mid 90CW\Working';
end
MD(i).Notes = 'square mid 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_01_2015';
MD(i).Session = 1;
MD(i).Env = '2env - standard';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_01_2015\Working';
end
MD(i).Notes = 'Standard Connected';


i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_01_2015';
MD(i).Session = 2;
MD(i).Env = '2env - standard square';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_01_2015\Working\square';
end
MD(i).Notes = 'Standard, square';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_01_2015';
MD(i).Session = 3;
MD(i).Env = '2env - standard octagon';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_01_2015\Working\octagon';
end
MD(i).Notes = 'Standard, octagon';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_02_2015';
MD(i).Session = 1;
MD(i).Env = '2env - connected 180';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_02_2015\2 env 180\Working';
end
MD(i).Notes = '2env connected - 180';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_02_2015';
MD(i).Session = 2;
MD(i).Env = '2env - connected 180 octagon';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_02_2015\2 env 180\Working\octagon';
end
MD(i).Notes = 'Rotated 180, Octagon';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_02_2015';
MD(i).Session = 3;
MD(i).Env = '2env - connected 180 square';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_02_2015\2 env 180\Working\square';
end
MD(i).Notes = 'Rotated 180, Square';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_03_2015';
MD(i).Session = 1;
MD(i).Env = '2env - square mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_03_2015\1 - square mid\Working';
end
MD(i).Notes = 'square mid';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_03_2015';
MD(i).Session = 2;
MD(i).Env = '2env - square right 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_03_2015\2 - square right 90CCW\Working';
end
MD(i).Notes = 'square right 90CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_04_2015';
MD(i).Session = 1;
MD(i).Env = '2env - octagon left';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_04_2015\1 - oct left\Working';
end
MD(i).Notes = 'octagon left';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_04_2015';
MD(i).Session = 2;
MD(i).Env = '2env - octagon right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_04_2015\2 - oct right 90CW\Working';
end
MD(i).Notes = 'octagon right 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_04_2015';
MD(i).Session = 3;
MD(i).Env = '2env - octagon mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_04_2015\3 - octagon mid\Working';
end
MD(i).Notes = 'octagon mid';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_04_2015';
MD(i).Session = 4;
MD(i).Env = '2env - octagon left 180';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_04_2015\4 - octagon left 180\Working';
end
MD(i).Notes = 'octagon left 180';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_05_2015';
MD(i).Session = 1;
MD(i).Env = '2env - square right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_05_2015\1 - square right\Working';
end
MD(i).Notes = 'square right';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_05_2015';
MD(i).Session = 2;
MD(i).Env = '2env - square mid 180';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\2env\09_05_2015\2 - square mid 180\Working';
end
MD(i).Notes = 'square mid 180';

G45.twoenv(2) = i;

%% G45 Alternation

G45.alternation(1) = i+1;

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

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_30_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\alternation\09_30_2015\1 - alternation\Working';
end
MD(i).Notes = 'Need to exclude timestamps in between two sessions';

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '09_30_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\alternation\09_30_2015\2 - alternation\Working';
end
MD(i).Notes = 'Need to exclude timestamps in between two sessions';
MD(i).exclude_frames = 14976:15233;

i = i+1;
MD(i).Animal = 'GCamp6f_45';
MD(i).Date = '10_02_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G45\alternation\10_02_2015\1 - alternation\Working';
end
MD(i).Notes = 'Need to exclude timestamps in between two sessions';
MD(i).exclude_frames = 13661:13980;

G45.alternation(2) = i;

%% Start of G45 Continuous-Delay Alternation Data
G45.alternation_delay_pilot(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_13_2016';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_13_2016\1 - alternation\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_13_2016\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_14_2016';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_14_2016\1 - alternation\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_14_2016\1 - all blocks combined\Working';
end
MD(i).Notes = '';
MD(i).exclude_frames = [12725:15025, 34405:36185, 49425:52245];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_14_2016';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_14_2016\1 - alternation\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_14_2016\2 - continuous\Working';
end
MD(i).Notes = 'Continuous blocks only';
MD(i).exclude_frames = [12725:36185, 49425:77637];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_14_2016';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_14_2016\1 - alternation\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_14_2016\3 - delay\Working';
end
MD(i).Notes = 'Delay blocks only';
MD(i).exclude_frames = [1:15025, 34405:52245];

G45.alternation_delay_pilot_good(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_18_2016\1 - alternation\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\1 - alternation combined\Working';
end
MD(i).Notes = '';
MD(i).exclude_frames = [10971:11371, 35211:35441, 45871:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_18_2016\2 - continuous only\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\2 - continuous only\Working';
end
MD(i).Notes = 'Continuous Data Only';
MD(i).exclude_frames = [10971:35441, 45871:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 3;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\01_18_2016\3 - delay only\Processed Data';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\3 - delay only\Working';
end
MD(i).Notes = 'Delay Data Only';
MD(i).exclude_frames = [1:11371, 35211:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 4;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\4 - 1st block continuous vs 1st block delay\Working';
end
MD(i).Notes = '1st continuous block and 1st delay block only';
MD(i).exclude_frames = [10971:11371, 35211:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 5;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\5 - 1st continuous block only\Working';
end
MD(i).Notes = '1st continuous block only';
MD(i).exclude_frames = [10971:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 6;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\6 - 2nd block continuous vs 1st block delay\Working';
end
MD(i).Notes = '2nd continuous block and 1st delay block only';
MD(i).exclude_frames = [1:11371, 35211:35441, 45871:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 6;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\7 - 2nd continuous block only\Working';
end
MD(i).Notes = '2nd continuous block only';
MD(i).exclude_frames = [1:35441, 45871:46175];

i = i+1;
MD(i).Animal = 'GCamp6f_45_altpilot';
MD(i).Date = '01_18_2016';
MD(i).Session = 7;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\delay alternation pilot\01_18_2016\1 - alternation combined\Working T2';
end
MD(i).Notes = 'Tenaspis 2';
MD(i).exclude_frames = [10971:11371, 35211:35441, 45871:46175];

G45.alternation_delay_pilot(2) = i;
G45.alternation_delay_pilot_good(2) = i;

%% G45 DNMP Task 
G45.DNMP(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_45_DNMP';
MD(i).Date = '04_01_2016';
MD(i).Session = 1;
MD(i).Env = 'DNMP';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\04_01_2016\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\DNMP\04_01_2016\Working';
end
MD(i).Notes = 'Tenaspis 2';
MD(i).exclude_frames = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_DNMP';
MD(i).Date = '04_04_2016';
MD(i).Session = 1;
MD(i).Env = 'DNMP';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\04_04_2016\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\DNMP\04_04_2016\Working';
end
MD(i).Notes = 'Tenaspis 2';
MD(i).exclude_frames = [2679:2975, 4592:4863, 6806:7040, 8295:10420, ...
    15850:16075, 17113:17318, 17520:18336, 25831:26053, 28009:29419, ...
    29668:31476, 33282:33661, 36544:36986];

i = i+1;
MD(i).Animal = 'GCamp6f_45_DNMP';
MD(i).Date = '04_05_2016';
MD(i).Session = 1;
MD(i).Env = 'DNMP';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\04_05_2016\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\DNMP\04_05_2016\Working';
end
MD(i).Notes = 'Tenaspis 2';
MD(i).exclude_frames = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_DNMP';
MD(i).Date = '04_05_2016';
MD(i).Session = 2;
MD(i).Env = 'DNMP';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'mouseimage'))
    MD(i).Location = 'M:\GCamp6f_45\04_05_2016\Working';
elseif (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G45\DNMP\04_05_2016\Working after Nat_T2edits';
end
MD(i).Notes = 'Tenaspis 2';
MD(i).exclude_frames = [];



G45.DNMP(2) = i;
G45.all(2) = i;

%% Start G41

G41.all(1) = i+1;

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

G41.all(2) = i;

%% Start G46

G46.all(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_46';
MD(i).Date = '08_14_2015';
MD(i).Session = 1;
MD(i).Env = 'homecage';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G46\08_14_2015\1 - homecage plus 1_25\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_46';
MD(i).Date = '08_14_2015';
MD(i).Session = 2;
MD(i).Env = 'homecage';
MD(i).Room = '201a';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G46\08_14_2015\2 - homecage plus 2_25\Working';
end
MD(i).Notes = '';

G46.all(2) = i;

%% Start G48
G48.all(1) = i+1;

%% Start G48 2env
G48.twoenv(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_29_2015';
MD(i).Session = 1;
MD(i).Env = 'square right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\08_29_2015\1 - square right\Working';
end
MD(i).Notes = 'square right';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_29_2015';
MD(i).Session = 2;
MD(i).Env = 'square left 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\08_29_2015\2 - square left 90CCW\Working';
end
MD(i).Notes = 'square left 90CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_30_2015';
MD(i).Session = 1;
MD(i).Env = 'octagon mid';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\08_30_2015\1 - oct mid\Working';
end
MD(i).Notes = 'octagon mid';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_30_2015';
MD(i).Session = 2;
MD(i).Env = 'octagon left 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\08_30_2015\2 - oct left 90CCW\Working';
end
MD(i).Notes = 'octagon left 90CCW';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_31_2015';
MD(i).Session = 1;
MD(i).Env = 'octagon right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\08_31_2015\1 - oct right\Working';
end
MD(i).Notes = 'octagon right';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '08_31_2015';
MD(i).Session = 2;
MD(i).Env = 'octagon mid 90CW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\08_31_2015\2 - oct mid 90CW\Working';
end
MD(i).Notes = 'octagon mid 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_01_2015';
MD(i).Session = 1;
MD(i).Env = 'square left';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\09_01_2015\1 - square left\Working';
end
MD(i).Notes = 'square left';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_01_2015';
MD(i).Session = 2;
MD(i).Env = 'square mid 90CW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\09_01_2015\2 - square mid 90CW\Working';
end
MD(i).Notes = 'square mid 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_02_2015';
MD(i).Session = 1;
MD(i).Env = '2env standard - square';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\09_02_2015\2env standard\Working\square';
end
MD(i).Notes = '2env standard - square';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_02_2015';
MD(i).Session = 2;
MD(i).Env = '2env standard - octagon';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\09_02_2015\2env standard\Working\octagon';
end
MD(i).Notes = '2env standard - octagon';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_03_2015';
MD(i).Session = 1;
MD(i).Env = '2env 180 - octagon';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\09_03_2015\1 - 2env 180\Working\octagon';
end
MD(i).Notes = '2env - Octagon Rotated 180';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_03_2015';
MD(i).Session = 2;
MD(i).Env = '2env 180 - square';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\09_03_2015\1 - 2env 180\Working\square';
end
MD(i).Notes = '2env - Square Rotated 180';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_04_2015';
MD(i).Session = 1;
MD(i).Env = 'square right';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\09_04_2015\1 - square right\Working';
end
MD(i).Notes = 'square right';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_04_2015';
MD(i).Session = 2;
MD(i).Env = 'square mid 90CW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\09_04_2015\2 - square mid 90CW\Working';
end
MD(i).Notes = 'square mid 90CW';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_05_2015';
MD(i).Session = 1;
MD(i).Env = 'octagon left';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\09_05_2015\1 - oct left\Working';
end
MD(i).Notes = 'octagon left';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '09_05_2015';
MD(i).Session = 2;
MD(i).Env = 'octagon right 90CCW';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'E:\GCamp Mice\G48\2env\09_05_2015\2 - oct right 90CCW\Working';
end
MD(i).Notes = 'octagon right 90CCW';

G48.twoenv(2) = i;

%% G48 Alternation

G48.alternation(1) = i+1;

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_16_2015';
MD(i).Session = 1;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\10_16_2015\1 - alternation\Working';
end
MD(i).Notes = '';

i = i+1;
MD(i).Animal = 'GCamp6f_48';
MD(i).Date = '10_16_2015';
MD(i).Session = 2;
MD(i).Env = 'alternation';
MD(i).Room = '201a - 2015';
if (strcmp(userstr,'Nat'))
    MD(i).Location = 'J:\GCamp Mice\Working\G48\alternation\10_16_2015\2 - alternation\Working';
end
MD(i).Notes = '';

G48.alternation(2) = i;
G48.all(2) = i;

%% Will's treadmill experiments

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_02_2015';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_02_2015';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_03_2015';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_03_2015\1 - Acclimation';
end
MD(i).Notes = [];


i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_03_2015';
MD(i).Session = 2;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_03_2015\2 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_04_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_04_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_04_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_04_2015\2 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_04_2015';
MD(i).Session = 3;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_04_2015\3 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_05_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_05_2015\1 - Homecage 1';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_05_2015';
MD(i).Session = 2;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_05_2015\2 - Homecage 2';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_05_2015';
MD(i).Session = 3;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_05_2015\3 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_06_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_06_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_06_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_06_2015\2 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_09_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_09_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_09_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '11:40:09 AM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_09_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

% i = i+1;
% MD(i).Animal = 'GCamp6f_45_treadmill';
% MD(i).Date = '11_09_2015';
% MD(i).Session = 2;
% MD(i).Env = 'Treadmill Loop';
% MD(i).Room = '2 Cu 201B';
% if strcmp(userstr,'Will')
%     MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_09_2015\2 - Acclimation';
% end
% MD(i).Notes = 'Actually treadmill shaping. Directory would not let me change folder name';

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_12_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '2:30:10 PM'; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_12_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_13_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_13_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_13_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '11:43:34 AM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_13_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_16_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '1:45:50 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_16_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

% i = i+1;
% MD(i).Animal = 'GCamp6f_45_treadmill';
% MD(i).Date = '11_16_2015';
% MD(i).Session = 2;
% MD(i).Env = 'Treadmill Loop';
% MD(i).Room = '2 Cu 201B';
% if strcmp(userstr,'Will')
%     MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_16_2015\2 - Treadmill shaping';
% end
% MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_18_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_18_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_18_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '1:22:24 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_18_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_19_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '4:42:32 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_19_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_20_2015';
MD(i).Session = 2;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_20_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_20_2015';
MD(i).Session = 3;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '10:47:51 AM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_20_2015\3 - Treadmill (left) T2';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_23_2015';
MD(i).Session = 3;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '5:50:28 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_23_2015\3 - Treadmill (left) T2';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_25_2015';
MD(i).Session = 3;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:52:50 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_25_2015\3 - Treadmill (left) T2';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_26_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '5:19:02 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_26_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_27_2015';
MD(i).Session = 3;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '1:14:29 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_27_2015\3 - Treadmill (left) T2';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_30_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_30_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_30_2015';
MD(i).Session = 3;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '11:07:40.34 AM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_30_2015\3 - Treadmill (left) T2';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '11_30_2015';
MD(i).Session = 4;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
MD(i).RecordStartTime = '11:07:40.34 AM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\11_30_2015\4 - Treadmill (left) T3';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '12_01_2015';
MD(i).Session = 3;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256;
MD(i).RecordStartTime = '2:22:59.00 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\12_01_2015\3 - Treadmill (left) T2';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '12_01_2015';
MD(i).Session = 4;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256;
MD(i).RecordStartTime = '2:22:59.00 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\12_01_2015\4 - Treadmill (left) T3';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '12_02_2015';
MD(i).Session = 3;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256;
MD(i).RecordStartTime = '5:22:31.31 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\12_02_2015\3 - Treadmill (left) T2';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '12_02_2015';
MD(i).Session = 4;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256;
MD(i).RecordStartTime = '5:22:31.31 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\12_02_2015\4 - Treadmill (left) T3';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '12_03_2015';
MD(i).Session = 3;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256;
MD(i).RecordStartTime = '5:38:20.92 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\12_03_2015\3 - Treadmill (left) T2';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '12_03_2015';
MD(i).Session = 4;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256;
MD(i).RecordStartTime = '5:38:20.92 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\12_03_2015\4 - Treadmill (left) T3';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '01_12_2016';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256;
MD(i).RecordStartTime = '5:16:21.83 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\01_12_2016\2 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '01_28_2016';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Figure 8';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256;
MD(i).RecordStartTime = '1:50:26.59 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\01_28_2016\2 - Treadmill (blocked alternation)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '02_01_2016';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Figure 8';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256;
MD(i).RecordStartTime = '2:56:04.34 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\02_01_2016\2 - Treadmill (blocked alternation)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '02_08_2016';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Figure 8';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256;
MD(i).RecordStartTime = '4:00:10.06 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\02_08_2016\2 - Treadmill (free alternation)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '02_09_2016';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Figure 8';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256;
MD(i).RecordStartTime = '4:11:39.80 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\02_09_2016\2 - Treadmill (free alternation)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '02_18_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:40:48.25 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\02_18_2016\1 - Treadmill (free alternation) T2';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '02_19_2016';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Figure 8';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '3:08:08.59 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\02_19_2016\2 - Treadmill (free alternation)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '02_25_2016';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '3:51:48.86 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\02_25_2016\2 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '02_26_2016';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '10:56:24.64 AM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\02_26_2016\2 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_45_treadmill';
MD(i).Date = '03_09_2016';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '10:34:38.51 AM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_45\Treadmill\03_09_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

%% Start of G48 in Will's Treadmill Experiments
i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_09_2015';
MD(i).Session = 1;
MD(i).Env = 'Homecage';
MD(i).Room = '2 Cu 201B';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_09_2015\1 - Homecage';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_09_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '2:30:04 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_09_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_10_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:31:12 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_10_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_11_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '4:04:02 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_11_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_12_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:31:08 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_12_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_16_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '3:01:53 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_16_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_18_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '5:32:18 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_18_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_19_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:38:14 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_19_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_20_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:38:14 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_20_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_23_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:38:14 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_23_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_24_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:38:14 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_24_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_25_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:38:14 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_25_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_26_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '4:32:16 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_26_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_27_2015';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '2:03:07 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_27_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '11_30_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '2:02:31.75 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\11_30_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '12_01_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '1:04:08.66 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\12_01_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];


i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '12_02_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '2:04:48.33 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\12_02_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '12_03_2015';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '1:00:54.06 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\12_03_2015\2 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '02_01_2016';
MD(i).Session = 2;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '4:08:54.59 PM';
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\02_01_2016\2 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '04_14_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '3:29:50.92 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\04_14_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '04_15_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '3:38:45.95 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\04_15_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '04_18_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '11:31:16 AM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\04_18_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '04_19_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '3:25:21.51 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\04_19_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '04_20_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:24:30.31 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\04_20_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '04_21_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:48:07.95 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\04_21_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '04_25_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '1:52:33.25 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\04_25_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '04_26_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '11:57:19.58 AM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\04_26_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '04_27_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '2:35:24.94 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\04_27_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '04_28_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:44:57.88 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\04_28_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'GCamp6f_48_treadmill';
MD(i).Date = '04_29_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '1:21:17.19 PM';
MD(i).Pix2CM = 0.1256;
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\GCaMP6f_48\Treadmill\04_29_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];


%% T2 folders


%% Aquila
i = i+1;
MD(i).Animal = 'Aquila';
MD(i).Date = '04_20_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Aquila\Treadmill\04_20_2016\1 - Acclimation';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Aquila';
MD(i).Date = '04_28_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '12:05:55.98 PM'; 
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Aquila\Treadmill\04_28_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Aquila';
MD(i).Date = '05_13_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '2:47:59.26 PM'; 
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Aquila\Treadmill\05_13_2016\1 - Treadmill (right)';
end
MD(i).Notes = [];

%% Libra
i = i+1;
MD(i).Animal = 'Libra';
MD(i).Date = '05_02_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Libra\Treadmill\05_02_2016\1 - Acclimation (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Libra';
MD(i).Date = '05_13_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '3:18:33.34 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Libra\Treadmill\05_13_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

%% Bellatrix
i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '06_13_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '4:07:35.95 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\06_13_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '06_14_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\06_14_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '06_20_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).RecordStartTime = '5:15:04.69 PM';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\06_20_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '06_22_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).RecordStartTime = '6:18:52.22 PM';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\06_22_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '06_23_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).RecordStartTime = '3:42:53.73 PM';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\06_23_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '06_24_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).RecordStartTime = '4:57:00.53 PM';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\06_24_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '06_25_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).RecordStartTime = '5:47:40.66 PM';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\06_25_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '07_05_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).RecordStartTime = '5:34:18.66 PM';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\07_05_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '07_06_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).RecordStartTime = '5:47:38.56 PM';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\07_06_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '07_07_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).RecordStartTime = '5:41:52.92 PM';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\07_07_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '07_08_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).RecordStartTime = '5:25:56.42 PM';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\07_08_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Bellatrix';
MD(i).Date = '07_09_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).RecordStartTime = '6:09:02.94 PM';
MD(i).Room = '2 Cu 201B';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Bellatrix\07_09_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];


%% Polaris
i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '06_13_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '3:33:09.45 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\06_13_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '06_14_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '5:30:26.36 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\06_14_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '06_21_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '6:14:34.20 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\06_21_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '06_22_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '5:41:53.25 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\06_22_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '06_23_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '4:20:40.95 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\06_23_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '06_24_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '4:24:36.89 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\06_24_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '06_25_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '6:34:45.64 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\06_25_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '06_27_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '4:56:47.22 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\06_27_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '07_05_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '6:13:59.78 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\07_05_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '07_06_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '5:13:19.14 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\07_06_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '07_07_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '6:28:13.34 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\07_07_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '07_08_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '4:38:16.86 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\07_08_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Polaris';
MD(i).Date = '07_09_2016';
MD(i).Session = 1;
MD(i).Env = 'Treadmill Loop';
MD(i).Room = '2 Cu 201B';
MD(i).RecordStartTime = '6:50:27.53 PM';
MD(i).Pix2CM = 0.1256; 
if strcmp(userstr,'Will')
    MD(i).Location = 'E:\Imaging Data\Endoscope\Polaris\07_09_2016\1 - Treadmill (left)';
end
MD(i).Notes = [];

%% Start Rats

i = i+1;
MD(i).Animal = 'Sol';
MD(i).Date = '07_19_2016';
MD(i).Session = 1;
MD(i).Env = 'Radial Arm Maze Center';
MD(i).Room = '2 Cu 201D';
MD(i).RecordStartTime = '';
MD(i).Pix2CM = NaN; 
if strcmp(userstr,'mouseimage')
    MD(i).Location = 'M:\Rat mPFC pilot\Sol\Imaging Sessions\07_19_2016\Working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Sol';
MD(i).Date = '07_25_2016';
MD(i).Session = 1;
MD(i).Env = 'Radial Arm Maze Center';
MD(i).Room = '2 Cu 201D';
MD(i).RecordStartTime = '';
MD(i).Pix2CM = NaN; 
if strcmp(userstr,'mouseimage')
    MD(i).Location = 'M:\Rat mPFC pilot\Sol\Imaging Sessions\07_25_2016\Working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Luke';
MD(i).Date = '07_18_2016';
MD(i).Session = 1;
MD(i).Env = 'Radial Arm Maze Center';
MD(i).Room = '2 Cu 201D';
MD(i).RecordStartTime = '';
MD(i).Pix2CM = NaN; 
if strcmp(userstr,'mouseimage')
    MD(i).Location = 'M:\Rat mPFC pilot\Luke\Imaging Sessions\07_18_2016\Working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Qui Gon';
MD(i).Date = '07_25_2016';
MD(i).Session = 1;
MD(i).Env = 'Radial Arm Maze Center';
MD(i).Room = '2 Cu 201D';
MD(i).RecordStartTime = '';
MD(i).Pix2CM = []; 
if strcmp(userstr,'mouseimage')
    MD(i).Location = 'M:\Rat mPFC pilot\Qui Gon\Imaging Sessions\07_25_2016\session 1\Working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Qui Gon';
MD(i).Date = '07_31_2016';
MD(i).Session = 1;
MD(i).Env = 'Object Context';
MD(i).Room = 'Keene';
MD(i).RecordStartTime = '';
MD(i).Pix2CM = NaN; 
if strcmp(userstr,'mouseimage')
    MD(i).Location = 'M:\Rat mPFC pilot\Qui Gon\Imaging Sessions\07_31_2016\Working';
end
MD(i).Notes = [];

i = i+1;
MD(i).Animal = 'Mace';
MD(i).Date = '07_20_2016';
MD(i).Session = 1;
MD(i).Env = 'Radial Arm Maze Center';
MD(i).Room = '2 Cu 201D';
MD(i).RecordStartTime = '';
MD(i).Pix2CM = NaN; 
if strcmp(userstr,'mouseimage')
    MD(i).Location = 'M:\Rat mPFC pilot\Mace\Imaging Sessions\07_20_2016\Working';
end
MD(i).Notes = [];  

i = i+1;
MD(i).Animal = 'Mace';
MD(i).Date = '10_05_2016';
MD(i).Session = 1;
MD(i).Env = 'DNMP';
MD(i).Room = '201H';
MD(i).RecordStartTime = '';
MD(i).Pix2CM = NaN; 
if strcmp(userstr,'mouseimage')
    MD(i).Location = 'H:\Rat mPFC\Mace\10_05_2016\Working';
end
MD(i).Notes = []; 

i = i+1;
MD(i).Animal = 'Mace';
MD(i).Date = '10_05_2016';
MD(i).Session = 2;
MD(i).Env = 'DNMP';
MD(i).Room = '201H';
MD(i).RecordStartTime = '';
MD(i).Pix2CM = NaN; 
if strcmp(userstr,'mouseimage')
    MD(i).Location = 'H:\Rat mPFC\Mace\10_05_2016\Working\ICWorking';
end
MD(i).Notes = 'Hack using IC output'; 

i = i+1;
MD(i).Animal = 'Mace';
MD(i).Date = '10_05_2016';
MD(i).Session = 3;
MD(i).Env = 'DNMP';
MD(i).Room = '201H';
MD(i).RecordStartTime = '';
MD(i).Pix2CM = NaN; 
if strcmp(userstr,'mouseimage')
    MD(i).Location = 'H:\Rat mPFC\Mace\10_05_2016\Working\ICWorking\speed thresh = 0';
end
MD(i).Notes = 'Hack using IC output - speed thresh = 0'; 

i = i+1;
MD(i).Animal = 'Mace';
MD(i).Date = '10_06_2016';
MD(i).Session = 1;
MD(i).Env = 'DNMP';
MD(i).Room = '201H';
MD(i).RecordStartTime = '';
MD(i).Pix2CM = NaN; 
if strcmp(userstr,'mouseimage')
    MD(i).Location = 'H:\Rat mPFC\Mace\10_06_2016\Working';
end
MD(i).Notes = ''; 

%% Compile session_ref

session_ref.G30 = G30;
session_ref.G31 = G31;
session_ref.G41 = G41;
session_ref.G44 = G44;
session_ref.G45 = G45;
session_ref.G46 = G46;
session_ref.G48 = G48;

%%
save MasterDirectory.mat MD;

cd(CurrDir);

% loadMD; % What is this?
