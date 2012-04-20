function runTests()
    tests = {...
        {'P2: ComputeBoxSum', 'testComputeBoxSum'}};
    for k = 1:length(tests)
        test = tests{1};
        r = eval(test{2});
        if r == 1
            result = 'PASS';
        else
            result = 'FAIL';
        end
        fprintf('%s\t%s\n', test{1}, result);
    end
end