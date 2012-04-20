function A = ComputeBoxSum(ii_im, x, y, w, h)
    % ii_im is an integral image
    % A = B(x,y,w,h) = sum(sum(im(y:y+h-1, x:x+w-1)))
    if ( x == 1 ) && ( y == 1 )
        A = ii_im(y+w-1,x+h-1);
    elseif ( x == 1)
        A = ii_im(y+w-1,x+h-1)-ii_im(y-1,x+h-1);
    elseif ( y == 1 )
        A = ii_im(y+w-1,x+h-1)-ii_im(y+w-1,x-1);
    else
        A = ii_im(y+w-1,x+h-1)-ii_im(y-1,x+h-1)-ii_im(y+w-1,x-1)+ii_im(y-1,x-1);
    end
end