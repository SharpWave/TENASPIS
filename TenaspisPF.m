function [ output_args ] = TenaspisPF()

%% Calculate place fields and accompanying statistics
CalculatePlacefields('201b','alt_inputs','T2output.mat','man_savename',...
    'PlaceMapsv2.mat','half_window',0,'minspeed',3);
PFstats;

end

