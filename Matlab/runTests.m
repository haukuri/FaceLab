function runTests()
    tests = {...
        {'P2: ComputeBoxSum', 'testComputeBoxSum'},...
        {'P9: VecBoxSum    ', 'testVecBoxSum'}};
    N = length(tests);
    r = zeros(N,1);
    fprintf('---------- Tests -----------\n');
    for k = 1:N
        test = tests{k};
        testfcn = test{2};
        r(k) = eval(testfcn);
        if r(k) == 1
            result = 'PASS';
        else
            result = 'FAIL';
        end
        fprintf('%s\t\t%s\n', test{1}, result);
    end
    fprintf('----------------------------\n');
    fprintf('%i of %i passed\n', sum(r), N);
end