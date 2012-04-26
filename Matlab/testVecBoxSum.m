function [r msg] = testVecBoxSum()
    [im,ii_im] = LoadIm('../TrainingImages/FACES/face00001.bmp');
    [hm,wm] = size(im);
    x = ceil(wm * rand());
    y = ceil(hm * rand());
    w = max([ceil((wm - x) * rand()) 1]);
    h = max([ceil((hm - y) * rand()) 1]);
    b_vec = VecBoxSum(x, y, w, h, wm, hm);
    A1 = ii_im(:)' * b_vec;
    A2 = ComputeBoxSum(ii_im, x, y, w, h);
    r = abs(A1 - A2) < 1e-6;
    msg = sprintf('x = %g\t y = %g\t w = %g\t h = %g\n', x, y, w, h);
end