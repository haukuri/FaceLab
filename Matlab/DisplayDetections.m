function DisplayDetections(im, dets)
    % dets = [x,y,x+18,y+18]
    % im is either an image or a path of an image
    
    if size(im,1) == 1
        % im is a path to an image
        im = imread(im);
    end
    
    N = size(dets,1);
    
    imagesc(im)
    hold on
    for i = 1:N
        x1 = dets(i,1);
        x2 = dets(i,3);
        y1 = dets(i,2);
        y2 = dets(i,4);
        x = [x1,x1,x2,x2,x1];
        y = [y1,y2,y2,y1,y1];
        plot(x,y,'r-')
    end
    axis equal
    hold off
end