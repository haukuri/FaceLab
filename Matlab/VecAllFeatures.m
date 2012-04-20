function fmat = VecAllFeatures(all_ftypes, W, H)
    nf = size(all_featues, 1);
    fmat = zeros(W * H, nf);
    for k = nf
        fmat(:,k) = VecFeature(all_ftypes(k,:));
    end
end