function [cell_map_reg cell_map_header_reg ] = image_register5(base_file, register_file, cell_merge) % , cell_map, cell_map_header)
% Image Registration Function - this fuction allows you to register a given
% recording session (the registered session) to a previous sesison ( the
% base session) to track neuronal activity from session to session.  It
% also outputs a combined set of ICs so that you can register a given
% session to multiple previous sessions.  Note that you must enter an
% approximate rotation if you used a different focuse for the registered
% file, or else the in-house MATLAB image registration funcRtions won't
% work...
%
% INPUT VARIABLES
% base_file:    .tif file for the minimimum projection of the motion
%               corrected ICmovie for the base image.  Needs to be in the
%               same directory as SignalTrace.mat (or CellRegisterBase.mat
%               for multiple sessions) to work
% register_file:.tif file (min projection of the motion corrected ICmovie)
%               for the image/recording you wish to register to the base
%               image. Needs to be in the same directory as SignalTrace.mat
%               to work.  Enter the same file as the base_file if you want
%               to do a base mapping.
% cell_merge:   How you deal with cell overlap for future registrations:
%               'base' = keep the base IC (recommended)
%               'merge' = merge the base and registered file ICs (not
%               recommended - cell will eventually grow into monster cell!)
%               'reg' = overwrite base IC with registered file IC (ok, but
%               you need to manually verify that cell IC doesn't drift over
%               time!)
%
% OUTPUTS
% cell_map:     cell array with each row corresponding to a given neuron,
%               and each column corresponding to a recording session.  The value
%               corresponds to the GoodICf number from that session for that neuron.
% cell_map_header: contains info for each column in cell_map
% GoocICf_comb: combines ICs from the base file and the registered file.
%               Use this file as the base file for future registrations of
%               a file to multiple previous sessions.
% RegistrationInfo : saves the location of the base file, the registered
%                file, the transform applied, and the Base and registered 
%                AllIC masks

% To do:

% - Try this out for images that are significantly different, e.g. rotated
% 180 degrees...
% - Automatically fill in expected neuron for base mapping

% - Need way to cycle through different cells (only one at a time) where
% there is multiple overlap (e.g. 57% with one cell and 63% with another
% cell) - e.g. for the cell immediately after that which gets mapped to
% cell 88 (G30, base session 9/23 1st session, registered session 9/24 1st
% session)
% - Need to number cells in reg image in case you need to make
% corrections later on 
% - Automatically plot blow up of area?
% - Error checking - Need check to make sure that, in cases where there are lots of cells that
% I don't accidentally assign two different cells to the same cell and thus
% overwrite a previous mapping.
% - Error checking - don't let person advance if they don't hit one of the
% possible IC numbers or enter! Also, make them hit the same thing twice in
% a row to advance...
% - Error checking - check if largest percentage is not selected
% - **** Add try-catch statement to prevent running all the time-intensive imreg
% functions if we already have a good image reg and just want to run
% through the mapping portion - maybe search for 'register_file' in RegInfo
% and if it is already there, skip all the registration stuff? (DONE)
% - Make imagesc ALWAYS use the same scale when stepping through... (DONE)
% - Need to think through how to re-do a session more carefully.  It only
% really works if it is the last session run, otherwise previously mapped
% cells will get lost or indexed in the wrong place in the cell_map
% variable...(DONE)
% - **** Need section to check for double counted cell mappings, and then
% resolve them.  This will be complicated but necessary.  If this happens,
% we should either a)only keep the chosen cell mapping, and toss the other
% cell, or b) toss all of them because they are a cluster we can't resolve.
% (DONE kind of)
% *** - No error checking for cells with <50% overlap - only need to hit
% enter once!!!

close all;
 
%% MAGIC VARIABLES
configname = 'multimodal'; % For images taken with similar contrasts, e.g. from the same device, same gain, etc.
regtype = 'similarity'; % Similarity = Translation, Rotation, Scale

