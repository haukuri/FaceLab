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
    
    THETAS = zeros(T,1);
    ALPHAS = zeros(T,1);
    ERRORS = zeros(T,1);
    J = zeros(T,1);
    P = zeros(T,1);
    for t = 1:T
        ws = ws/sum(ws);
        [theta, alpha, err, j_star, p, ws] = BoostOnce(ws, Images, ys, fmat);
        THETAS(t) = theta;
        ERRORS(t) = err;
        ALPHAS(t) = alpha;
        J(t) = j_star;
        P(t) = p;
    end
    Cparams.alphas = ALPHAS; 
    Cparams.Thetas = [J,THETAS,P]; 
    Cparams.fmat = fmat; 
    Cparams.all_ftypes = FTdata.all_ftypes;
end