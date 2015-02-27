function [ All_ICmask, ICnz_mask ] = create_AllICmask2( IC_cell,ICnz )
%[ All_ICmask, ICnz_mask ] = create_AllICmask2( IC_cell,ICnz )
% create_AllICmask Takes a cell array of individual IC masks and creates a
% single mask containing all the ICs in one array.  Note that IC_cell is the
% full, non-edited IC, and ICnz is the index of the values where the
% edited/masked IC is non-zero.
% ICnz_mask = IC with ones for the mask and zeros outside the masek


All_ICmask = zeros(size(IC_cell{1}));
ICnz_mask = cell(size(ICnz));
for j = 1:size(IC_cell,2)
    ICnz_mask{j} = zeros(size(IC_cell{j}));
    ICnz_mask{j}(ICnz{j}) = ones(size(ICnz{j}));
    All_ICmask = All_ICmask | ICnz_mask{j};
end

end

