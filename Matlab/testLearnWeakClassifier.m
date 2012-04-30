clear all
[Fdata,NFdata,FTdata] = loadData();
ys = [ones(2000,1); zeros(4000,1)];
ftype_vec = VecFeature(FTdata.all_ftypes(12028,:), FTdata.W, FTdata.H);
fs1 = VecComputeFeature(Fdata.ii_ims, ftype_vec);
fs2 = VecComputeFeature(NFdata.ii_ims, ftype_vec);
fs = [fs1;fs2];
ws = ones(6000,1)/6000;
nanfs = isnan(fs);
fs(nanfs) = 0;
[theta,p,err] = LearnWeakClassifier(ws, fs, ys)