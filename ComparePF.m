function [ ] = ComparePF(file1,file2,cellmap)

load([file1,'.mat']);
Map1 = AdjMap;
IC1 = IC;
NumAct1 = AnalyzePF(file1);

load([file2,'.mat']);
Map2 = AdjMap;
IC2 = IC;
NumAct2 = AnalyzePF(file2);


for i = 1:length(IC)
    i
    figure(1);
    if isempty(cellmap{i,3}) continue;end;
    
%     subplot(2,2,1);imshow(Map1{i});set(gca,'YDir','normal');title(int2str(NumAct1(i)));
%     subplot(2,2,2);imshow(Map2{cellmap{i,3}});set(gca,'YDir','normal');title(int2str(NumAct2(cellmap{i,3})));
%     subplot(2,2,3);imagesc(IC1{i});
%     subplot(2,2,4);imagesc(IC2{cellmap{i,3}});
    
    Act1(i) = NumAct1(i);
    Act2(i) = NumAct2(cellmap{i,3});
    %pause;

end

plot(Act1,Act2,'*');keyboard;

