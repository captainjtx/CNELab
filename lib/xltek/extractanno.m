function [anno,header,errmsg] = extractanno(fname,options)
% options string contains the following 
% s : include string and size
% c : convert \" and \\ to " and \ in the string and remove " at the
% beginning and end
if ~exist('options','var')
    options = 's';
end
[header,fid] = xltekreadeegheader(fname,'ent');
try
    fchunkpos = ftell(fid);
    nChunks = -1;
    %%
    while true
        chunkhead = fread(fid,[1 4],'int32');
        if isempty(chunkhead)
            break;
        end
        fseek(fid,chunkhead(2)-16,'cof');
        nChunks = nChunks+1;
    end
    fseek(fid,fchunkpos,'bof');
    if any('s'==options)
        anno = repmat(orderfields(struct('Size',[],'String',[],'Text',[],'Stamp',[],'ReadOnly',[],'Deleted',[],'Origin',[],'GUID',[])),nChunks,1);
    else
        anno = repmat(orderfields(struct('Text',[],'Stamp',[],'ReadOnly',[],'Deleted',[],'Origin',[],'GUID',[])),nChunks,1);
    end
    nChunks = 1;
    while true
        chunkhead = fread(fid,[1 4],'int32');
        if isempty(chunkhead) || chunkhead(2) == 16
            break;
        end
        Size = chunkhead(2);
        String  = fread(fid,[1 Size-18],'*char');
        if any(options=='s')
            anno(nChunks).Size   = Size;
            anno(nChunks).String = String;
        end
        fseek(fid,2,'cof');
        anno(nChunks).Deleted  = ~isempty(strfind(String,'(."Deleted", 1)'));
        anno(nChunks).ReadOnly = isempty(strfind(String,'(."ReadOnly", 0)'));
        anno(nChunks).Stamp    = str2double(regexp(String,'(?<=\(\."Stamp", )[^\)]*(?=\))','match'));
        text     = regexp(String,'(?<=\(\."Text", )"[^"\\]*(\\.[^"\\]*)*"(?=\))','match');
        anno(nChunks).Text     = text{1};
        text     = regexp(String,'(?<=\(\."Origin", )"[^"\\]*(\\.[^"\\]*)*"(?=\))','match');
        if isempty(text)
            anno(nChunks).Origin = '""';
        else
            anno(nChunks).Origin  = text{1};
        end
        text     = regexp(String,'(?<=\(\."GUID", )"[^"\\]*(\\.[^"\\]*)*"(?=\))','match');
        anno(nChunks).GUID = text{1};
        if any(options == 'c')
            anno(nChunks).Text = anno(nChunks).Text(2:end-1);
            anno(nChunks).Text = strrep(strrep(anno(nChunks).Text,'\"','"'),'\\','\');
        end
        nChunks = nChunks+1;
    end
catch errmsg
    fclose(fid);
    rethrow(errmsg);
end
fclose(fid);