% Adjust registration algorithm values:
% MONOMODAL
mono_max_iterations = 1000; % optimizer.MaximumIterations = 100 default
mono_max_step = 1e-3;% optimizer.MaximumStepLength = 0.0625 default
mono_min_step = 1e-5; % optimizer.MinimumStepLength = 1e-5 default
mono_relax = 0.5; %optimizer.RelaxationFactor = 0.5 default
mono_gradient_tol = 1e-6; % optimizer.GradientMagnitudeTolerance = 1e-4 default
% MULTIMODAL
multi_max_iterations = 10000; % optimizer.MaximumIterations = 100 default
multi_growth = 1.05; % optimizer.GrowthFactor = 1.05 default
multi_epsilon = 1.05e-6; % optimizer.Epsilon = 1.05e-6 default
multi_init_rad = 6.25e-4; % optimizer.InitialRadius = 6.25e-3 default

FigNum = 1; % Start off figures at this number

%% Step 1: Select images to compare and import the images

if nargin == 0
[base_filename, base_path, filterindexbase] = uigetfile('*.tif',...
    'Pick the base image file: ');
base_file = [base_path base_filename];

[reg_filename, reg_path, filterindexbase] = uigetfile('*.tif',...
    'Pick the image file to register with the base file: ',[base_path base_filename]);
register_file = [reg_path reg_filename];
cell_merge = 'base';
elseif nargin == 1
    error('Please input both a base image and image to register to base file')
