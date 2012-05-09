function [r msg] = debugPoint8()
    [Fdata,NFdata,~] = loadData();
    load Cparams;
    [~,~,curve] = ComputeROC(Cparams, Fdata, NFdata);
    r = curve(curve(:,3) == 6.5,2) > 0.7;
    msg = '...';
end