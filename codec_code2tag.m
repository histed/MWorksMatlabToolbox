function cTag = codec_code2tag(codec, codeNum)
%CODEC_CODE2TAG (MW): given code number, convert to tag/name
%
%   cTag = codec_code2tag(codec, codeNum)
%
% histed 130701:
%


names = { codec.tagname };
cN = codec_code2idx(codec, codeNum);
cTag = names{cN};
