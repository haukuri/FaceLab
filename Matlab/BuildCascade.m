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
    
    % Initialize the training set
    ws = mkWeights(P, N);
    ys = mkYs(P, N);
    ii_ims = [P;N];
    
    while fpr > fpr_target
        i = i + 1;
        
        % Create a new strong classifier
        Cparams = tCparams;
        
        % The number of weak classifiers in this strong classifier
        T = 0;
        
        fprintf('\ni = %i\ttarget_tpr = %g\ttarget_fpr = %g\n', i, d * tpr_last, f * fpr_last)
        fprintf('T = %i\t# of N = %g\t\t#of Nv = %g\n', T, size(N,1), size(Nv,1))
        while (fpr > f * fpr_last)
            T = T + 1;
            
            % Train a new weak classifier.
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
            %thrs = linspace(0 ,max(score), 1000);
            %[tprs,fprs] = TestThresholds(ysv, score, thrs);
            %[CCparams{i}.thresh,idx] = max(thrs(tprs >= d * tpr_last));
            
            % Set the true- and false positive rates to fit the threshold
            %tpr = tprs(idx);
            %fpr = fprs(idx);
            
            % Choose the threshold
            [thresh, tprs, fprs] = ChooseThreshold(Cparams, ii_imsv, ysv, d * tpr_last);
            CCparams{i}.thresh = thresh;
            
            % Calculate the fpr and tpr for the cascade
            fpr = fprs * fpr_last;
            tpr = tprs * tpr_last;
            
            % Debug
            figure(1)
            npos = length(ysv(ysv == 1));
            plot(1:npos, score(1:npos), 'b+')
            hold on;
            plot(npos+1:length(ysv), score(npos+1:end), 'r.'); 
            ylabel('score')
            xlabel('image nr')
            plot([1 length(ysv)], CCparams{i}.thresh * ones(2,1),'g')
            hold off
            % /Debug
            
            fprintf('fpr = %g\ttpr = %g\tthreshold = %g\n', fpr, tpr, CCparams{i}.thresh)
            
            
        end
        
        fpr_last = fpr;
        tpr_last = tpr;
        
        % Remove all but the false positives from the training set of
        % negative images
        N = PruneNegatives(ii_ims, ys, CCparams, i);
        ys = mkYs(P, N);
        ws = mkWeights(P, N);        
        ii_ims = [P;N];
        
        % Do the same for the negatives
        Nv = PruneNegatives(ii_imsv, ysv, CCparams, i);
        ii_imsv = [Pv;Nv];
        ysv = mkYs(Pv, Nv);
        
%         
%         M = size(ii_ims, 1);
%         score = zeros(M,1);
%         for n = 1:M
%             [fg, sc] = ApplyCascade(CCparams, ii_ims(n,:));
%             if fg
%                 score(n) = sc;
%             end
%         end
%         pos = score >= CCparams{i}.thresh;
%          %pws = ws(ys == 1);
%          %nws = ws(ys(pos) == 0);
%          %ws = [pws;nws];
%         N = ii_ims(ys(pos) == 0,:);
    end
end