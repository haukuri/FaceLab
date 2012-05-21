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
    lenF = size(Fdata.ii_ims,1);
    lenNF = size(NFdata.ii_ims,1);
    vFdata = SliceDataStruct(Fdata, pF + 1, lenF);
    vNFdata = SliceDataStruct(NFdata, pNF + 1, lenNF);
    
    
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
        
        fprintf('\ni = %i\ttarget_tpr = %g\ttarget_fpr = %g\n', i, d^i, f * fpr_last)
        fprintf('# of N = %g\t\t# of Nv = %g\n', size(N,1), size(Nv,1))
        while (fpr > max(f * fpr_last, fpr_target))
            T = T + 1;
            
            % Train a new weak classifier.
            [Cparams, ws] = ...
                BoostingAlg_AddFeature(Cparams, ws, ii_ims, ys);
            
            % Update the cascaded classifier to include the changed strong
            % classifier.
            CCparams{i} = Cparams;  %#ok<*AGROW>
            
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
            
            
            % Choose the threshold
            target_tpr = d^i;
            [thresh, tprs, fprs] = ChooseThreshold(Cparams, ii_imsv, ysv, target_tpr);
            CCparams{i}.thresh = thresh;
            
            % Calculate the fpr and tpr for the cascade
            fpr = fprs * fpr_last;
            tpr = tprs * tpr_last;
            %tpr = tprs * tpr_last;
            
            % Debug
            figure(1)
            subplot(1,2,1)
            npos = length(ysv(ysv == 1));
            plot(1:npos, score(1:npos), 'b+')
            hold on;
            plot(npos+1:length(ysv), score(npos+1:end), 'r.'); 
            ylabel('score')
            xlabel('image nr')
            title('Scores')
            plot([1 length(ysv)], CCparams{i}.thresh * ones(2,1),'g')
            hold off
            
            %[~,~,curve] = CascadeComputeROC(CCparams, vFdata, vNFdata);
            curve = curveGuy(score, ysv);
            subplot(1,2,2);
            plot(curve(:,1),curve(:,2), 'bo-')
            hold on
            plot(fprs, tprs, 'rx')
            hold off
            axis([-0.05 1.01 -0.05 1.01])
            xlabel('FPR')
            ylabel('TPR')
            title(sprintf('ROC curve for strong classifier %I', i))
            drawnow;
            % /Debug
            
            fprintf('T = %i\tfpr = %g\ttpr = %g\tthreshold = %g\n', T, fpr, tpr, CCparams{i}.thresh)
            
            
        end
        fpr_last = fpr;
        
        % Remove all but the false positives from the training set of
        % negative images
        N = PruneNegatives(ii_ims, ys, CCparams, i);
        ys = mkYs(P, N);
        ws = mkWeights(P, N);        
        ii_ims = [P;N];
        
        % Do the same for the negatives in the validation set
%         Nv = PruneNegatives(ii_imsv, ysv, CCparams, i);
%         ii_imsv = [Pv;Nv];
%         ysv = mkYs(Pv, Nv);
    end
end