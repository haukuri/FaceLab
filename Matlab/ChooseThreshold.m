function [thresh, tpr, fpr] = ChooseThreshold(Cparams, ii_ims, ys, target_tpr)
    
    % make ys logical and create not ys
    ys = logical(ys);
    n_ys = ~ys;

    % Number of training images:
    N = length(ys);
    
    % Score of each image:
    score =zeros(N,1);
    
    % calculate the score for each images:
    for i = 1:N
        ii_im = ii_ims(i,:);
        score(i) = ApplyDetector(Cparams, ii_im);
    end
    
    % Now we want to try different thresholds:
    
    thresholds = 0:0.01:10;
    L = length(thresholds);
    TPR = zeros(L,1); % True positive rate
    FPR = zeros(L,1); % False positive rate
    
    for i = 1:L
        thr = thresholds(i);
        TPR(i) = sum(score(ys)>=thr)/sum(ys);
        FPR(i) = sum(score(n_ys)>=thr)/sum(n_ys);
    end
    
    % Find the threshold that has TPR closests to target_tpr
    [~,argmin_Target_TPR] = min(abs(target_tpr-TPR));
    thresh = thresholds(argmin_Target_TPR);
    tpr = TPR(argmin_Target_TPR);
    fpr = FPR(argmin_Target_TPR);
end