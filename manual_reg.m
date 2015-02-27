function [T_manual] = manual_reg(base_image_axes,reg_image_axes, reg_type, SigTrace_base,SigTrace_reg)

% file2 = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangular plastic tub\ICmovie_min_proj.tif';
% file1 = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangle\ICmovie_min_proj.tif';
% file_combined = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\combined\IC300-Objects\Obj_1\ICmovie_min_proj.tif';

% Save figures in case you need to re-write them...
hgsave(base_image_axes,'base_mask_temp');
hgsave(reg_image_axes,'reg_mask_temp');

% figure(1); 
% base_image_axes = subplot(2,2,1);
% reg_image_axes = subplot(2,2,2);

if strcmpi(reg_type,'mask') && nargin ~= 5
   error('You did not enter enought input arguments.  Please enter a SignalTrace.mat file for both the base and registered files')
else
end

% Create COM variable
for j = 1:size(SigTrace_base.GoodICf_comb,2)
    base_GoodCom{j} = centerOfMass(SigTrace_base.GoodICf_comb{j}*1);
end
SigTrace_base.GoodCom = base_GoodCom;
for j = 1:size(SigTrace_reg.GoodICf,2)
    reg_GoodCom{j} = centerOfMass(SigTrace_reg.GoodICf{j}*1);
end
SigTrace_reg.GoodCom = reg_GoodCom;

xbase = []; ybase = [];
disp('Select Center of Base Image Cells to use as reference')
[xbase, ybase] = getpts(base_image_axes);
base_vec = [xbase ybase];
axes(base_image_axes); hold on;
npoints_base = length(xbase);
for j = 1:npoints_base
    %     plot(xbase(j),ybase(j),'*')
    src_base = text(xbase(j)+10,ybase(j)-15,num2str(j));
    set(src_base,'Color',[0 1 0]);
    
end
if strcmpi(reg_type,'mask')
    base_refpoints = get_closestCOM(base_vec,SigTrace_base.GoodCom);
    plot(base_refpoints(:,1), base_refpoints(:,2),'g*')
else
    plot(xbase,ybase,'g*')
end
hold off

xreg = []; yreg = [];
disp('Select Center of Registered Image Cells to use as a reference')
[xreg, yreg] = getpts(reg_image_axes);
axes(reg_image_axes); hold on;
reg_vec = [xreg yreg];
npoints_reg = length(xreg);
for j = 1:npoints_reg
    %     plot(xreg(j),yreg(j),'*')
    src_reg = text(xreg(j)+10,yreg(j)-15,num2str(j));
    set(src_reg,'Color',[0 1 0]);
    
end
if strcmpi(reg_type,'mask')
    reg_refpoints = get_closestCOM(reg_vec, SigTrace_reg.GoodCom);
    plot(reg_refpoints(:,1), reg_refpoints(:,2),'g*')
else
    plot(xreg,yreg,'g*')
end

hold off

npoints_diff = npoints_base - npoints_reg;

if npoints_diff ~=0 % Error control
    T_manual = [];
    disp('Error: you need to select the same number of points in both images!')
else
    if strcmpi(reg_type,'landmark')
        u = [xbase ybase];
        x = [xreg yreg];
    elseif strcmpi(reg_type,'mask')
        u = base_refpoints;
        x = reg_refpoints;
    end
    
    dxu_mat = [];
    for j = 1:size(u,1)-1
        for k = j+1:size(u,1)
            du{j,k} = u(j,:) - u(k,:);
            alpha_var(j,k) = atan2d(du{j,k}(2),du{j,k}(1));
            dx{j,k} = x(j,:) - x(k,:);
            beta_var(j,k) = atan2d(dx{j,k}(2),dx{j,k}(1));
            
        end
        dxu_mat = [dxu_mat; u(j,:) - x(j,:)];
        
    end
    
    dxu_use = mean(dxu_mat,1);
    phi = alpha_var - beta_var;
    for k = 1:length(phi(:))
        if phi(k) > 180
            phi(k) = phi(k) - 360;
        end
    end
    
    phi_use = mean(mean(phi,1),2);
    
    % tform_manual = tform;
    T_manual = [cosd(phi_use) -sind(phi_use) 0 ; sind(phi_use) cosd(phi_use) 0 ; ...
        dxu_use(1) dxu_use(2) 1];
end




% AllIC_reg_manual = imwarp(reg_data.AllIC,tform_manual,'OutputView',imref2d(size(base_image)));
% moving_reg_manual = imwarp(reg_image,tform_manual,'OutputView',imref2d(size(base_image)));

% figure(10)
% imagesc(base_data.AllIC+ AllIC_reg_manual*2);  colormap(jet)
% title(['Combined Image Cells - Manual Adjust, rot = ' num2str(phi_use,'%1.2f') ' degrees']);


