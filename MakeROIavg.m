function MakeROIavg()
load('ProcOut.mat','NeuronAvg');

ROIavg = NeuronAvg;

save ROIavg.mat ROIavg;

