function CCparams = BuildCascade(Fdata, NFdata, FTdata, fpr_target, f, d, p)
    pF = floor(p*size(Fdata.ii_ims,1));
    pNF = floor(p*size(NFdata.ii_ims,1));
    P = Fdata.ii_ims(1:pF,:);       % Positive training
    Pv = Fdata.ii_ims(pF+1:end,:);  % Positive verification
    N = NFdata.ii_ims(1:pNF,:);     % Negative training
    Nv = NFdata.ii_ims(pNF+1:end,:);% Negative verification
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
        i = i + 1;
        Cparams = tCparams;
        
        % We need to create a new ys vector to reflect the possible change
        % in N. Also, we need to allocate a new weight vector for the new
        % strong classifier
        ys = mkYs(P, N);
        ws = mkWeights(P, N);
        ii_ims = [P;N];
        
        T = 0;
        fpr = 1; % to enter the loop
        while (fpr > f * fpr_last)
            T = T + 1;
            
            % Normalize the weight vector and train a new weak classifier.
            ws = ws/sum(ws);
            [Cparams, ws] = ...
                BoostingAlg_AddFeature(Cparams, ws, ii_ims, ys);
            
            % Update the cascaded classifier
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
%             figure(1)
%             stem(score); drawnow;
            
            % Choose a threshold
            target_tpr = d * tpr_last;
%             dthr = 0.001;
%             thr = 0;
%             [tpri,fpri] = TestThreshold(ysv, score, thr);
% %             figure(2)
% %             plot(thr, tpri, 'o', thr, fpri, 'x')
% %             legend('True Positive', 'False Positive')
% %             hold on
%             while 1
%                 tpri_last = tpri;
%                 fpri_last = fpri;
%                 thr_last = thr;
%                 thr = thr + dthr;
%                 [tpri,fpri] = TestThreshold(ysv, score, thr);
%                 if tpri < target_tpr
%                     tpr = tpri_last;
%                     fpr = fpri_last;
%                     thresh = thr_last;
%                     break
%                 end
% %                 plot(thr, tpri, 'o', thr, fpri, 'x');
% %                 drawnow;
%             end
%             hold off
%             CCparams{i}.thresh = thresh;
            
            [thresh, tpri, fpri] = ...
                ChooseThreshold(Cparams, ii_ims, ys, target_tpr);
            CCparams{i}.thresh = thresh;
            pos = score >= thresh;
            fpr_t = sum((ysv(pos) == 0)) / sum(~ysv);
            tpr_t = sum((ysv(pos) == 1)) / sum(ysv);
            fpr = fpri * fpr_last;
            tpr = tpri * tpr_last;

            fprintf('i = %i\t\t\t\tT = %i\n', i, T)
            fprintf('fpr = %g\t\t\tfpr_last = %g\n', fpr, fpr_last)
            fprintf('tpr = %g\t\t\t\ttpr_last = %g\n', tpr, tpr_last)
            fprintf('target_tpr = %g\tthreshold = %g\n\n', target_tpr, thresh)
            
        end
        fpr_last = fpr;
        tpr_last = tpr;
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
            
            
            pws = ws(1:size(P,1));
            nws = ws(ys == 0);
            ws = [pws; nws(pos(ys == 0))];
            N = ii_ims(ys(pos) == 0,:);
        end
    end
end