function [r msg] = testVecAllFeatures()
    r = zeros(4,1);
    msg = 'Debug me';
    [~,ii_im] = LoadIm('../TrainingImages/FACES/face00001.bmp');
    ii_im = ii_im(1:5,1:5);
    W = 5;
    H = 5;
    % format :    t x y w h
    all_ftypes = [1 1 1 5 2; ...
        2 1 1 2 5; ...
        3 1 1 1 4; ...
        4 1 1 2 2];
    fmat = VecAllFeatures(all_ftypes, W, H);
    plainFeatures = { @FeatureTypeI, @FeatureTypeII, @FeatureTypeIII, ...
        @FeatureTypeIV};
    a = all_ftypes;
    for k = 1:4
        A1 = ii_im(:)' * fmat(:,k);
        f = plainFeatures{k};
        A2 = f(ii_im, a(k,2), a(k,3), a(k,4), a(k,5));
        r(k) = abs(A1 - A2) < 10e-6;
    end
    r = all(r);
end