function [r msg] = testComputeBoxSum()
    [im,ii_im] = LoadIm('../TrainingImages/FACES/face00001.bmp');
    [hm,wm] = size(im);
    x = ceil(wm * rand());
    y = ceil(hm * rand());
    w = ceil((wm - x) * rand());
    h = ceil((hm - y) * rand());
    r = abs(ComputeBoxSum(ii_im, x, y, w, h) ...
        - sum(sum(im(y:(y+h-1),x:(x+w-1)),1),2)) < 1e-6;
    msg = '';
end