function [DistTrav,Ac,Xc,Yc] = TransientStats()
% For each detected calcium transient, track evolution of area and centroid

load CC.mat;


for i = 1:length(SegChain)
    % for each transient
    for j = 1:length(SegChain{i})
        % for each frame in the transient
        frame = SegChain{i}{j}(1);
        seg = SegChain{i}{j}(2);
        Xc{i}(j) = ccprops{frame}(seg).Centroid(1);
        Yc{i}(j) = ccprops{frame}(seg).Centroid(2);
        Ac{i}(j) = ccprops{frame}(seg).Area;

    end
    DistTrav(i) = sqrt((Xc{i}(end)-Xc{i}(1))^2+(Yc{i}(end)-Yc{i}(1))^2);

end
% 
% 
% keyboard;
% % BrowseThrough
% for i = 1:NumSegments
%     subplot(1,2,1);plot(Ac{i});xlabel('frame');ylabel('area of blob')'
%     subplot(1,2,2);plot(Xc{i},Yc{i});xlabel('x centroid');ylabel('y centroid');
%     set(gca,'Xlim',[0 Xdim],'Ylim',[0 Ydim])
%     pause;
% end
% keyboard;




end

