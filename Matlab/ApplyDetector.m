function sc = ApplyDetector(Cparams, ii_im,ii_im2)
    % if nargin == 2 then it is assumed that the integral image is
    % normilized else if nargin == 3 then ii_im2 is the integral image of
    % the image squared.

    mu = [];
    sigma2 = [];
    
    if nargin == 3
        % Cause the faces images are of size 19x19
        L = 19;
        L2 = L*L;
    
        mu = ComputeBoxSum(ii_im,1,1,L,L)/L2;
        sigma2 = (ComputeBoxSum(ii_im2,1,1,L,L)-L2*mu*mu)/(L2-1);
    end

    alpha = Cparams.alphas';
    J = Cparams.Thetas(:,1);
    theta = Cparams.Thetas(:,2);
    p = Cparams.Thetas(:,3);
    fmat = Cparams.fmat(:,J);
    ftypes = Cparams.all_ftypes(J,:);
    
    %h = @(fs,p,theta) p * fs < p * theta;
    
    sc = 0;
    for i = 1:length(alpha)
        fs = VecComputeFeature(ii_im(:)', fmat(:,i));
        if nargin == 3
            w = ftypes(i,4);
            h = ftypes(i,5);
            fs = (1/sqrt(sigma2))*(fs+(ftypes(i,1)==3)*w*h*mu);
        end
        sc = sc + alpha(i)*(p(i) * fs < p(i) * theta(i));      
    end
end