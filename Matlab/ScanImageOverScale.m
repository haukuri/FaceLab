function dets = ScanImageOverScale(Cparams, im, min_s, max_s, step_s)
    % im is either an image or a path of an image
    
    if size(im,1) == 1
        % im is a path to an image
        im = imread(im);
    end
    
    % check if im is color
    if length(size(im)) == 3
        im = rgb2gray(im);
    end
    im = double(im);
    
    scales = min_s:step_s:max_s
    
    dets = [];
    length(scales)
    for i = 1:length(scales)
        s = scales(i);
        im2 = imresize(im,s);
        dets2 = ScanImageFixedSize(Cparams, im2);
        dets =[dets;round((1/s)*[dets2])];
    end
end