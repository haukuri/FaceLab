function [im,ii_im] = LoadIm(im_fname)
   im = double(imread(im_fname));
   if std(im(:)) == 0
      im = zeros(size(im));
   else
      im = (im - mean(im(:))) / std(im(:));
   end
   ii_im = cumsum(cumsum(im,1),2);
end