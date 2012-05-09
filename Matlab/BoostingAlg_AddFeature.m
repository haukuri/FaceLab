function [Cparams, nws] = BoostingAlg_AddFeature(Cparams, ws, ii_ims, ys)
    ws = ws/sum(ws);
    fmat = sparse(Cparams.fmat);
    [theta, alpha, ~, j_star, p, nws] = BoostOnce(ws, ii_ims, ys, fmat);
    Cparams.alphas = [Cparams.alphas; alpha];
    Cparams.Thetas = [Cparams.Thetas; j_star, theta, p];
end