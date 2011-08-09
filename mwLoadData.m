function ds = mwLoadData(fName, dataN, debug)
%mwLoadData: Get data from matlab file saved by mworks
%
%  ds = mwLoadData(fName, dataN, debug)
%
% histed 110717

%% arg processing
if nargin < 2 || isempty(dataN), dataN = 'last'; end
if nargin < 3 || isempty(debug); debug = false; end

%% get from disk
ds = load(fName);

%% figure out which chunk to load
if debug
    disp(sprintf('Filename %s', fName));
end

if isfield(ds, 'backup')
    ads = {ds.backup{:}, ds.input };
else
    ads = {ds.input};
end

if strcmp(dataN, 'last') 
    ds = ads{end};  % skip backup data
elseif isnumeric(dataN)
    nTrs = cellfun(@(x) length(x.holdStartsMs), ads);
    if debug
        disp(sprintf('%d saved data chunks: nTrials %s', ...
                     length(nTrs), mat2str(nTrs)));
    end
    
    desIx = nTrs > 10;
    desN = find(desIx);
    
    ds = ads{desN(dataN)};
else
    error('invalid dataIndex: %s', mat2str(dataIndex));
end

if debug
    disp(sprintf('Selected chunk has %d trials', length(ds.holdStartsMs)));
end
