function [tdata, vdata] = SplitData(data,p)
    i = floor(p*size(data.ii_ims,1));
    
    tdata = struct();
    tdata.dirname = data.dirname;
    tdata.ii_ims = data.ii_ims(1:i,:);
    tdata.fnums = data.fnums(:,1:i);
    
    vdata = struct();
    vdata.dirname = data.dirname;
    vdata.ii_ims = data.ii_ims(i+1:end,:);
    vdata.fnums = data.fnums(:,i+1:end);
end