function f(infile, outfile)
% remove savedEvent stream from a matlab mworks data file - mainly to save
% space for e.g. data used for tests
%
%  Todo: This only saves about 25% of file size; we should look into what
%    is taking up most space.  
%
% 180130 MH

dsOrig = load(infile);
ds = dsOrig;
ds.input.savedEvents = [];
error('Need to deal with backup fields')  % ds.backup, etc.
save(outfile, 'ds')