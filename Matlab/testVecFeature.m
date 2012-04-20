function [r msg] = testVecFeature()
    r = ones(4,1);
    msg = '';
    [~,ii_im] = LoadIm('../TrainingImages/FACES/face00001.bmp');
    
    % Feature I
    x = 2; y = 2; w = 5; h = 3;
    ftype_vec = VecFeature([1,x,y,w,h], 19, 19);
    A1 = ii_im(:)' * ftype_vec;
    A2 = FeatureTypeI(ii_im, x, y, w, h);
    r(1) = abs(A1 - A2) < 10e-6;
    if ~r(1)
        msg = [msg sprintf(['Feature I failed with parameters:\n\t' ...
            'x = %g\t y = %g\t w = %g\t h = %g\n'], x, y, w, h)];
    end
    
    % Feature II
    x = 2; y = 2; w = 3; h = 7;
    ftype_vec = VecFeature([2,x,y,w,h], 19, 19);
    A1 = ii_im(:)' * ftype_vec;
    A2 = FeatureTypeII(ii_im, x, y, w, h);
    r(2) = abs(A1 - A2) < 10e-6;
    if ~r(2)
        msg = [msg sprintf(['Feature II failed with parameters:\n\t' ...
            'x = %g\t y = %g\t w = %g\t h = %g\n'], x, y, w, h)];
    end
    
    % Feature III
    x = 2; y = 2; w = 3; h = 7;
    ftype_vec = VecFeature([3,x,y,w,h], 19, 19);
    A1 = ii_im(:)' * ftype_vec;
    A2 = FeatureTypeIII(ii_im, x, y, w, h);
    r(3) = abs(A1 - A2) < 10e-6;
    if ~r(3)
        msg = [msg sprintf(['Feature III failed with parameters:\n\t' ...
            'x = %g\t y = %g\t w = %g\t h = %g\n'], x, y, w, h)];
    end
    
    % Feature IV
    x = 2; y = 2; w = 4; h = 3;
    ftype_vec = VecFeature([4,x,y,w,h], 19, 19);
    A1 = ii_im(:)' * ftype_vec;
    A2 = FeatureTypeIV(ii_im, x, y, w, h);
    r(4) = abs(A1 - A2) < 10e-6;
    if ~r(4)
        msg = [msg sprintf(['Feature IV failed with parameters:\n\t' ...
            'x = %g\t y = %g\t w = %g\t h = %g\n'], x, y, w, h)];
    end
    
    r = all(r);
end