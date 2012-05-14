%% Generate data
doGenerateTrainingData(4858,9096)

%% Build the cascaded classifier
clear all
[Fdata,NFdata,FTdata] = loadData();
CCParams = BuildCascade(Fdata, NFdata, FTdata, .01, .4, .98, .6);

%% Try it out
impath = '../TestImages/one_chris.png';
im = imread(impath);
dets = ScanImageWithCascade(CCparams, im);
figure(); DisplayDetections(im, dets);
fdets = PruneDetections(dets);
figure(); DisplayDetections(im, fdets);