function [ ] = makeT2Movies_batch( session_struct, movie_name )
% makeT2Movies_batch( session_struct,... )
%   Takes all the sessions indicated in session_struct and runs
%   MakeT2Movies on them.  Optional 2nd input to specify motion corrected
%   movie name(s) - either a single string or a cell array of strings for
%   each session in session_struct (default = 'ICmovie.h5')

%% Add default movie name
if nargin < 2
    for j = 1:length(session_struct)
        movie_name{j} = 'ICmovie.h5';
    end
end

%% Deal out movie name to cell if not specified already 
if ~iscell(movie_name)
    temp = movie_name;
    clear movie_name
    for j = 1:length(session_struct)
        movie_name{j} = temp;
    end
end

%% Run MakeT2Movies
for j = 1:length(session_struct)
    disp(['<<<< Running MakeT2Movies for ' session_struct(j).Animal ' Session ' ...
        num2str(session_struct(j).Session) ' on ' session_struct(j).Date ' >>>>'])
    try
        ChangeDirectory_NK(session_struct(j));
        MakeT2Movies(movie_name{j})
    catch
       disp('Error.  Skipped the previous session') 
    end

end

