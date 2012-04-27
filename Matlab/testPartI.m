dirname = '../TrainingImages/FACES';

%% Debug Point 1
clearvars -except dirname;
dinfo1 = load('../DebugInfo/debuginfo1.mat');
[im,ii_im] = LoadIm('../TrainingImages/FACES/face00001.bmp');
eps = 1e-6;
s1 = sum(abs(dinfo1.im(:) - im(:)) > eps)
s2 = sum(abs(dinfo1.ii_im(:) - ii_im(:)) > eps)

%% Debug Point 2
clearvars -except dirname;
dinfo2 = load('../DebugInfo/debuginfo2.mat');
[~,ii_im] = LoadIm('../TrainingImages/FACES/face00001.bmp');
x = dinfo2.x; y = dinfo2.y; w = dinfo2.w; h = dinfo2.h;
featIerr = abs(dinfo2.f1 - FeatureTypeI(ii_im, x, y, w, h)) > 10e-6
featIIerr = abs(dinfo2.f2 - FeatureTypeII(ii_im, x, y, w, h)) > 10e-6
featIIIerr = abs(dinfo2.f3 - FeatureTypeIII(ii_im, x, y, w, h)) > 10e-6
featIVerr = abs(dinfo2.f4 - FeatureTypeIV(ii_im, x, y, w, h)) > 10e-6


%% Debug Point 3
clearvars -except dirname;
dinfo3 = load('../DebugInfo/debuginfo3.mat');
faces = dir('../TrainingImages/Faces/face*.bmp');
faces = faces(1:100);
ii_ims = cell(100,1);
for k = 1:length(faces)
    [~,ii_im] = LoadIm(['../TrainingImages/Faces/' faces(k).name]);
    ii_ims{k} = ii_im;
end
ftype = dinfo3.ftype;
compFeatErr = sum(abs(dinfo3.fs - ComputeFeature(ii_ims, ftype)) > 10e-6)

%% Debug Point 4
clearvars -except dirname;
dinfo4 = load('../DebugInfo/debuginfo4.mat');
ni = dinfo4.ni;
all_ftypes = dinfo4.all_ftypes;
im_sfn = 'FaceData.mat';
f_sfn = 'FeaturesToMat.mat';
stream = RandStream('mt19937ar','seed', dinfo4.jseed);
RandStream.setDefaultStream(stream);
LoadSaveImData(dirname, ni, im_sfn);
ComputeSaveFData(all_ftypes, f_sfn);

% Test against debug data
load FaceData;
load FeaturesToMat;
fmateq = all(all(fmat == dinfo4.fmat))
ii_imseq = all(all(ii_ims == dinfo4.ii_ims))

%% Display integral image
[im,ii_im] = LoadIm('../TrainingImages/FACES/face00012.bmp');
figure();
imagesc(ii_im)
colormap gray
axis equal




dinfo5 = load('../DebugInfo/debuginfo5.mat');
np = dinfo5.np;
nn = dinfo5.nn;
all_ftypes = dinfo5.all_ftypes;
stream = RandStream('mt19937ar', 'seed', dinfo5.jseed);
RandStream.setDefaultStream(stream);
GetTrainingData(all_ftypes, np, nn);