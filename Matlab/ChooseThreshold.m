function [thresh, tpr, fpr] = ChooseThreshold(Cparams, ii_ims, ys, target_tpr)
    
    % make ys logical and create not ys
    ys = logical(ys);
    n_ys = ~ys;

    % Number of training images:
    N = length(ys);
    
    % Score of each image:
    score =zeros(N,1);
    
    % calculate the score for each image:
    % use the correct apply function depending on whether we have a
    % cascaded or non-cascaded detector
    if iscell(Cparams)
        for i = 1:N
            ii_im = ii_ims(i,:);
            [not_rejected_earlier,s] = ApplyCascade(Cparams, ii_im);
            if not_rejected_earlier
                score(i) = s;
            end
        end
    else
        for i = 1:N
            ii_im = ii_ims(i,:);
            score(i) = ApplyDetector(Cparams, ii_im);
        end
    end
    
    
    % Now we want to try different thresholds:
    
    thresholds = 0:0.001:max(score);
    L = length(thresholds);
    TPR = zeros(L,1); % True positive rate
    FPR = zeros(L,1); % False positive rate
    
    for i = 1:L
        thr = thresholds(i);
        TPR(i) = sum(score(ys)>=thr)/sum(ys);
        FPR(i) = sum(score(n_ys)>=thr)/sum(n_ys);
    end
    
    % Find the threshold that has TPR closests to target_tpr
    %TPRm = TPR(TPR > target_tpr); % need this to satisfy BuildCascade
    %assert(~isempty(TPRm), 'No tpr > target_tpr found');
%     [~,argmin_Target_TPR] = min(abs(target_tpr-TPR));
%     thresh = thresholds(argmin_Target_TPR);
%     tpr = TPR(argmin_Target_TPR);
%     fpr = FPR(argmin_Target_TPR);
    [thresh,i] = max(thresholds(TPR >= target_tpr));
    tpr = TPR(i);
    fpr = FPR(i);

end