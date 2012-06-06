function ds = mwLoadData(fName, dataIndex, debug, trialThresholdPerChunk)
%mwLoadData: Get data from matlab file saved by mworks
%
%  ds = mwLoadData(fName, dataN, debug, trialThresholdPerChunk)
%
%  set trialThresholdPerChunk to zero to choose blocks directly
%
% histed 110717

%% arg processing
if nargin < 2 || isempty(dataIndex) || all(isnan(dataIndex)), dataIndex = 'last'; end
if nargin < 3 || isempty(debug); debug = false; end
if nargin < 4 || isempty(trialThresholdPerChunk)
    trialThresholdPerChunk = 25; % prob can go as high as 50
end


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

if strcmp(dataIndex, 'last') 
    ds = ads{end};  % skip backup data
else
    nTrs = cellfun(@(x) length(x.holdStartsMs), ads);
    
    if debug
        disp(sprintf('%d saved data chunks: nTrials %s', ...
                     length(nTrs), mat2str(nTrs)));
    end
    
    if isnumeric(dataIndex)
        desIx = nTrs > trialThresholdPerChunk;
        desN = find(desIx);
    
        ds = ads{desN(dataIndex)};
    elseif ischar(dataIndex) && strcmpi(dataIndex, 'max')
        [maxVal maxN] = max(nTrs);
        ds = ads{maxN};
        if debug
            disp(sprintf('Using max trials: chunk %d, trials %d', maxN, maxVal));
        end
    else
        error('invalid dataIndex: %s', mat2str(dataIndex));
    end
end

if debug
    disp(sprintf('Selected chunk has %d trials', length(ds.holdStartsMs)));
end
