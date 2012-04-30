function [theta,p,err] = LearnWeakClassifier(ws, fs, ys)
    % Inputs
    %   ws [n x 1] weights
    %   fs [n x 1] feature vector
    %   ys [n x 1] labels
    %   - n is the number of samples
    % Outputs
    %   theta [1 x 1] threshold
    %   p [1 x 1] parity
    %   err [1 x 1] classification error;
    mup = sum(ws .* fs .* ys) / sum(ws .* ys);
    mun = sum(ws .* fs .* (1 - ys)) / sum(ws .* (1 - ys));
    theta = 0.5 * (mup * mun);
    h = @(fs,p,theta) p * fs < p * theta;
    eneg = sum(ws .* abs(ys - h(fs,-1,theta)));
    epos = sum(ws .* abs(ys - h(fs,1,theta)));
    es = [eneg,epos];
    ps = [-1,1];
    [~,i] = min(es);
    p = ps(i);
    err = es(i);
end