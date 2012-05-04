function fpic = MakeFeaturePic(ftype, W, H)
    % Returns an image like figure 2 for ftype
    type = ftype(1);
    x = ftype(2);
    y = ftype(3);
    w = ftype(4);
    h = ftype(5);
    
    fpic = zeros(H,W);
    if type == 1
        fpic(y:y+h-1,x:x+w-1) = -1;
        fpic(y+h:y+2*h-1,x:x+w-1) = 1;
    elseif type == 2
        fpic(y:y+h-1,x:x+w-1) = 1;
        fpic(y:y+h-1,x+w:x+2*w-1) = -1;
    elseif type == 3
        fpic(y:y+h-1,x:x+w-1) = 1;
        fpic(y:y+h-1,x+w:x+2*w-1) = -1;
        fpic(y:y+h-1,x+2*w:x+3*w-1) = 1;
    elseif type == 4
        fpic(y:y+h-1,x:x+w-1) = 1;
        fpic(y:y+h-1,x+w:x+2*w-1) = -1;
        fpic(y+h:y+2*h-1,x:x+w-1) = -1;
        fpic(y+h:y+2*h-1,x+w:x+2*w-1) = 1;
    end
            
    