% h = colorbar('YTick',[0 1 2 3],'YTickLabel', {'','Base Image Cells','Reg Image Cells','Overlapping Cells'});
% xlabel(['X shifted by ' num2str(dxu_use(1),'%1.1f') ' pixels']);
% ylabel(['Y shifted by ' num2str(dxu_use(2),'%1.1f') ' pixels']);
% 
% figure(11)
% subplot(2,2,1)
% imagesc(base_image); colormap(gray); colorbar
% title('Base Image');
% subplot(2,2,2)
% imagesc(reg_image); colormap(gray); colorbar
% title('Image to Register');
% subplot(2,2,3)
% imagesc(moving_reg_manual); colormap(gray); colorbar
% title('Registered Image - Manual')
% subplot(2,2,4)
% imagesc(abs(moving_reg_manual - base_image)); colormap(gray); colorbar
% title('Registered Image - Base Image')
% 
% 
% tform3 = tform;
% tform3.T = [1 0 0 ; 0 1 0; -11 21 1];
% 
% AllIC_reg_check = imwarp(reg_data.AllIC,tform3,'OutputView',imref2d(size(base_image)));
% 
% figure(20)
% imagesc(base_data.AllIC+ AllIC_reg_check*2);  colormap(jet)
% title(['Combined Image Cells - Check, rot = ' num2str(acosd(tform3.T(1,1)),'%1.2f') ' degrees']);
% h = colorbar('YTick',[0 1 2 3],'YTickLabel', {'','Base Image Cells','Reg Image Cells','Overlapping Cells'});
% xlabel(['X shifted by ' num2str(tform3.T(3,1),'%1.1f') ' pixels']);
% ylabel(['Y shifted by ' num2str(tform3.T(3,2),'%1.1f') ' pixels']);
% 
% % Check image registration quality with histograms
% edges = 0:10:1000;
% 
% n_auto = histc(abs(moving_reg(:)-base_image(:)),edges);
% n_manual = histc(abs(moving_reg_manual(:)-base_image(:)),edges);
% 
% figure(22)
% plot(edges,n_auto,'r-',edges,n_manual,'b-.'); 
% legend('Auto','Manual')
% 
% % Overlay AllIC from separately registered sessions onto All_IC_combined
% 
% base_image = im2double(imread(base_file));
% [moving_reg r_reg] = imregister(base_image, base_image, regtype, optimizer, metric);
% 
% save ([ base_path 'RegistrationInfo.mat'], 'tform', 'tform_manual','AllIC',...
%     'AllIC_reg','AllIC_reg_manual','base_file','register_file')

end


% u1 = [171 89]; % [0 0]; % 
% u2 = [143 377]; % [0.707 -.707]; % 
% u3 =  [199 233]; % [-0.707 -.707]; %
% 
% u12 = u2-u1; alpha1 = atan2d(u12(2),u12(1));
% u13 = u3-u1; alpha2 = atan2d(u13(2),u13(1));
% u23 = u3-u2; alpha3 = atan2d(u23(2),u23(1));
% 
% x1 = [164 110]; % [0 0]; %
% x2 = [130 405]; % [0.707 .707]; %
% x3 = [191 257]; % [0.707 -.707]; %
% 
% x12 = x2-x1; beta1 = atan2d(x12(2),x12(1));
% x13 = x3-x1; beta2 = atan2d(x13(2),x13(1));
% x23 = x3-x2; beta3 = atan2d(x23(2),x23(1));
% 
% dx1 = x1 - u1; 
% dx2 = x2 - u2; 
% dx3 = x3 - u3; 
% dx_mat = [dx1 ; dx2 ; dx3 ];
% dx_use = mean(dx_mat,1);
% 
% phi(1) = alpha1-beta1;
% phi(2) = alpha2-beta2;
% phi(3) = alpha3-beta3;
% for j = 1:length(phi)
%     if abs(phi(j)) > 180
%        if phi(j) < 0
%            phi(j) = phi(j) + 360;
%        elseif phi(j) > 0
%            phi(j) = phi(j) - 360;
%        end
%     else
%     end
% end
% phi_use = mean(phi);
% 
% 
% xtrans = -dx_use(1); -11;
% ytrans = -dx_use(2); 21;
% rot = phi_use;
% 
% tform2 = tform;
% tform2.T = [cosd(rot) -sind(rot) 0 ; sind(rot) cosd(rot) 0 ; xtrans ytrans 1];
% AllIC_reg = imwarp(reg_data.AllIC,tform2,'OutputView',imref2d(size(base_image)));
% 
% tform3 = tform;
% tform3.T = [1 0 0 ; 0 1 0; -11 21 1];
% figure(FigNum)
% % subplot(3,1,1)
% % imagesc(base_data.AllIC); title('Base Image Cells')
% % subplot(3,1,2)
% % imagesc(AllIC_reg*2); title('Registered Image Cells')
% % subplot(3,1,3)
% imagesc(base_data.AllIC+ AllIC_reg*2); title('Combined Image Cells'); colormap(jet)
% h = colorbar('YTick',[0 1 2 3],'YTickLabel', {'','Base Image Cells','Reg Image Cells','Overlapping Cells'});
% 
% FigNum = FigNum + 1;
% 
% x1 = [171 89]