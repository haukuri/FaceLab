function out = curveGuy(sc,y)
    y = logical(y);
    lotF = sum(y);
    lotNF = sum(~y);
    threshold = 0:0.25:10;
    L = length(threshold);
    out = zeros(L,3);
    for i = 1:L
        thr = threshold(i);
        TPR = sum(sc(y)>=thr)/lotF;
        FPR = sum(sc(~y)>=thr)/lotNF;
        out(i,:)=[FPR,TPR,thr];
    end 
end