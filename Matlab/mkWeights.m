function [ws] = mkWeights(pii_ims, nii_ims)
    np = size(pii_ims, 1);
    nn = size(nii_ims, 1);
    ws = [ones(np,1)/(2 * np);...
          ones(nn,1)/(2 * nn)];
end