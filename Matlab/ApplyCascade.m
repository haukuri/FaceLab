function [fg, sc] = ApplyCascade(CCparams, ii_im,ii_im2)
    

    ii_im = double(ii_im);
    
        mu = [];
    sigma2 = [];
    
    if nargin == 3
        % Cause the faces images are of size 19x19
        ii_im2 = double(ii_im2);
        L = 19;
        L2 = L*L;
    
        mu = ComputeBoxSum(ii_im,1,1,L,L)/L2;
        sigma2 = (ComputeBoxSum(ii_im2,1,1,L,L)-L2*mu*mu)/(L2-1);
    end

    % Number of classifiers in the cascade
    N = length(CCparams);
    
    sc = [];
    fg = 1;
    i = 1;
    
    
    while fg == 1 && i<=N
        Cparams = CCparams{i};
        alpha = Cparams.alphas';
        J = Cparams.Thetas(:,1);
        fmat = Cparams.fmat(:,J);
        theta = Cparams.Thetas(:,2);
        p = Cparams.Thetas(:,3);
        ftypes = Cparams.all_ftypes(J,:);
        
        
        sc = 0;
        for j = 1:length(alpha)
            fs = VecComputeFeature(ii_im(:)', fmat(:,j));
            if nargin == 3
                w = ftypes(j,4);
                h = ftypes(j,5);
                fs = (1/sqrt(sigma2))*(fs+(ftypes(j,1)==3)*w*h*mu);
            end
            sc = sc + alpha(j)*(p(j) * fs < p(j) * theta(j)); 
        end
        
        
        if (i < N) && (sc < Cparams.thresh)
            fg = 0;
            sc = [];
        end
        
        i = i + 1;
    end
end