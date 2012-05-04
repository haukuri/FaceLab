function cpic = MakeClassifierPic(all_ftypes, chosen_f, alphas, ps, W, H)
    cpic =zeros(W,H);
    for i = 1:length(alphas)
        cpic = cpic + ps(i)*alphas(i)*MakeFeaturePic(all_ftypes(chosen_f(i),:),W,H);
    end
end