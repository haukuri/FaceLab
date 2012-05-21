function [score, curve] = ComputeROCFromData(Cparams, Fdata, NFdata)

    lotF = size(Fdata.ii_ims,1);
    lotNF = size(NFdata.ii_ims,1);
    score = zeros(lotF+lotNF,2);
    for i = 1:lotF
        im =  Fdata.ii_ims(i,:);
        score(i,:) = [1,ApplyDetector(Cparams, reshape(im,[19,19]))];
    end
    for i = 1:lotNF
        im =  NFdata.ii_ims(i,:);
        score(lotF+i,:) = [0,ApplyDetector(Cparams, reshape(im,[19,19]))];
    end   
    threshold = 0:0.1:30;
    L = length(threshold);
    curve = zeros(L,3);
    for i = 1:L
        thr = threshold(i);
        TPR = sum(score(1:lotF,2)>thr)/lotF;
        FPR = sum(score(lotF+1:end,2)>thr)/lotNF;
        curve(i,:)=[FPR,TPR,thr];
    end
end