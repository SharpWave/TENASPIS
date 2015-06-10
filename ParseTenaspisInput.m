function [animal_id,sess_date,sess_num,no_movie_process,ManMask] = ParseTenaspisInput(args);
% [animal_id,sess_date,sess_num,no_movie_process] = ParseTenaspisInput(args);
animal_id = [];
sess_date = [];
sess_num = [];
no_movie_process = 0;
ManMask = 0;

for i = 1:length(args)
    if (mod(i,2) == 0)
        continue;
    end
    if (strcmp(args{i},'animal_id'))
        animal_id = args{i+1};
    end
    
    if (strcmp(args{i},'sess_date'))
        sess_date = args{i+1};
    end
    
    if (strcmp(args{i},'sess_num'))
        sess_num = args{i+1};
    end
    
    if (strcmp(args{i},'no_movie_process'))
        no_movie_process = args{i+1};
    end
    
    if (strcmp(args{i},'manual_mask'))
        ManMask = args{i+1};
    end
    
end

end

