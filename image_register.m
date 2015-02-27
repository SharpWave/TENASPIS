function [ ] = image_register(base_file, register_file, cell_map, cell_map_header)
% Image Registration Function

% To do:
% 1) Make sure each figure has a title and legend/colorbar
% 2) Create matrix or cell array for mapping cells.  Each column
% corresponds to a given session, each row the independent component that
% corresponds to a given cell for that session.  0 = not active?

%% MAGIC VARIABLES
configname = 'monomodal'; % For images taken with similar contrasts, e.g. from the same device, same gain, etc.
regtype = 'similarity'; % Similarity = Translation, Rotation, Skewing

%% Step 1: Select images to compare and import the images

if nargin == 0
[base_filename, base_path, filterindexbase] = uigetfile('*.tif',...
    'Pick the base image file: ');
base_file = [base_path base_filename];

[reg_filename, reg_path, filterindexbase] = uigetfile('*.tif',...
    'Pick the image file to register with the base file: ',[base_path base_filename]);
register_file = [reg_path reg_filename];
elseif nargin == 1
    error('Please input both a base file and file to register to base file')
elseif nargin == 2
    base_filename = base_file(max(regexp(base_file,'\','end'))+1:end);
    base_path = base_file(1:max(regexp(base_file,'\','end')));
    reg_filename = register_file(max(regexp(register_file,'\','end'))+1:end);
    reg_path = register_file(1:max(regexp(register_file,'\','end')));
end

base_image = im2double(imread(base_file));
reg_image = im2double(imread(register_file));

%% Step 2: Run Registration Functions, get transform

[optimizer, metric] = imregconfig(configname);
[moving_reg r_reg] = imregister(reg_image, base_image, regtype, optimizer, metric);
tform = imregtform(reg_image, base_image, regtype, optimizer, metric);

% Plot original images, registered image, and base-registered for quality
% control check
figure(1)
subplot(2,2,1)
imagesc(base_image); colormap(gray); colorbar
title('Base Image');
subplot(2,2,2)
imagesc(reg_image); colormap(gray); colorbar
title('Image to Register');
subplot(2,2,3)
imagesc(moving_reg); colormap(gray); colorbar
title('Registered Image')
subplot(2,2,4)
imagesc(abs(moving_reg - base_image)); colormap(gray); colorbar
title('Registered Image - Base Image')

%% Step 3: Take Good ICs from registered image and overlay them onto base image

% Load data for ICs: Here I assume that the data files lie in the same directories as the
% reference images

base_data = importdata([base_path 'FLdata.mat']);
reg_data = importdata([reg_path 'FLdata.mat']);

% Pull Data from GoodICF, tag?

AllIC = zeros(size(base_data.GoodICf{1}));
for j = 1:size(base_data.GoodICf,2)
   AllIC = AllIC + base_data.GoodICf{j};
end
base_data.AllIC = AllIC;

AllIC = zeros(size(reg_data.GoodICf{1}));
for j = 1:size(reg_data.GoodICf,2)
   AllIC = AllIC + reg_data.GoodICf{j};
end
reg_data.AllIC = AllIC;


% Register AllIC_reg to AllIC_base
AllIC_reg = imwarp(reg_data.AllIC,tform,'OutputView',imref2d(size(base_image)));


% Plot out both...

figure(2)
subplot(3,1,1)
imagesc(base_data.AllIC); title('Base Image Cells')
subplot(3,1,2)
imagesc(AllIC_reg*2); title('Registered Image Cells')
subplot(3,1,3)
imagesc(base_data.AllIC+ AllIC_reg*2); title('Combined Image Cells'); colormap(jet)
h = colorbar('YTick',[0 1 2 3],'YTickLabel', {'','Base Image Cells','Reg Image Cells','Overlapping Cells'});


%% Step 4: Visually scroll through registered cells and map them onto base image cells

figure(3)

reg_GoodICf = cellfun(@(a) imwarp(a,tform,'OutputView',imref2d(size(base_image))), ...
    reg_data.GoodICf,'UniformOutput',0); % Register each IC to the base image

% Create cell map cell variable if one doesn't already exist
if ~exist('cell_map')
    cell_map = cell(size(base_data.GoodICf,2),2);
    for j = 1:size(cell_map,1)
        cell_map{j,1} = j;
    end
    reg_col = 2;
    new_map = 1;
elseif ~exist('cell_map')
    reg_col = size(cell_map,2) + 1;
    new_map = 0;
end

% Step through each cell in registered image and match to base image cells
for j = 1:size(reg_data.GoodICf,2)
    num_cells_total = size(cell_map,1); % Get total number of cells
    
    % Get union of each IC from the base image with the given registered IC
    temp = cellfun(@(a) a & reg_GoodICf{j},base_data.GoodICf, ...
         'UniformOutput',0); 
    overlap{j} = find(cellfun(@(a) sum(sum(a)) > 0,temp));
    
    figure(3)
    imagesc(base_data.AllIC + 2*reg_GoodICf{j})
    
    if ~isempty(overlap{j})
        for k = 1:size(overlap{j},2)
            overlap_ratio{j}(k) = sum(sum(temp{overlap{j}(k)}))/...
                sum(sum(base_data.GoodICf{overlap{j}(k)})); % Get ratio of mask that overlaps with each cell in base image
            disp(['This cell overlaps with base image cell #' ...
                num2str(overlap{j}(k)) ' by ' num2str(100*overlap_ratio{j}(k),'%10.f') '%.'])
        end
        figure(3) % For some reason figure 3 gets hidden occassionally when I get to this point, manually overriding. Doesn't work!
        temp2 = input('Enter base image cell number to register with this neuron (enter nothing for new neuron):');
        % Check to make sure you didn't make an obvious error
        if sum(overlap{j} == temp2) == 0 && sum(overlap_ratio{j} >= 0.5) == 1
            % Check if you entered a cell number that doesn't overlap, or
            % new neuron was entered even though there is more than 50%
            % overlap with a cell
            temp2 = input('Possible error detected.  Confirm previous cell number entry: '); 
        elseif sum(overlap{j} == temp2) == 1 && overlap_ratio{j}(overlap{j} == temp2) < 0.5
            % Check if you entered the neuron with lesser overlap by
            % accident
            temp2 = input('Possible error detected.  Confirm previous cell number entry: ');
        end
        if ~isempty(temp2)
            cell_map{temp2,reg_col} = j; % Assign registered image good IC number to appropriate base image IC
        elseif isempty(temp2)
            cell_map{num_cells_total+1,reg_col} = j;
        end

    elseif isempty(overlap{j})
        disp(['Registered image cell # ' num2str(j) ' does not overlap with any cells from base image. Hit enter to proceed.'])
        cell_map{num_cells_total+1,reg_col} = j;
        pause
    end
     
    
end

%% Step 5: Plot out updated masks that combines all the ICs from the two sessions and plot out which
% cells overlap, which cells are new, and which are active only in the base
% session
% Right now I will assume that we always want to reference back to the very
% first session for our reference picture...

% Start for just comparing base session to registered session, then make it
% functional where the "base session" is actually all the previous
% recording sessions combined...

GoodICf_comb = cell(1,size(cell_map,1));
for j = 1:size(GoodICf_comb,2)
    
   if ~isempty(cell_map{j,reg_col}) && isempty(cell_map{j,reg_col-1}) % New neuron (neuron only active in registered session)
       GoodICf_comb{j} = reg_GoodICf{cell_map{j,reg_col}};
   elseif ~isempty(cell_map{j,reg_col}) && ~isempty(cell_map{j,reg_col-1}) % Neuron active in both sessions
       GoodICf_comb{j} = reg_GoodICf{cell_map{j,reg_col}};
   elseif isempty(cell_map{j,reg_col}) && ~isempty(cell_map{j,reg_col-1}) % Base image neuron becomes silent in registered session (or noisy??)
       GoodICf_comb{j} = base_data.GoodICf{cell_map{j,reg_col-1}};
   end
end

% Combine all the ICs together and plot versus individual masks to check
AllIC_comb = zeros(size(GoodICf_comb{1}));
for j = 1:size(GoodICf_comb,2)
   AllIC_comb = AllIC_comb + GoodICf_comb{j};
end

figure(4)
subplot(2,1,1)
imagesc(base_data.AllIC+ AllIC_reg*2); title('Combined Image Cells'); colormap(jet)
h = colorbar('YTick',[0 1 2 3],'YTickLabel', {'','Base Image Cells','Reg Image Cells','Overlapping Cells'});
subplot(2,1,2)
imagesc(AllIC_comb); title('Combined Session Cells after registration'); colormap(jet)
colorbar



%% Step 6: Save the cell map and header for reference

% Prompt to save session info for header file
%%% Dave question: should we just re-work directory structure to automate
%%% this?

if new_map == 1
    base_session = input('Enter base session name (arena_location): ','s');
    base_date = input('Enter base session date (mm_dd_yyyy): ','s');
else
end
reg_session = input('Enter registered session name (arena_location): ','s');
reg_date = input('Enter registered session date (mm_dd_yyyy): ','s');

if new_map == 1
    cell_map_header{1,1} = base_date;
    cell_map_header{2,1} = base_session;
    cell_map_header{1,2} = reg_date;
    cell_map_header{2,2} = reg_session;
elseif new_map == 0
    cell_map_header{1,reg_col} = reg_date;
    cell_map_header{2,reg_col} = reg_session;
end


csave([reg_path 'cell_registration.mat'], 'cell_map_header', 'cell_map')

%%% Questions for Dave
% 1) Directory Structure question above
% 2) What do we do with partially overlapping cells (i.e. red parts of
% cells in figure 4)?
% 3) How should we update masks - keep one or the other, combine the two (
% base union with registered) or only use the overlapping portions (base
% intersection with registered)?
% 4) What variables should we save and how?  Want to keep as clean and
% simple as possible.  Should we combine the header with the cell_map?
% 5) Should I do anything with the COMs?
% 6) For future registrations, where we put all the previous sessions
% together, how should we input the relevant data? Just have GoodICf_comb
% and the base image file and the cell_map?


keyboard;
