p = 0.7;
T = 100;

[Fdata,NFdata,FTdata] = loadData();
[tFdata,vFdata] = SplitData(Fdata, p);
[tNFdata,vNFdata] = SplitData(NFdata, p);

profile on;
Cparams = BoostingAlg(tFdata, tNFdata, FTdata, T);
profile viewer

[sc,curve] = ComputeROCFromData(Cparams, vFdata, vNFdata);
plot(curve(:,1),curve(:,2))
xlabel('FPR'); ylabel('TPR')
title('ROC curve')