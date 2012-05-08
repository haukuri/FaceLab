function [r msg] = debugPoint6()
    epsilon = 1e-10;
    debug = loadDebug();
    T = debug{6}.T;
    [Fdata,NFdata,FTdata] = loadData();
    Cparams = BoostingAlg(Fdata, NFdata, FTdata, T);
    r = sum(abs(debug{6}.alphas - Cparams.alphas) > epsilon) + ...
        sum(abs(debug{6}.Thetas(:) - Cparams.Thetas(:)) > epsilon) == 0;
    msg = '...';
end