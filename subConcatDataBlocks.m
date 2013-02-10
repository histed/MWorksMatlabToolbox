function outS = subConcatDataBlocks(blockC)
% concatenate data blocks from a file into one
% not well-debugged but works for some files for now
% histed 130117: broke out of getBehavDataForDay

outS = struct([]);

% kind of a mess below, but it works for now
fNames = fieldnames(blockC{1});
nF = length(fNames);
for iF = 1:nF
    tDs1 = blockC{1};
    tFName = fNames{iF};
    tFV1 = tDs1.(tFName);
    
    lenList = cellfun(@(x) length(x.(tFName)), blockC);
    
    newC = cellfun(@(x) x.(tFName), blockC, 'UniformOutput', false);

    if isnumeric(tFV1) || islogical(tFV1)
        newV = cat(2, newC{:});
                
        % reduce to one element if all the same
        if all(lenList) == 1
            if all(newV == newV(1))
                newV = newV(1);
            end
        end
        
        outS(1).(tFName) = newV;
    elseif ischar(tFV1)
        if all(strcmp(newC, newC{1}));
            newC = newC{1};
        end
        outS(1).(tFName) = newC;
    elseif iscell(tFV1)
        % check same
        if all(cellfun(@(x) isequalwithequalnans(x.(tFName), tFV1), blockC))
            newC = newC{1};
        elseif isvector(tFV1)
            newC = cat(2, newC{:});
        % else use newC as is
        end
        outS(1).(tFName) = newC;
    elseif isstruct(tFV1)
        switch tFName
          case 'firstTrConsts'
            outS(1).(tFName) = blockC{1}.(tFName);
          case 'background'
            % skip this field: I think it's a bug
          case 'announceStimulusTimes'
            f2Names = fieldnames(blockC{1}.announceStimulusTimes);
            for iF=1:length(f2Names);
                tF2Name = f2Names{iF};
                for iC=1:length(blockC);
                    tC{iC} = blockC{iC}.announceStimulusTimes.(tF2Name);
                end
                outS(1).announceStimulusTimes.(tF2Name) = cat(2,tC{:});
            end
          otherwise
            error('unknown field %s', tFName);
        end
    else
        error('missing field');
    end
end

