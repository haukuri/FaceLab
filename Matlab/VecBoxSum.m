function b_vec = VecBoxSum(x, y, w, h, W, H)
    b_vec = zeros(H,W);
    if ( x == 1 ) && ( y == 1 )
        b_vec(y+h-1,x+w-1) = 1;
    elseif ( x == 1)
        b_vec(y+h-1,x+w-1) = 1;
        b_vec(y-1,x+w-1) = -1;
    elseif ( y == 1 )
        b_vec(y+h-1,x+w-1) = 1;
        b_vec(y+h-1,x-1) = -1;
    else
        b_vec(y+h-1,x+w-1) = 1;
        b_vec(y-1,x+w-1) = -1;
        b_vec(y+h-1,x-1) = -1;
        b_vec(y-1,x-1) = 1;
    end
    b_vec = b_vec(:);
end