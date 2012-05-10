function CCparams = BuildCascade(Fdata, NFdata, FTdata, fpr_target, f, d, p)
    % Split the data into training and validation sets according to p
    pF = floor(p*size(Fdata.ii_ims,1));
    pNF = floor(p*size(NFdata.ii_ims,1));
    P = Fdata.ii_ims(1:pF,:);       % Positive training
    Pv = Fdata.ii_ims(pF+1:end,:);  % Positive verification
    N = NFdata.ii_ims(1:pNF,:);     % Negative training
    Nv = NFdata.ii_ims(pNF+1:end,:);% Negative verification
    
    % The validation set
    ysv = mkYs(Pv, Nv);
    ii_imsv = [Pv;Nv];
    
    % The cascaded classifier
    CCparams = {};
    
    % A template Cparam for the strong classifiers
    tCparams = struct('fmat', FTdata.fmat, ...
        'all_ftypes', FTdata.all_ftypes, 'alphas', [],...
        'Thetas', []);
    
    % The false- and true positives
    fpr = 1;      % F(i)
    tpr = 1;      % D(i)
    fpr_last = 1; % F(i-1)
    tpr_last = 1; % D(i-1)
    
    % The number of strong classifiers in the cascade
    i = 0;
    
    while fpr > fpr_target
        i = i + 1;
        
        % Create a new strong classifier
        Cparams = tCparams;
        
        % Update the training data set since N might change in each
        % iteration and to reset the weights for the next strong
        % classifier.
        ys = mkYs(P, N);
        ws = mkWeights(P, N);
        ii_ims = [P;N];
        
        % The number of weak classifiers in this strong classifier
        T = 0;
        
        fpr = 1; % to enter the loop
        while (fpr > f * fpr_last)
            T = T + 1;
            
            % Normalize the weight vector and train a new weak classifier.
            ws = ws/sum(ws);
            [Cparams, ws] = ...
                BoostingAlg_AddFeature(Cparams, ws, ii_ims, ys);
            
            % Update the cascaded classifier to include the changed strong
            % classifier.
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
            
            % Find the highest threshold for which the TPR is at least d *
            % tpr_last and update the strong classifier to have that
            % threshold.
            thrs = linspace(0 ,max(score), 1000);
            [tprs,fprs] = TestThresholds(ysv, score, thrs);
            [CCparams{i}.thresh,idx] = max(thrs(tprs >= d * tpr_last));
            
            % Debug
            figure(1)
            scatter(1:length(ysv),score); 
            ylabel('score')
            xlabel('image nr')
            hold on;
            plot([1 length(ysv)], CCparams{i}.thresh * ones(2,1),'r')
            hold off
            % /Debug
            
            % Set the true- and false positive rates to fit the threshold
            tpr = tprs(idx);
            fpr = fprs(idx);
            
            fprintf('i = %i\t\t\t\tT = %i\n', i, T)
            fprintf('fpr = %g\t\t\tfpr_last = %g\n', fpr, fpr_last)
            fprintf('tpr = %g\t\t\t\ttpr_last = %g\n', tpr, tpr_last)
            fprintf('target_tpr = %g\tthreshold = %g\n\n', d * tpr_last, CCparams{i}.thresh)
            fprintf('length(N) = %g\n', size(N,1))
            
        end
        
        fpr_last = f * fpr_last;
        tpr_last = d * tpr_last;
        
        % Remove all but the false positives from the training set of
        % negative images
        M = size(ii_ims, 1);
        score = zeros(M,1);
        for n = 1:M
            [fg, sc] = ApplyCascade(CCparams, ii_ims(n,:));
            if fg
                score(n) = sc;
            end
        end
        pos = score >= CCparams{i}.thresh;
        N = ii_ims(ys(pos) == 0,:);
    end
end