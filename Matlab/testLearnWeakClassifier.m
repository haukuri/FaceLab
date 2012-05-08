function [r msg] = testLearnWeakClassifier()
    [Fdata,NFdata,FTdata] = loadData();
    ftype_vec = FTdata.fmat(:,12028);
    fs1 = VecComputeFeature(Fdata.ii_ims, ftype_vec);
    fs2 = VecComputeFeature(NFdata.ii_ims, ftype_vec);
    fs = [fs1;fs2];
    Nf = size(Fdata.ii_ims,1);
    Nnf = size(NFdata.ii_ims,1);
    Nt = Nf + Nnf;
    ws = ones(Nt,1)/Nt;
    ys = [ones(Nf,1); zeros(Nnf,1)];
    [theta,p,err] = LearnWeakClassifier(ws, fs, ys);
    if (abs(theta -(-3.6453)) < 1e-4 && p == 1)
        r = 1;
        msg = '';
    else
        r = 0;
        msg = sprintf('theta = %g\tp = %i', theta, p);
    end
end