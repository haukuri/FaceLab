function fmat = VecAllFeatures(all_ftypes, W, H)
    nf = size(all_ftypes, 1);
    fmat = zeros(W * H, nf);
    for k = 1:nf
        fmat(:,k) = VecFeature(all_ftypes(k,:), W, H);
    end
end