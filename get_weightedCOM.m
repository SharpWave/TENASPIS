function [ ICMask_weighted, COM_weighted, COM_unweighted ] = get_weightedCOM( ICcell,ICnzcell)
%UNTITLED Takes an IC and produces a weighted COM for that IC based on
%pixel intensity within the cell.
%   ICcell = cell of ICs, unthresholded
%   ICnzcell = cell of valid indices for ICs (non-zero IC values) 

ICMask_unweighted = cell(size(ICcell));
COM_unweighted = cell(size(ICcell));
ICMask_weighted = cell(size(ICcell));
COM_weighted = cell(size(ICcell));
for j = 1: size(ICcell,2)
    ICMask_weighted{j} = zeros(size(ICcell{1}));
    ICMask_unweighted{j} = zeros(size(ICcell{1}));
    
    ICMask_weighted{j}(ICnzcell{j}) = ICcell{j}(ICnzcell{j});
    ICMask_unweighted{j}(ICnzcell{j}) = ones(size(ICnzcell{j}));
    
    COM_weighted{j} = centerOfMass(ICMask_weighted{j});
    COM_unweighted{j} = centerOfMass(ICMask_unweighted{j});
end


end

