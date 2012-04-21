function fs = ComputeFeature(ii_ims, ftype)
    % ii_ims: is a cell array if integral images.
    % ftype:  is  a feature type.
    %
    
    % L is the length of the array ii_ims, take max of size so it dos't
    % matter if ii_ims is a colum or a line vecotr.
    L = max(size(ii_ims)); 
    fs = zeros(1,L);
    x = ftype(2); y = ftype(3);
    w = ftype(4); h = ftype(5);
    for i = 1:L
        ii_im = ii_ims{i};
        if ftype(1) == 1
            fs(i) = FeatureTypeI(ii_im, x, y, w, h);
        elseif ftype(1) == 2
            fs(i) = FeatureTypeII(ii_im, x, y, w, h);
        elseif ftype(1) == 3
            fs(i) = FeatureTypeIII(ii_im, x, y, w, h);
        elseif ftype(1) == 4
            fs(i) = FeatureTypeVI(ii_im, x, y, w, h);
        end
    end
end