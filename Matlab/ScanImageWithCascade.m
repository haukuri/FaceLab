function dets = ScanImageWithCascade(CCparams, im)
    

    
    if size(im,1) == 1
        % im is a path to an image
        im = imread(im);
    end
    
    % check if im is color
    if length(size(im)) == 3
        im = rgb2gray(im);
    end
    im = double(im);
    
    R =[];
    
    % image size
    [h,w]=size(im);
  
    % Compute the square
    im2 = im.*im;
    

    %ii_im = cumsum(cumsum(im,1),2);
    %ii_im2 = cumsum(cumsum(im2,1),2);
    
   
    
    %threshold = Cparams.thresh;%0.5*sum(Cparams.alphas);
    
    dets =[];
    detsc = [];
    
    L = 19;
    
    for x = 1:w-18
        for y = 1:h-18
            % The subwindows
            %I = ii_im(y:y+18,x:x+18);
            %I2 = ii_im2(y:y+18,x:x+18);
% Another way to make I and I2            
%             if ( x == 1 ) && ( y == 1 )
%                 I = ii_im(y:y+18,x:x+18);
%                 I2 = ii_im2(y:y+18,x:x+18);
%             elseif ( x == 1)
%                 I = ii_im(y:y+18,x:x+18)-ones(L,1)*ii_im(y-1,x:x+18);
%                 I2 = ii_im2(y:y+18,x:x+18)-ones(L,1)*ii_im2(y-1,x:x+18);
%             elseif ( y == 1 )
%                 I = ii_im(y:y+18,x:x+18)-ii_im(y:y+18,x-1)*ones(1,L);
%                 I2 = ii_im2(y:y+18,x:x+18)-ii_im2(y:y+18,x-1)*ones(1,L);
%             else
%                 I = ii_im(y:y+18,x:x+18)-ones(L,1)*ii_im(y-1,x:x+18)...
%                     -ii_im(y:y+18,x-1)*ones(1,L)+ii_im(y-1,x-1);
%                 I2 = ii_im2(y:y+18,x:x+18)-ones(L,1)*ii_im2(y-1,x:x+18)...
%                     -ii_im2(y:y+18,x-1)*ones(1,L)+ii_im2(y-1,x-1);
%             end

            % create an integral image frome the current frame
            I = im(y:y+18,x:x+18);
            I2 = im2(y:y+18,x:x+18);
            I = cumsum(cumsum(I,1),2);
            I2 = cumsum(cumsum(I2,1),2);

            [fg, sc] = ApplyCascade(CCparams, I, I2);
            if fg == 0
                sc = 0;
            end

            if  CCparams{end}.thresh < sc
                % a Face has been detected
                dets = [dets; [x,y,x+18,y+18]];
                detsc = [detsc; sc];
            end
        end
    end
end


    