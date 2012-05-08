function Cparams = BoostingAlg(Fdata, NFdata, FTdata, T)
    
    % Get the image data
    fmat = sparse(FTdata.fmat); % sparse drastically improves performance
    N = size(fmat,2);
    faces  = Fdata.ii_ims;
    Nfaces = NFdata.ii_ims;
    Images = [faces;Nfaces];
    nf =  size(faces,1);
    nNf =  size(Nfaces,1);
    % Create the y vector, says which class each image belongse to.
    ys = [ones(nf,1);zeros(nNf,1)];
    % initialize weigths:
    ws = zeros(nf + nNf,1);
    ws(1:nf) = 1/(2 * nf);
    ws(nf+1:end) = 1/(2 * nNf);
    
    h = @(fs,p,theta) p * fs < p * theta;
    
    THETAS = zeros(T,1);
    ALPHAS = zeros(T,1);
    ERRORS = zeros(T,1);
    J = zeros(T,1);
    P = zeros(T,1);
    for t = 1:T
        ws = ws/sum(ws);
%        figure(t)
%        stem(ws) 
%        drawnow
        theta = [];
        err = [];
        j_star = [];
        p =[];
        for j = 1:N
            fs = VecComputeFeature(Images, fmat(:,j));
            [theta2,p2,err2] = LearnWeakClassifier(ws, fs, ys);
            if j == 1 || err2 < err
                err = err2;
                theta = theta2;
                p = p2;
                j_star = j;
            end 
            %%%%
            %if j == 477 && t==2
            %    disp([j_star,err,err2]);
            %end
            %%%%
        end
        THETAS(t) = theta;
        ERRORS(t) = err;
        beta = err/(1-err);
        fs = VecComputeFeature(Images, fmat(:,j_star));
        %ws = ws.*beta.^(1-abs(h(fs,p,theta)-ys));
        for j = 1:length(ws)
           ws(j) = ws(j)*beta^(1-abs( (p*fs(j)<p*theta)-ys(j)));
        end
        ALPHAS(t) = log(1/beta);
        J(t) = j_star;
        P(t) = p;
    end
    Cparams.alphas = ALPHAS; 
    Cparams.Thetas = [J,THETAS,P]; 
    Cparams.fmat = fmat; 
    Cparams.all_ftypes = FTdata.all_ftypes;
end