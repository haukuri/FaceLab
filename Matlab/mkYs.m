function ys = mkYs(pii_ims, nii_ims)
    np = size(pii_ims, 1);
    nn = size(nii_ims, 1);
    ys = [ones(np, 1); zeros(nn, 1)];
end