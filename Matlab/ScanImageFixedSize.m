function [dets,R,I2] = ScanImageFixedSize(Cparams, im)
    
    %im = imread(im);
    
    
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
    
    
    J = Cparams.Thetas(:,1);
    % the ftypes we use here
    
    threshold = 6.4;%0.5*sum(Cparams.alphas); 
    
    dets =[];
    
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

            I = im(y:y+18,x:x+18);
            I2 = im2(y:y+18,x:x+18);
            I = cumsum(cumsum(I,1),2);
            I2 = cumsum(cumsum(I2,1),2);
            
            sc = ApplyDetector(Cparams, I, I2);
            if threshold < sc
                % this is a face
                dets = [dets; [x,y,x+18,y+18]];
            end
        end
    end
end


    