function [x, y, w, h] = generateBoxParams(W,H)
    x = ceil(W * rand());
    y = ceil(H * rand());
    w = ceil((W - x) * rand());
    h = ceil((H - y) * rand());
end