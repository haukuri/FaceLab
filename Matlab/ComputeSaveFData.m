function ComputeSaveFData(all_ftypes, f_sfn)
    % Saves all 
    %
    W = 19; H = 19;
    fmat = VecAllFeatures(all_ftypes, W, H);
    fmat = sparse(fmat);
    save(f_sfn,'fmat','all_ftypes','W','H');
end