function [fg, sc] = ApplyCascade(CCparams, ii_im)
    
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
        
        
        sc = 0;
        for j = 1:length(alpha)
            fs = VecComputeFeature(ii_im(:)', fmat(:,j));
            sc = sc + alpha(j)*(p(j) * fs < p(j) * theta(j)); 
        end
        
        
        if (i < N) && (sc < Cparams.thresh)
            fg = 0;
            sc = [];
        end
        
        i = i + 1;
    end
end