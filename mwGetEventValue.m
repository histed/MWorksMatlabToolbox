function val = mwGetEventValue(events, codec, tag, occurrence, ignoreMissingStr)
%mwGetEventValue: given tag, return event value
%
%  val = mwGetEventValue(events, codec, tag, occurrence, ignoreMissingStr)
%       occurrence: can be a number or 'all' in which case val is a
%       vector of values, or 'last'
%
%  MH 100115: created
%$Id$

if nargin < 4 || isempty(occurrence), occurrence = 1; end
if nargin < 5, ignoreMissingStr = []; end

if strcmp(lower(ignoreMissingStr), lower('ignoreMissing')) 
  doIgnoreMissing = true;
else
  doIgnoreMissing = false;
end

codes = [events.event_code];
tCode = codec_tag2code(codec, tag);
eventNs = find(codes == tCode);
if length(eventNs) < 1
  if ~doIgnoreMissing
    disp(sprintf('Code not found (in getvalue): %s', tag));
  end
  val = [];
  return
elseif ischar(occurrence) 
  if strcmpi(occurrence, 'all')
    val = cat(2,events(eventNs).data);
    return
  elseif strcmpi(occurrence, 'last')
    val = events(eventNs(end)).data;
    return
  else
    error(sprintf('Unknown value for occurrence: %s', occurrence));
  end    
else
  val = events(eventNs(occurrence)).data;
  return
end
