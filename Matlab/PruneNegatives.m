function N = PruneNegatives(ii_ims, ys, CCparams, i)
    M = size(ii_ims, 1);
    score = zeros(M,1);
    for n = 1:M
        [fg, sc] = ApplyCascade(CCparams, ii_ims(n,:));
        if fg
            score(n) = sc;
        end
    end
    pos = score >= CCparams{i}.thresh;
    %pws = ws(ys == 1);
    %nws = ws(ys(pos) == 0);
    %ws = [pws;nws];
    N = ii_ims(ys(pos) == 0,:);
end