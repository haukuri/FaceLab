function GetTrainingData(all_ftypes, np, nn)
    % np: number of faces.
    % nn: number of non faces.
    LoadSaveImData('../TrainingImages/FACES', np,'FaceData.mat');
    LoadSaveImData('../TrainingImages/NFACES', nn,'NonFaceData.mat');
    ComputeSaveFData(all_ftypes, 'FeaturesToUse.mat');
end

    