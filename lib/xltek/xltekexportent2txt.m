function  errmsg = xltekexportent2txt(fname,outdir,eegpath)
% ERRMSG = XLTEKEXPORTENT2TXT(FNAME,OUTDIR,EEGPATH)
% FNAME     : Ent file name or path
% OUTDIR    : Output directory of the text file. (optional)
% SNCNAME   : EEG or SNC file name directory.
% See also XLTEKREADDATA XLTEKREADENTFILE
%%
try
    [~,fr,fname]  = xltekreadeegheader(fname,'ent');
    if exist('eegpath','var')
        fname = eegpath;
    end
    [fparts{1:3}] = fileparts(fname);
    % When the annotation file name is different than the eeg file name
    eegname = dir(fullfile(fparts{1},'*.eeg'));
    if isempty(eegname)
        fparts{1} = fullfile(fparts{1},fparts{2});
        eegname = dir(fullfile(fparts{1},'*.eeg'));
        if isempty(eegname)
            error('EEG file required in "%s" directory',fparts{1});
        end
    end
    [~,eegname] = fileparts(eegname.name);
    eegname = fullfile(fparts{1},eegname);
    eeg = xltekreadeegfile(eegname);
    snc = xltekreadsncfile(eegname);
    txtname = [fparts{2} '.txt'];
    if exist('outdir','var') 
        if exist(outdir,'file')  == 7 % Directory
            [fw,errmsg] = fopen(fullfile(outdir,txtname),'wt');
        else % File
            [fw,errmsg] = fopen(outdir,'wt');
        end
    else
        [fw,errmsg] = fopen(fullfile(fparts{1},txtname),'wt');
    end
    if ~isempty(errmsg), fclose(fr); return;end
    %%
    fprintf(fw,'Patient Name:\t%s, %s\n',eeg.Info.Name.LastName,eeg.Info.Name.FirstName);
    fprintf(fw,'Study Name:\t%s\n',eeg.Study.StudyName);
    fprintf(fw,'File Path:\t%s\n',upper(fparts{1}));
    fprintf(fw,'Creation Date:\t%s\n\n',datestr(converttime(eeg.Study.CreationTime,'o','m'),'HH:MM:SS mmm DD, YYYY'));
    %%
    while ~feof(fr)
        chead = fread(fr,[1 4],'int32');
        if isempty(chead)
            fclose(fr);
            fclose(fw);
            return;
        end
        if chead(2) == 16 % We reach end of file 
            break;
        else
            pnote = fread(fr,[1 chead(2)-18],'*char');
            fseek(fr,2,'cof'); % Skip last 2 bytes, they are zerof
        end
        pdel  = regexp(pnote,'\(\."Deleted", (?<Deleted>[^\)]*)\)','names');
        if ~isempty(pdel) && strcmp(pdel.Deleted,'1')
            continue;
        end
        panno = regexp(pnote,'\(\."Stamp", (?<Stamp>[^\)]*)\).*\(\."Text", "(?<Text>[^"\\]*(\\.[^"\\]*)*)"\)','names');
        fprintf(fw,'%s\t',stamp2time(str2double(panno.Stamp),snc,eeg,'HH:MM:SS'));
        if chead(3) == 0
            fprintf(fw,'%s\n','Beginning of Recording');
            fprintf(fw,'%s\t',stamp2time(str2double(panno.Stamp),snc,eeg,'HH:MM:SS'));
        end
        panno.Text = regexprep(panno.Text,'\\(.)','$1');
        if strcmpi(panno.Text,'Gain/Filter Change') || strncmpi(panno.Text,'Montage:',8)
            chead = fread(fr,[1 4],'int32');
            fseek(fr,chead(2)-16,'cof');
        end
        fprintf(fw,'%s\n',strrep(panno.Text,['xd' 10],' '));
    end
    fclose(fr);
    fclose(fw);
    if nargout == 0 
        clear errmsg;
    end
catch errmsg
    if exist('fr','var') && ~isempty(fopen(fr))
        fclose(fr);
    end
    if exist('fw','var') && ~isempty(fopen(fw))
        fclose(fw);
    end
    rethrow(errmsg);
end