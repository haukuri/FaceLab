function r = testVecBoxSum()
    [im,ii_im] = LoadIm('../TrainingImages/FACES/face00001.bmp');
    [hm,wm] = size(im);
    x = ceil(wm * rand());
    y = ceil(hm * rand());
    w = ceil((wm - x) * rand());
    h = ceil((hm - y) * rand());
    b_vec = VecBoxSum(x, y, w, h, wm, hm);
    A1 = ii_im(:)' * b_vec;
    A2 = ComputeboxSum(ii_im, x, y, w, h);
    r = abs(A1 - A2) < 1e-6;
end