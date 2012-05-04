function debug = loadDebug(dirname)
    if nargin == 0
        dirname = '../DebugInfo/';
    end
    things = what(dirname);
    mats = things.mat;
    K = length(mats);
    debug = cell(K,1);
    for k = 1:K
        matpath = PathCat(dirname, mats{k});
        debug{k} = load(matpath);
    end
end