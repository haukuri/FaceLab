function dets = ScanImageFixedSize(Cparams, im)
    
    im = double(im);
    
    % check if im is color
    if length(size(im)) == 3
        im = rgb2gray(im);
    end
    
    % image size
    [h,w]=size(im);
  
    % Compute the square
    im2 = im.*im;
    
    % Compute the integral images
    %if std(im(:)) == 0
    %   im = zeros(size(im));
    %   im2 = zeros(size(im2));
    %else
    %   im = (im - mean(im(:))) / std(im(:));
    %   im2 = (im2 - mean(im2(:))) / std(im2(:));
    %end
    ii_im = cumsum(cumsum(im,1),2);
    ii_im2 = cumsum(cumsum(im2,1),2);
    
    J = Cparams.Thetas(:,1);
    % the ftypes we use here
    ftypes = Cparams.all_ftypes(J,:);
    fmat = Cparams.fmat(:,J);
    f_len = size(fmat,2);
   
    threshold = 0.5*sum(Cparams.alphas); 
    
    dets =[];
    
    for x = 1:w-18
        for y = 1:h-18
            % The subwindows
            I = ii_im(x:x+18,y:y+18);
            I2 = ii_im2(x:x+18,y:y+18);
            sc = ApplyDetector(Cparams, I, I2);
            if threshold < sc
                % this is a face
                dets = [dets; [x,y,x+w-1,y+h-1]];
            end
        end
    end
end


    