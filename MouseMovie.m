[] = function MouseMovie(fn)

outputdir = pwd;
flims = [1 6000];

[mixedsig, mixedfilters, CovEvals, covtrace, movm, movtm] = CellsortPCA(fn, flims, nPCs, dsamp, outputdir, badframes)


