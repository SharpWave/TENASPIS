function [CluDist] = UpdateCluDistances(CluDist,meanX,meanY,ValidClu,CluToUpdate)

temp = sqrt((meanX-meanX(CluToUpdate)).^2+(meanY-meanY(CluToUpdate)).^2);
CluDist(CluToUpdate,:) = temp;
CluDist(:,CluToUpdate) = temp;


