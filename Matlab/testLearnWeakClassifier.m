clear all
%[Fdata,NFdata,FTdata] = loadData();
Fdata = load('FaceData2.mat');
NFdata = load('NonFaceData2.mat');
FTdata = load('FeaturesToUse2.mat');
ys = [ones(2000,1); zeros(4000,1)];
ftype_vec = FTdata.fmat(:,12028);%VecFeature(FTdata.all_ftypes(12028,:), FTdata.W, FTdata.H);
fs1 = VecComputeFeature(Fdata.ii_ims, ftype_vec);
fs2 = VecComputeFeature(NFdata.ii_ims, ftype_vec);
fs = [fs1;fs2];
ws = zeros(6000,1);
ws(1:2000)=1/4000;
ws(2001:end)=1/8000;
%ws = ones(6000,1)/6000;
%nanfs = isnan(fs);
%fs(nanfs) = 0;
[theta,p,err] = LearnWeakClassifier(ws, fs, ys)