function [r msg] = debugPoint7()
    epsilon = 1e-10;
    debug = loadDebug();
    T = debug{7}.T;
    [Fdata,NFdata,FTdata] = loadData();
    Cparams = BoostingAlg(Fdata, NFdata, FTdata, T);
    r = sum(abs(debug{7}.alphas - Cparams.alphas) > epsilon) + ...
        sum(abs(debug{7}.Thetas(:) - Cparams.Thetas(:)) > epsilon) == 0;
    msg = '...';
end