function ds = mwLoadData(fName, dataN, debug)
% Get data from matlab file saved by mworks
%
% histed 110717

%% arg processing
if nargin < 2 || isempty(dataN), dataN = 'last'; end
if nargin < 3 || isempty(debug); debug = false; end

%% get from disk
ds = load(fName);

%% figure out which chunk to load
if strcmp(dataN, 'last')
    ds = ds.input;  % skip backup data
elseif isnumeric(dataN)
    nTrs = cellfun(@(x) length(x.holdStartsMs), ds.backup);
    if debug
        disp('All saved data chunks: nTrials');
        disp(nTrs)
    end
    desIx = nTrs >= 3;
    nTrs = find(desIx);
    
    if dataN == length(nTrs)+1
        % the last data is stored in this field
        ds = ds.input;
    else
        desN = nTrs(dataN);
        ds = ds.backup{desN};
    end
    
    if debug
        disp(sprintf('Selected chunk has %d trials', length(ds.holdStartsMs)));
    end
else
    error('invalid dataIndex: %s', mat2str(dataIndex));
end
