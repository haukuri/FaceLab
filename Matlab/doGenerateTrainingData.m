function doGenerateTrainingData(np,nn);
    debug = loadDebug();
    if nargin == 0
        np = debug{5}.np;
        nn = debug{5}.nn;
    end
    all_ftypes = debug{5}.all_ftypes;
    jseed = debug{5}.jseed;
    stream = RandStream('mt19937ar', 'seed', jseed);
    RandStream.setDefaultStream(stream);
    GetTrainingData(all_ftypes, np, nn);
end