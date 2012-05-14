function y = SliceDataStruct(x, start, stop)
    y = struct();
    range = start:stop;
    y.dirname = x.dirname;
    y.ii_ims = x.ii_ims(range,:);
    y.fnums = x.fnums(1,range);
end