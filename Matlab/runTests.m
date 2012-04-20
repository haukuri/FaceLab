function runTests()
    function [ret msgs] = testTimes(fcnstr, n)
        ret = zeros(n,1);
        msgs = '';
        for c = 1:n
            [ret(c) msg] = eval(fcnstr);
            if ~ret(c)
                msgs = [msgs, msg];
            end
        end
        ret = all(ret);
    end
    tests = {...
        {'P2:  ComputeBoxSum', 'testComputeBoxSum', 1},...
        {'P9:  VecBoxSum    ', 'testVecBoxSum', 10},...
        {'P10: VecFeature   ', 'testVecFeature', 1}};
    N = length(tests);
    r = zeros(N,1);
    fprintf('---------- Tests -----------\n');
    for k = 1:N
        test = tests{k};
        testfcn = test{2};
        n = test{3};
        [r(k) msgs] = testTimes(testfcn, n);
        %r(k) = eval(testfcn);
        if r(k) == 1
            result = 'PASS';
        else
            result = 'FAIL';
        end
        fprintf('%s\t\t%s\n', test{1}, result);
        if ~r(k)
            disp('Debug info')
            disp(msgs)
        end
    end
    fprintf('----------------------------\n');
    fprintf('%i of %i passed\n', sum(r), N);
end