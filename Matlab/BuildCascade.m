function CCparams = BuildCascade(Fdata, NFdata, FTdata, fpr_target, f, d, p)
    pF = floor(p*size(Fdata.ii_ims,1));
    pNF = floor(p*size(NFdata.ii_ims,1));
    P = Fdata.ii_ims(1:pF,:);       % Positive training
    Pv = Fdata.ii_ims(pF+1:end,:);  % Positive verification
    N = NFdata.ii_ims(1:pNF,:);     % Negative training
    Nv = NFdata.ii_ims(pNF+1:end,:); % Negative verification
    [ii_imsv,ysv,~] = mkTrainingParameters(Pv, Nv);
    CCparams = {};
    
    % A template for Cparams structures
    tCparams = struct('fmat', FTdata.fmat, ...
        'all_ftypes', FTdata.all_ftypes, 'alphas', [],...
        'Thetas', []);
    
    fpr = 1;      % F(i)
    tpr = 1;      % D(i)
    fpr_last = 1; % F(i-1)
    tpr_last = 1; % D(i-1)
    
    i = 0;
    while fpr > fpr_target
        i = i + 1
        Cparams = tCparams; % new Cparams
        [ii_ims,ys,ws] = mkTrainingParameters(P, N);
        T = 0;
        while fpr > f * fpr_last
            T = T + 1
            ws = ws/sum(ws);
            [Cparams, ws] = ...
                BoostingAlg_AddFeature(Cparams, ws, ii_ims, ys);
            CCparams{i} = Cparams;
            
            % Evaluate the current cascaded detector, including this latest
            % classifier, on the validation set.
            M = size(ii_imsv, 1);
            score = zeros(M,1);
            for n = 1:M
                [fg, sc] = ApplyCascade(CCparams, ii_imsv(n,:));
                if fg
                    score(n) = sc;
                end
            end
            
            % Choose a threshold
            target_tpr = d * tpr_last;
            [thresh, tpri, fpri] = ...
                ChooseThreshold(Cparams, ii_ims, ys, target_tpr);
            CCparams{i}.thresh = thresh;
            pos = score >= thresh;
            fpr = sum((ysv(pos) == 0)) / sum(~ysv);
            tpr = sum((ysv(pos) == 1)) / sum(ysv);
            fpr_last = fpr;
        end
        if fpr > fpr_target
            M = size(ii_ims, 1);
            score = zeros(M,1);
            for n = 1:M
                [fg, sc] = ApplyCascade(CCparams, ii_ims(n,:));
                if fg
                    score(n) = sc;
                end
            end
            pos = score >= thresh;
            N = ii_ims(ys(pos) == 0,:);
        end
    end
end