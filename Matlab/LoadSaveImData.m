function LoadSaveImData(dirname, ni, im_sfn)
    % Saves ni random images on the format .jpg or .bmp from the dir
    % dirname to the file im_sfn.
    %
    % Example run:
    % LoadSaveImData('../TrainingImages/FACES',100,'gaur.mat')

    face_fnames = dir(dirname);
    ii_ims = zeros(ni, 19*19);
    aa = 3:length(face_fnames);
    a = randperm(length(aa));
    fnums = aa(a(1:ni)); 
    for i = 1:ni
        im_nr = fnums(i);
        fprintf('Loading %s\n', face_fnames(im_nr).name); 
        [~,ii_im] = LoadIm([dirname,'/',face_fnames(im_nr).name]);
        ii_ims(i,:) = ii_im(:);
    end
    save(im_sfn,'dirname', 'fnums', 'ii_ims');
end
        