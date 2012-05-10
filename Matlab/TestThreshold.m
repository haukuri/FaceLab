function [tpr,fpr] = TestThreshold(ys, score, thr)
    ys = logical(ys);
    nys = ~ys;
    tpr = sum(score(ys) >= thr) / sum(ys);
    fpr = sum(score(~nys) >= thr) / sum(nys);
end