elseif nargin == 2
   
    base_filename = base_file(max(regexp(base_file,'\','end'))+1:end);
    base_path = base_file(1:max(regexp(base_file,'\','end')));
    reg_filename = register_file(max(regexp(register_file,'\','end'))+1:end);
    reg_path = register_file(1:max(regexp(register_file,'\','end')));

    if isempty(merge_check)
        cell_merge = 'base';
    elseif strcmpi(merge_check,'reg') || strcmpi(merge_check,'merge')
        cell_merge = merge_check;
    else
        error('cell_merge value invalid')
    end
        
    
end

% Ask for input on how to deal with overlapping ICs for future sessions.
if nargin < 3
    disp('Overlapping cells will use the base image IC for future sessions')
    merge_check = input('Hit enter to confirm. Enter ''reg'' or ''merge'' to change: ','s');
end

% Check if this is a base cell mapping or not
base_check = [base_path 'CellRegisterInfo.mat'];

% Set flag if this is the base cell registration
if exist(base_check,'file') == 0
    base_map = 1;
elseif exist(base_check,'file') == 2
    base_map = 0;
end

% Check if this is the base mapping run in case no registered file was
% entered.
if reg_filename == 0
   temp1 = input('You have not entered a file to register.  Is this the base mapping run? (y/n):' ,'s');
   if strcmp(temp1,'n')
       disp('Please re-run register function and enter file to register');
       return
   elseif strcmp(temp1,'y') %  Set up base mapping!
      reg_filename = base_filename;
      reg_path = base_path;
      register_file = base_file;
   end
end

%% Step 2a: Get Images and pre-process - Note that this step is vital as it helps
% correct for differences in overall illumination or contrast between
% sessions.

% Magic numbers
disk_size = 15;
pixel_thresh = 100;

base_image_gray = uint16(imread(base_file));
reg_image_gray = uint16(imread(register_file));

bg_base = imopen(base_image_gray,strel('disk',disk_size));
base_image_gray = base_image_gray - bg_base;
base_image_gray = imadjust(base_image_gray);
level = graythresh(base_image_gray);
base_image_bw = im2bw(base_image_gray,level);
base_image_bw = bwareaopen(base_image_bw,pixel_thresh,8);
base_image = double(base_image_bw);

bg_reg = imopen(reg_image_gray,strel('disk',disk_size));
reg_image_gray = reg_image_gray - bg_reg;
reg_image_gray = imadjust(reg_image_gray);
level = graythresh(reg_image_gray);
reg_image_bw = im2bw(reg_image_gray,level);
reg_image_bw = bwareaopen(reg_image_bw,pixel_thresh,8);
reg_image = double(reg_image_bw);


%% Step 2b: Run Registration Functions, get transform

[optimizer, metric] = imregconfig(configname);
if strcmp(configname,'monomodal') % Adjust defaults if desired.
    optimizer.MaximumIterations = mono_max_iterations;
    optimizer.MaximumStepLength = mono_max_step;
    optimizer.MinimumStepLength = mono_min_step;
    optimizer.RelaxationFactor = mono_relax;
    optimizer.GradientMagnitudeTolerance = mono_gradient_tol;
    
elseif strcmp(configname,'multimodal')
    optimizer.MaximumIterations = multi_max_iterations;
    optimizer.GrowthFactor = multi_growth;
    optimizer.Epsilon = multi_epsilon;
    optimizer.InitialRadius = multi_init_rad;
    
end
% [moving_reg r_reg] = imregister(reg_image, base_image, regtype, optimizer, metric


% CATCH PREVIOUSLY RAN REGISTRATION
try
    load([base_path 'RegistrationInfo.mat']);
    
    already_run = find(arrayfun(@(a) strcmpi([reg_path reg_filename],a.register_file),RegistrationInfo),1,'first');
    % if isempty(already_run)
    %     tform = imregtform(reg_image, base_image, regtype, optimizer, metric);
    if already_run == size(RegistrationInfo,2)
        tform = RegistrationInfo(already_run).tform;
        
        % Double check
        proceed = input('There is a previously run registration - do you wish to overwrite it? (y/n): ','s');
        if strcmpi(proceed,'n')
            return
        elseif strcmpi(proceed,'y')
            disp('Proceeding.')
        end
    else % Too complicated to re-register a session in the middle
        error('The session you wish to overwrite is not the last session run.  Can''t do it.')
        return
    end
catch
    if base_map == 1
        tform = affine2d([1 0 0 ; 0 1 0 ; 0 0 1]); 
    elseif base_map == 0
        tform = imregtform(reg_image, base_image, regtype, optimizer, metric);
    end
end
    
moving_reg = imwarp(reg_image,tform,'OutputView',imref2d(size(base_image)),'InterpolationMethod','nearest');

% This makes sure that no transform is applied to the base image, just in
% case. MOVE THIS UP!!!
% if base_map == 1
%    tform.T = [1 0 0 ; 0 1 0 ; 0 0 1]; 
% else
% end


% Quality Control Plot: Plot original images, registered image, and 
% base-registered image

figure(1)
h_base_landmark = subplot(2,2,1);
imagesc(base_image); colormap(gray); colorbar
title('Base Image');
h_reg_landmark = subplot(2,2,2);
imagesc(reg_image); colormap(gray); colorbar
title('Image to Register');
subplot(2,2,3)
imagesc(moving_reg); colormap(gray); colorbar
title('Registered Image')
subplot(2,2,4)
imagesc(abs(moving_reg - base_image)); colormap(gray); colorbar
title('Registered Image - Base Image')

% FigNum = FigNum + 1;

%% Step 3: Take Good ICs from registered image and overlay them onto base image

% Load data for ICs: Here I assume that the data files lie in the same directories as the
% reference images

if exist([base_path 'RegistrationInfo.mat'],'file') == 2
    load([base_path 'RegistrationInfo.mat']);
    if ~isempty(already_run)
        size_info = already_run;
    elseif isempty(already_run)
        size_info = size(RegistrationInfo,2)+1;
    end
else
    size_info = 1;
end

if base_map == 1
    base_data = importdata([base_path 'FinalTraces.mat']);
    reg_data = importdata([base_path 'FinalTraces.mat']);
    
%     base_data = importdata([base_path 'SignalTrace.mat']); % Old Version
%     reg_data = importdata([reg_path 'SignalTrace.mat']); % Old Version
    
    % Get IC masks and create All_IC mask.
    [base_data.AllIC, base_IC] = create_AllICmask2(base_data.IC,base_data.ICnz); 
   
elseif base_map == 0
   
%     disp('already_run debugging')
%     keyboard
    
    temp1 = importdata([base_path 'CellRegisterInfo.mat']);
    if isempty(already_run)
        base_data = temp1(size_info-1);
    elseif already_run == size(RegistrationInfo,2)
        base_data = temp1(already_run-1);
    end
    reg_data = importdata([reg_path 'FinalTraces.mat']);
    
%     base_data = importdata([base_path 'CellRegisterInfo.mat']);
%     reg_data = importdata([reg_path 'SignalTrace.mat']);
    
    base_IC = base_data.GoodICf_comb; % Set GoodICf to be combined otherwise
    base_data.AllIC = create_AllICmask(base_IC);
    % GoodICf from all previous sessions
    
    % Archive CellRegisterInfo, since it will get overwritten later
%     save([base_path 'CellRegisterBase' num2str(size(base_data.cell_map,2)-1) '.mat'],...
%         '-struct','base_data');
end

[ reg_data.ICMask_weighted, reg_data.COM_weighted, reg_data.COM_unweighted ] = ...
    get_weightedCOM( reg_data.IC,reg_data.ICnz); % Get COMs (weighted and unweighted)

% Create a map of All ICs for both the base file and the registered file.
AllIC_base = base_data.AllIC;
[reg_data.AllIC, reg_data.GoodICf] = create_AllICmask2(reg_data.IC,reg_data.ICnz);

% Register AllIC_reg to AllIC_base
AllIC_reg = imwarp(reg_data.AllIC,tform,'OutputView',imref2d(size(base_image)),'InterpolationMethod','nearest');

% Plot out both...
figure(2)
h_base_mask = subplot(1,2,1);
imagesc(base_data.AllIC); title('Base Image Cells')
h_reg_mask = subplot(1,2,2);
imagesc(AllIC_reg*2); title('Registered Image Cells')
figure(3)
imagesc(base_data.AllIC+ AllIC_reg*2); title('Combined Image Cells'); colormap(jet)
h = colorbar('YTick',[0 1 2 3],'YTickLabel', {'','Base Image Cells','Reg Image Cells','Overlapping Cells'});

% FigNum = FigNum + 1;  

%% Step 3A: Give option to adjust manually if this doesn't work...

disp('Here is your opportunity to compare to previous cell registrations');
keyboard; % Can compare to previous cell registrations if you want to here


FigNum = 5;

% Spit out registration stats
disp('Registration Stats:')
disp(['X translation = ' num2str(tform.T(3,1)) ' pixels.'])
disp(['Y translation = ' num2str(tform.T(3,2)) ' pixels.'])
disp(['Rotation = ' num2str(mean([asind(tform.T(1,2)) acosd(tform.T(1,1))])) ' degrees.'])

manual_flag = input('Do you wish to manually adjust this registration? (y/n): ','s');
if strcmpi(manual_flag,'n')
    use_manual_adjust = 0;
end
while strcmpi(manual_flag,'y')
    manual_type = input('Do you wish to adjust by landmarks or my cell masks or none? (l/m/n): ','s');
    while ~(strcmpi(manual_type,'l') || strcmpi(manual_type,'m') || strcmpi(manual_type,'n'))
        manual_type = input('Do you wish to adjust by landmarks or my cell masks or none? (l/m/n): ','s');
    end
    T_manual = [];
    while isempty(T_manual)
        if strcmpi(manual_type,'l')
            reg_type = 'landmark';
            figure(1)
            T_manual = manual_reg(h_base_landmark, h_reg_landmark, reg_type);
            
        elseif strcmpi(manual_type,'m')
            reg_type = 'mask';
            figure(4)
            h_base_mask = subplot(1,2,1);
            imagesc(base_data.AllIC); title('Base Image Cells')
            h_reg_mask = subplot(1,2,2);
            imagesc(reg_data.AllIC); title('Registered Image Cells')
            T_manual = manual_reg( h_base_mask, h_reg_mask, reg_type, base_data, reg_data);
        elseif strcmpi(manual_type,'n')
            T_manual = eye(3);
        end
    end
    
    tform_manual = tform;
    tform_manual.T = T_manual;
    AllIC_reg_manual = imwarp(reg_data.AllIC,tform_manual,'OutputView',imref2d(size(base_image)),'InterpolationMethod','nearest');
    moving_reg_manual = imwarp(reg_image,tform_manual,'OutputView',imref2d(size(base_image)),'InterpolationMethod','nearest');
    
    figure(FigNum)
    imagesc(base_data.AllIC+ AllIC_reg_manual*2);  colormap(jet)
    title(['Combined Image Cells - Manual Adjust, rot = ' num2str( asind(tform_manual.T(1,2)),'%1.2f') ' degrees']);
    h = colorbar('YTick',[0 1 2 3],'YTickLabel', {'','Base Image Cells','Reg Image Cells','Overlapping Cells'});
    xlabel(['X shifted by ' num2str(tform_manual.T(3,1),'%1.1f') ' pixels']);
    ylabel(['Y shifted by ' num2str(tform_manual.T(3,2),'%1.1f') ' pixels']);
    
    FigNum = FigNum + 1;
    
    figure(FigNum)
    imagesc(abs(moving_reg_manual - base_image)); colormap(gray); colorbar
    title('Registered Image - Base Image')
    
    
    manual_flag = input('Do you wish to manually adjust again? (y/n)', 's');
    use_manual_adjust = 1;

    
end
FigNum = FigNum + 1;

% Save info into RegistrationInfo data structure.
RegistrationInfo(size_info).base_file = base_file;
RegistrationInfo(size_info).register_file = register_file;
RegistrationInfo(size_info).tform = tform;
RegistrationInfo(size_info).AllIC_base = AllIC_base;
RegistrationInfo(size_info).AllIC_reg = AllIC_reg;

if exist('T_manual','var')
    RegistrationInfo(size_info).tform_manual = tform_manual;
    RegistrationInfo(size_info).AllIC_reg_manual = AllIC_reg_manual;
end

save ([ base_path 'RegistrationInfo.mat'],'RegistrationInfo');


%% Step 4: Visually scroll through registered cells and map them onto base image cells

new_cell_add = 3;
num_reg_ICs = size(reg_data.GoodICf,2);

figure(FigNum)

if use_manual_adjust == 1
    tform = tform_manual;
end

reg_GoodICf = cellfun(@(a) imwarp(a,tform,'OutputView',imref2d(size(base_image)),'InterpolationMethod','nearest'), ...
    reg_data.GoodICf,'UniformOutput',0); % Register each IC to the base image

% Create cell map cell variable if one doesn't already exist
if base_map == 1
    cell_map = cell(size(base_IC,2),2);
    cell_overlap = cell(size(base_IC,2),2);
    COM_weighted = cell(size(base_IC,2),2);
    for j = 1:size(cell_map,1)
        cell_map{j,1} = j;
        cell_overlap{j,1} = 1;
    end
    reg_col = 2;
elseif base_map == 0
    cell_map = base_data.cell_map;
    cell_overlap = base_data.cell_overlap;
    COM_weighted = base_data.COM_weighted;
    cell_map_header = base_data.cell_map_header;
    reg_col = size(cell_map,2) + 1;
end


% Step through each cell in registered image and match to base image cells.
% Note that if this is the base mapping, you are registering the GoodICfs
% to all the ICs from the base session.
overlap = cell(1,size(reg_data.GoodICf,2));
overlap_ratio = cell(1,size(reg_data.GoodICf,2));

 % Get registered COMs
        
 for j = 1:num_reg_ICs
     [reg_COM_weighted{j}(2) reg_COM_weighted{j}(1)] = transformPointsForward(tform,...
         reg_data.COM_weighted{j}(2),reg_data.COM_weighted{j}(1));
 end

% NK Note - need to automate this for base mapping now? All ICs are good,
% apparently...
base_map_error_cells = [];
if base_map == 1
    runthrough = input('Do you want to step through and check each cell for the base mapping (y/n)?','s');
else
    runthrough = 'y';
end


CLIM_upper = max(max(base_data.AllIC,[],1),[],2) + new_cell_add;
h1 = figure(FigNum);
if strcmpi(runthrough,'y')
    for j = 1:num_reg_ICs
        num_cells_total = size(cell_map,1); % Get total number of cells
        
        % Get union of each IC from the base image with the given registered IC
        temp = cellfun(@(a) a & reg_GoodICf{j},base_IC, ...
            'UniformOutput',0);
        overlap{j} = find(cellfun(@(a) sum(sum(a)) > 0,temp));
        
       
        
        % Calculate limits for plotting
        zoom_pix = 25; % +/- pixels to zoom in
        comb_level = max(max(base_data.AllIC + (base_data.AllIC + new_cell_add*reg_GoodICf{j}),[],1),[],2);
        xlim_zoom = [reg_COM_weighted{j}(2) - zoom_pix reg_COM_weighted{j}(2) + zoom_pix];
        ylim_zoom = [reg_COM_weighted{j}(1) - zoom_pix reg_COM_weighted{j}(1) + zoom_pix];
        
        figure(FigNum)
        subplot(3,3,[1 2 4 5]) % Overall View
        imagesc(base_data.AllIC + new_cell_add*reg_GoodICf{j},[0 CLIM_upper]); 
        colorbar('YTick',[0 1 new_cell_add comb_level],'YTickLabel',...
            {'','Base Image Cells','Reg Image Cells','Overlapping Cells'});
        subplot(3,3,9) % Zoom-in View
        imagesc(base_data.AllIC + new_cell_add*reg_GoodICf{j},[0 CLIM_upper]);
        xlim(xlim_zoom); ylim(ylim_zoom);
        
        
        if ~isempty(overlap{j})
%             keyboard
            for k = 1:size(overlap{j},2)
                overlap_ratio{j}(k) = sum(sum(temp{overlap{j}(k)}))/...
                    sum(sum(base_IC{overlap{j}(k)})); % Get ratio of mask that overlaps with each cell in base image
                if overlap_ratio{j}(k) == 1 % Make overlap ratio > 100% if base IC is completely enveloped by reg IC
                   overlap_ratio{j}(k) = sum(sum(reg_GoodICf{j}))...
                       /sum(sum(base_IC{overlap{j}(k)}));
                end
               
            end
            
            % Sort from most to least overlap
            if size(overlap{j},2) > 1
                ii = [];
                [overlap_ratio{j} ii] = sort(overlap_ratio{j},'descend');
                overlap{j} = overlap{j}(ii);
            end
            
            % Display overlap ratios on the screen
            for k = 1:size(overlap{j},2)
                disp([num2str(j) '/' num2str(num_reg_ICs) ') This cell overlaps with base image cell #' ...
                    num2str(overlap{j}(k)) ' by ' num2str(100*overlap_ratio{j}(k),'%10.f') '%.'])
            end
            
            figure(FigNum); % For some reason figure 3 gets hidden occassionally when I get to this point, manually overriding. Doesn't work!
            
            % For cells with multiple overlap, plot out one cell at a time
            % only!
            if size(overlap{j},2) >= 1
                
                
                subplot(3,3,3)
                imagesc(base_data.GoodICf_comb{overlap{j}(1)} + new_cell_add*reg_GoodICf{j},[0 CLIM_upper]);
                xlim(xlim_zoom); ylim(ylim_zoom); title(['Overlap with cell ' num2str(overlap{j}(1)) ' only']);
                
                if size(overlap{j},2) > 1
                    subplot(3,3,6)
                    imagesc(base_data.GoodICf_comb{overlap{j}(2)} + new_cell_add*reg_GoodICf{j},[0 CLIM_upper]);
                    xlim(xlim_zoom); ylim(ylim_zoom); title(['Overlap with cell ' num2str(overlap{j}(2)) ' only']);
                else
                    subplot(3,3,6)
                    imagesc(zeros(size(base_data.GoodICf_comb{1})),[0 CLIM_upper]);
                end
            else
                subplot(3,3,3)
                imagesc(zeros(size(base_data.GoodICf_comb{1})),[0 CLIM_upper]);
                subplot(3,3,6)
                imagesc(zeros(size(base_data.GoodICf_comb{1})),[0 CLIM_upper]);
            end
            
            if base_map == 1
                temp2 = overlap{j}(k); % THIS ISN'T IN A FOR LOOP, NEEDS TO BE CORRECTED/CHECKED
                temp3 = input('Hit enter to confirm.  Enter cell number to log error in mapping this cell: ');
                base_map_error_cells = [base_map_error_cells temp3];
            elseif base_map ~= 1 % NRK - make this simpler.  Automatically fill in cell with most overlap, and have user overwrite if not ok...?
                temp2 = input('Enter base image cell number to register with this neuron (enter nothing for new neuron):');
                % Check to make sure you didn't make an obvious error
                if isempty(temp2) || sum(overlap{j} == temp2) == 0 && sum(overlap_ratio{j} >= 0.5) == 1
                    % Check if you entered a cell number that doesn't overlap, or
                    % new neuron was entered even though there is more than 80%
                    % overlap with a cell
                    temp2 = input('Possible error detected.  Confirm previous cell number entry: ');
                elseif sum(overlap{j} == temp2) == 1 && overlap_ratio{j}(overlap{j} == temp2) < 0.5
                    % Check if you entered the neuron with lesser overlap by
                    % accident
                    temp2 = input('Possible error detected.  Confirm previous cell number entry: ');
                end
                
            end
            
            if ~isempty(temp2)
                cell_map{temp2,reg_col} = j; % Assign registered image good IC number to appropriate base image IC
                cell_overlap{temp2,reg_col} = overlap_ratio{j}(overlap{j} == temp2); % Track overlap percentage
                COM_weighted{temp2,reg_col} = reg_COM_weighted{j};
            elseif isempty(temp2)
                cell_map{num_cells_total+1,reg_col} = j;
                cell_overlap{num_cells_total+1,reg_col} = 1;
                COM_weighted{num_cells_total+1,reg_col} = reg_COM_weighted{j}; 
            end
            
            
        elseif isempty(overlap{j})
            
            % clear out the zoomed in single cell overlap subplots
            subplot(3,3,3)
            imagesc(zeros(size(base_data.GoodICf_comb{1})),[0 CLIM_upper]);
            subplot(3,3,6)
            imagesc(zeros(size(base_data.GoodICf_comb{1})),[0 CLIM_upper]);
            
            
            temp4 = input([num2str(j) '/' num2str(num_reg_ICs) ...
                ')This cell does not overlap with any cells from base image. Hit any key to proceed.']);
            cell_map{num_cells_total+1,reg_col} = j;
            cell_overlap{num_cells_total+1,reg_col} = 1;
            COM_weighted{num_cells_total+1,reg_col} = reg_COM_weighted{j}; 
        end
        
        
    end
elseif strcmpi(runthrough,'n')
    cell_map(:,2) = cell_map(:,1);
    [cell_overlap{:,2}] = deal(1);
    COM_weighted(:,2) = reg_COM_weighted;
end

FigNum = FigNum + 1;

figure(FigNum) % Plot out combined cells after registration
subplot(2,1,1)
imagesc(base_data.AllIC+ AllIC_reg*new_cell_add,[0 CLIM_upper]); title('Combined Image Cells'); colormap(jet)
h = colorbar('YTick',[0 1 new_cell_add new_cell_add+1],'YTickLabel', {'','Base Image Cells','Reg Image Cells','Overlapping Cells'});


%% Step 5: Plot out updated masks that combines all the ICs from the two sessions and plot out which
% cells overlap, which cells are new, and which are active only in the base
% session
% Right now I will assume that we always want to reference back to the very
% first session for our reference picture...

GoodICf_comb = cell(1,size(cell_map,1)); % Overwrite previous GoodICf_comb
for j = 1:size(GoodICf_comb,2)
    
   if ~isempty(cell_map{j,reg_col}) && isempty(cell_map{j,reg_col-1}) 
       % New neuron (neuron only active in registered session, not any previous sessions)
       GoodICf_comb{j} = double(reg_GoodICf{cell_map{j,reg_col}});
   elseif ~isempty(cell_map{j,reg_col}) && ~isempty(cell_map{j,reg_col-1}) % Create combined session IC masks!
       % Neuron active in both sessions
       if strcmpi(cell_merge,'merge')
           GoodICf_comb{j} = reg_GoodICf{cell_map{j,reg_col}} | base_IC{j} ;
       elseif strcmpi(cell_merge,'base')
           GoodICf_comb{j} = base_IC{j} ;
       elseif strcmpi(cell_merge,'reg')
           GoodICf_comb{j} = reg_GoodICf{cell_map{j,reg_col}} | base_IC{j} ;
       end
   elseif isempty(cell_map{j,reg_col}) 
       % Previously active neuron becomes silent in registered session (or noisy??)
       GoodICf_comb{j} = base_IC{j};
   end
   
end



% Combine all the ICs together and plot versus individual masks to check
AllIC_comb = zeros(size(GoodICf_comb{1}));
for j = 1:size(GoodICf_comb,2)
   AllIC_comb = AllIC_comb + GoodICf_comb{j}; % NRK start here - matrix dimensions don't agree
end

figure(FigNum)
subplot(2,1,2)
imagesc(AllIC_comb); title('Combined Session Cells after registration'); colormap(jet)
h = colorbar('YTick',[0 1 2],'YTickLabel', {'','Individual Cells','Overlapping Portions'});

colorbar

FigNum = FigNum + 1;

%% Step 6: Save the cell map and header for reference

% Prompt to save session info for header file

if base_map == 1
    disp(['Base session path: ' base_path])
    base_session = input('Enter base session name (arena_location): ','s');
    base_date = input('Enter base session date (mm_dd_yyyy): ','s');
else
%     base_session = input('Enter base session name (arena_location): ','s');
%     base_date = input('Enter base session date (mm_dd_yyyy): ','s');
    disp(['Reg session path: ' reg_path])
    reg_session = input('Enter registered session name (arena_location): ','s');
    reg_date = input('Enter registered session date (mm_dd_yyyy): ','s');
end

if base_map == 1
    
    cell_map_header{1,1} = base_date;
    cell_map_header{2,1} = base_session;
    cell_map_header{3,1} = 'All ICs';
    
    cell_map_header{1,2} = base_date;
    cell_map_header{2,2} = base_session;
    cell_map_header{3,2} = 'Good ICs';

elseif base_map == 0
    
    cell_map_header{1,reg_col} = reg_date;
    cell_map_header{2,reg_col} = reg_session;
    cell_map_header{3,reg_col} = 'Good ICs';
    
end

%%% Consolidate everything into CellRegisterBase

% Save old registrations just in case
if size_info ~= 1 
    CellRegisterInfo(size_info-1).cell_map_header = base_data.cell_map_header;
    CellRegisterInfo(size_info-1).cell_map = base_data.cell_map;
    CellRegisterInfo(size_info-1).GoodICf_comb = base_data.GoodICf_comb;
    CellRegisterInfo(size_info-1).cell_overlap = base_data.cell_overlap;
    CellRegisterInfo(size_info-1).COM_weighted = base_data.COM_weighted;
end

% New registration info
CellRegisterInfo(size_info).cell_map_header = cell_map_header;
CellRegisterInfo(size_info).cell_map = cell_map;
CellRegisterInfo(size_info).GoodICf_comb = GoodICf_comb;
CellRegisterInfo(size_info).cell_overlap = cell_overlap;
CellRegisterInfo(size_info).COM_weighted = COM_weighted;

save([base_path 'CellRegisterInfo.mat'], 'CellRegisterInfo')

keyboard;
