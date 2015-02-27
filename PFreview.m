function [] = PFreview(SP,FMap,t,x,y,pval,ip,idxs)

for i = idxs
    subplot(2,2,1);scatter(t,x,SP(i,:)*30+1,SP(i,:)*30+1);axis tight;
    subplot(2,2,2);scatter(t,y,SP(i,:)*30+1,SP(i,:)*30+1);axis tight;
    subplot(2,2,3);imagesc(FMap{i});colorbar;title([num2str(pval(i)),' ',int2str(ip(i))]);
    subplot(2,2,4);imagesc(FMap{i}>0.1);colorbar;title([num2str(pval(i)),' ',int2str(ip(i))]);i,pause;
end