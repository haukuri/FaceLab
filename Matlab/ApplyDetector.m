function sc = ApplyDetector(Cparams, ii_im)

    ii_im = ii_im(:)';

    alpha = Cparams.alphas';
    J = Cparams.Thetas(:,1);
    theta = Cparams.Thetas(:,2);
    p = Cparams.Thetas(:,3);
    fmat = Cparams.fmat(:,J);
    
    h = @(fs,p,theta) p * fs < p * theta;
    
    sc = 0;
    for i = 1:length(alpha)
        fs = VecComputeFeature(ii_im, fmat(:,i));
        sc = sc + alpha(i)*(p(i) * fs < p(i) * theta(i));       
    end
end