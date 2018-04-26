function Set_Custom_T_Params(moviefile, param_file_use )
% Set_custom_T_Params( param_file_use )
%   Use a specific Set_T_Params file.  Must be of the format
%   Set_T_Params1, Set_T_Params2, etc. Set_T_Params should NOT be modified,
%   but new ones should be created from it, modified and commented.

param_funcstr = ['Set_T_Params' num2str(param_file_use) '(''' moviefile ''')'];
eval(param_funcstr);

end

