function fdets = PruneDetections(dets)
    
    ns = size(dets,1);
    D = zeros(ns,ns);
    
    for i = 1:ns
        xi = dets(i,1);
        yi = dets(i,2);
        for j = i:ns
            xj = dets(j,1);
            yj = dets(j,2);
            intersect = rectint([xi,yi,19,19],[xj,yj,19,19]);
            if intersect ~= 0
                D(i,j) = 1;
                D(j,i) = 1;
            end
        end
    end
    [~,C] = graphconncomp(sparse(D));
    fdets = zeros(C(end),4);
    C
    for i = 1:C(end)
        dets(find(C==i),:)
        mean(dets(find(C==i),:))
        fdets(i,:) = round(mean(dets(find(C==i),:),1));
    end
end