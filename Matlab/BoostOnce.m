function [theta, alpha, err, j_star, p, ws] = BoostOnce(ws, ii_ims, ys, fmat)
    N = size(fmat,2);
    for j = 1:1000
        fs = VecComputeFeature(ii_ims, fmat(:,j));
        [theta2,p2,err2] = LearnWeakClassifier(ws, fs, ys);
        if j == 1 || err2 < err
            err = err2;
            theta = theta2;
            p = p2;
            j_star = j;
        end
    end
    beta = err/(1-err);
    fs = VecComputeFeature(ii_ims, fmat(:,j_star));
    for j = 1:length(ws)
        ws(j) = ws(j)*beta^(1-abs( (p*fs(j)<p*theta)-ys(j)));
    end
    alpha = log(1/beta);
end