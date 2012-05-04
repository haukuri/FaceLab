function p = PathCat(p1, p2)
    isslash = @(c) (c == '/' || c == '\');
    if ~isslash(p1(end));
        p1 = [p1 filesep];
    end
    if isslash(p2(1))
        p2 = p2(2:end);
    end
    p = [p1 p2];
end