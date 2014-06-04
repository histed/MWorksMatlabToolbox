function strOut = mwListCodes(ds, trialN)
%mwListCodes: list codes and code times on trial from mworks matlab data
%file
%
%   strOut = mwListCodes(ds, trialN)
%
%   events must be found at ds.savedEvents
%
%
% histed 130701


%% params
%ds = ds0; trialN = 1;
tE = ds.savedEvents{trialN};

codeList = cat(2, tE.event_code);
codeTs = double(cat(2, tE.time_us))/1e6;
codeVals = cat(2, tE.data);

if iscell(ds.eventCodecs)
    tCodec = ds.eventCodecs{1}; % old format: they should all be the same
else
    tCodec = ds.eventCodecs;  
    assert(isstruct(tCodec));
end

nC = length(codeList);

% construct codecs


outH{1} = sprintf('%32s (%3s) %12s  %9s  %8s  %7s', ...
                  'Code', 'int', 'Value', 'Timestamp', 'Diff', 'Ts from first');
outH{2} = '-------------------------------------------------------------';
outC = {};

for iC = 1:nC
    tC = codeList(iC);
    if isnan(tC); break; end

    tTs = codeTs(iC);
    if iC == 1
        tDiffStr = '';
        firstTs = tTs;
        tFromFirstStr = '';
    else
        tDiffStr = num2str(tTs-codeTs(iC-1), '%6.3fs');
        tFromFirstStr = num2str(tTs - firstTs, '%7.3fs');
    end

    codeName = codec_code2tag(tCodec, tC);
    outC{iC} = sprintf('%32s (%3d) %12d  %9.2fs  %8s  %7s', ...
                       codeName, tC, ...
                       codeVals(iC), ...
                       tTs, tDiffStr, tFromFirstStr);
end

allOut = cat(2, outH, outC)';
if nargout == 0
    for iC=1:length(allOut)
        disp(allOut{iC});
    end
else
    strOut = allOut;
end


                       
    
