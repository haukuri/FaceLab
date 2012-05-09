function [ii_ims,ys,ws] = mkTrainingParameters(pii_ims, nii_ims)
    np = size(pii_ims, 1);
    nn = size(nii_ims, 1);
    ys = [ones(np, 1); zeros(nn, 1)];
    ws = ones(np+nn);
    ws(1:np) = 1/(2 * np);
    ws(np+1:end) = 1/(2 * nn);
    ii_ims = [pii_ims; nii_ims];
end