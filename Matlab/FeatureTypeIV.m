function f = FeatureTypeIV(ii_im, x, y, w, h)
    f = ComputeBoxSum(ii_im, x, y, 2 * w, 2 * h);
    f = f - 2 * ComputeBoxSum(ii_im, x, y, w, h);
    f = f - 2 * ComputeBoxSum(ii_im, x + w, y + h, w, h);
end