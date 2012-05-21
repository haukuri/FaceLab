p = 0.7;
T = 100;

[Fdata,NFdata,FTdata] = loadData();
[tFdata,vFdata] = SplitData(Fdata, p);
[tNFdata,vNFdata] = SplitData(NFdata, p);

profile on;
Cparams = BoostingAlg(tFdata, tNFdata, FTdata, T);
profile viewer