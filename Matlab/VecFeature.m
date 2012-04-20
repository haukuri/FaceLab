function ftype_vec = VecFeature(ftype, W, H)
    ftype_vec = zeros(H,W);
    x = ftype(2);
    y = ftype(3);
    w = ftype(4);
    h = ftype(5);
    switch ftype(1)
        case 1
            ftype_vec = VecBoxSum(x, y, w, h, W, H) ...
                - VecBoxSum(x, y + h, w, h, W, H);
        case 2
            ftype_vec = VecBoxSum(x + w, y, w, h, W, H) ...
                - VecBoxSum(x, y, w, h, W, H);
        case 3
            ftype_vec = VecBoxSum(x + w, y, w, h, W, H) ...
                - VecBoxSum(x, y, w, h, W, H) ...
                - VecBoxSum(x + 2 * w, y, w, h, W, H);
        case 4
            ftype_vec = VecBoxSum(x, y, 2 * w, 2* h, W, H) ...
                - 2 * VecBoxSum(x, y, w,  h, W, H) ...
                - 2 * VecBoxSum(x + w, y + h, w, h, W, H);
        otherwise
            fprintf('%i is not a recognized feature\n', ftype(1));
    end
end