function [tprs,fprs] = TestThresholds(ys, score, thrs)
    % Convert ys into a logical vector and create its inverse
    ys = logical(ys);
    nys = ~ys;
    
    % Calculate a true- and false positive rate for each threshold
    K = length(thrs);
    tprs = zeros(K,1);
    fprs = zeros(K,1);
    for k = 1:K
        tprs(k) = sum(score(ys) >= thrs(k)) / sum(ys);
        fprs(k) = sum(score(nys) >= thrs(k)) / sum(nys);
    end
end