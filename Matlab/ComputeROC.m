function [score,f_detected,curve] = ComputeROC(Cparams, Fdata, NFdata)
    
    % f_detected is a face detector where we use the threshold
    % from algorithm 1.
    % - each line in f_detected corresponds to an test images
    % - column 1 of f_detected is 1 if the test images is a face and 0
    %   otherwise.
    % - column 2 of f_detected is 1 if face is detected on the image and 0
    %   otherwise.
  
    % the images we used for training
    fnums = Fdata.fnums;
    nfnums = NFdata.fnums;
    
    % Directories of the images
    fdir  = '../TrainingImages/FACES';
    nfdir = '../TrainingImages/NFACES';
    
    % All the faces images and non face images:
    face_fnames = dir(fdir);
    nface_fnames = dir(nfdir);
    % Face images we did not use for training
    fimages  = setdiff(3:length(face_fnames),fnums);
    nfimages = setdiff(3:length(nface_fnames),nfnums);
    
    % Length of tests:
    lotF  = length(fimages)
    lotNF = length(nfimages)
    
    % alphas 
    alphas = Cparams.alphas;
    threshold = 0.5*sum(alphas);
    
    % column 1: 1 if face, 0 otherwise
    % column 2: 1 if face is detectet, 0 otherwise.
    f_detected = zeros(lotF+lotNF,2);
    
    % column 1: 1 if face, 0 otherwise
    % column 2: score of the images
    score =zeros(lotF+lotNF,2);
    for i = 1:lotF
        im_nr = fimages(i);
        [~,ii_im] = LoadIm([fdir,'/',face_fnames(im_nr).name]);
        score(i,:) = [1,ApplyDetector(Cparams, ii_im)];
        f_detected(i,:) = [1, score(i,2)>threshold];
    end
    for i = 1:lotNF
        im_nr = nfimages(i);
        [~,ii_im] = LoadIm([nfdir,'/',nface_fnames(im_nr).name]);
        score(lotF+i,:) = [0,ApplyDetector(Cparams, ii_im)];
        f_detected(lotF+i,:) = [0, score(lotF+i,2)>threshold];
    end   
    % Compute true and false positive rates: 
    fprintf(['True positive rate for threshold =',num2str(threshold),':\n']);
    fprintf(['   ',num2str(sum(f_detected(1:lotF,2))/lotF),'\n']);
    fprintf(['False positive rate for threshold =',num2str(threshold),':\n']);
    fprintf(['   ',num2str(sum(f_detected(lotF+1:end,2))/lotNF),'\n']);
    
    % Now we want to compute TPR and FPR for threshold=0:0.5:10
    threshold = 0:0.5:10;
    L = length(threshold);
    curve = zeros(L,2);
    str = cell(1,L);
    for i = 1:L
        thr = threshold(i);
        TPR = sum(score(1:lotF,2)>thr)/lotF;
        FPR = sum(score(lotF+1:end,2)>thr)/lotNF;
        curve(i,:)=[FPR,TPR];
        str{i} = num2str(thr);
    end
    
    plot(curve(:,1),curve(:,2))
    xlabel('FPR')
    ylabel('TPR')
end