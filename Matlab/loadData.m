function [Fdata,NFdata,FTdata] = loadData()
    Fdata = load('FaceData');
    NFdata = load('NonFaceData');
    FTdata = load('FeaturesToUse');
end