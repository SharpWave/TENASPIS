function [ All_ICmask ] = create_AllICmask( IC_cell )
% [ All_ICmask ] = create_AllICmask( IC_cell )
% create_AllICmask Takes a cell array of individual IC masks and creates a
% single mask containing all the ICs in one array.


All_ICmask = zeros(size(IC_cell{1}));
for j = 1:size(IC_cell,2)
%     All_ICmask = All_ICmask + IC_cell{j};
    All_ICmask = All_ICmask | IC_cell{j};
end

All_ICmask = double(All_ICmask);
end

