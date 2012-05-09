function [r msg] = debugPoint9()
    load Cparams;
    min_s = 0.6;
    max_s = 1.3;
    step_s = 0.06;
    im = imread('../TestImages/big_one_chris.png');
    dets = ScanImageOverScale(Cparams, im, min_s, max_s, step_s);
    figure();
    spacing = 0.07;
    subaxis(1,2,1, 'Spacing', spacing);
    DisplayDetections(im, dets);
    subaxis(1,2,2, 'Spacing', spacing);
    fdets = PruneDetections(dets);
    DisplayDetections(im, fdets);
    drawnow;
    msg = input('Does it look right [yes|*]? ', 's');
    r = strcmpi(msg, 'yes');
end