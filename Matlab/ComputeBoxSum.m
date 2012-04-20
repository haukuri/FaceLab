function A = ComputeBoxSum(ii_im, x, y, w, h)
    A = ii_im(y+h-1,x+w-1);
    if (y > 1)
        A = A - ii_im(y-1,x+w-1);
    end
    if (x > 1)
        A = A - ii_im(y+h-1,x-1);
    end
    if (x > 1 && y > 1)
        A = A + ii_im(y-1,x-1);
    end
end