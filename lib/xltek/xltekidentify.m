function xltekidentify(varargin)
%% Default commands
cmds = {
    'FirstName','Ilana';
    'MiddleName','';
    'LastName','Kolos';
    'Source','E:\Test_Data\deidientifysample\Xxxxx~ Xxxxx_ff2fa87e-cd9c-474e-b8fd-5ab148b500bb';
    'Destination','E:\Test_Data\deidientifysample\Test';
    'DeIdentify',false
    'PatientId',1
    'DateFormat','yymmdd'
    'MoveUnchanged',true};

cmds = defargs(cmds,varargin);
if ~exist(cmds.Source,'dir')
    error('Source directory does not exist');
end
if ~exist(cmds.Destination,'dir')
    mkdir(cmds.Destination);
    if ~exist(cmds.Destination,'dir')
        error('Can not craete output directory');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Process each file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% eeg: Main eeg file, header and data
% The name of the source file
nsrc = dir(fullfile(cmds.Source, '*.eeg'));
if isempty(nsrc)
    error('Source directory does not contain eeg file');
end
[~,nsrc,~] = fileparts(nsrc.name);
fsrc = fullfile(cmds.Source,nsrc);
[data,head] = xltekreadeegfile(fsrc,1,1);
% Determine the real name from remote name
[~,ndst,~] = fileparts(data.Study{1}.FileNameRemote);
fdst = fullfile(cmds.Destination,[ndst,'.eeg']);
% Length of the name part
% In the form of "LastN~ First" which is composed of first and last name of the subject 
namepart = [find(ndst=='_',1) find(nsrc=='_',1)]-1;
nLastName = min(11,length(cmds.LastName));
if ~strcmpi(ndst(1:namepart(1)),[cmds.LastName(1:nLastName)  '~ ' cmds.FirstName(1:min(end,12-nLastName))])
    warning(['matlab:' mfilename],'The name part of the file "%s" does not comply with the name "%s %s"',ndst,cmds.FirstName,cmds.LastName);
end
% Identify the data
data.Info.Name.FirstName  = ['"' cmds.FirstName '"'];
data.Info.Name.LastName   = ['"' cmds.LastName '"'];
data.Info.Name.MiddleName = ['"' cmds.MiddleName '"'];
data.Study{1}.FileName = ['"' ndst '.eeg"'];
if ~isempty(head.FirstName)
    % Identify the header if necessary
    head.FirstName = cmds.FirstName;
    head.LastName = cmds.LastName;
    head.MiddleName = cmds.MiddleName;
end
if strcmpi(cmds.Destination,cmds.Source)
    movefile(fsrc,fdst,'f');   
end
% Write header
fid = xltekwriteeegheader(fdst,'eeg',head);
% Write data
str    = struct2keystr(data);
strLen = length(str)+1;
if (strLen >= hex2dec('FFFFFFFF'))
    error(['matlab:' mfilename],'Does Not support big strings');
end
if( strLen >= hex2dec('FF'))
    fwrite(fid,hex2dec('FF'),'uint8');
    if (strLen >= hex2dec('FFFE'))
        fwrite(fid,hex2dec('FFFF'),'uint16');
        fwrite(fid,strLen,'uint32');
    else
        fwrite(fid,strLen,'uint16');
    end
else
    fwrite(fid,strLen,'uint8');
end
fwrite(fid,[str 0],'char');
fclose(fid);




%% stc (data,header) and erd (header only) files
fsrc = fullfile(cmds.Source,[nsrc '.stc']);
fdst = fullfile(cmds.Destination,[ndst '.stc']);
% Copy source to destination
copyfile(fsrc,fdst,'f');
% Update header of the stc file
[data,head] = xltekreadstcfile(fsrc);
% Identify the header if necessary
head.FirstName = cmds.FirstName;
head.LastName = cmds.LastName;
head.MiddleName = cmds.MiddleName;
fid  = xltekwriteeegheader(fdst,'stc',head);
fpos = ftell(fid)+56; % Skip stc header
fseek(fid,fpos,'bof');
for k=1:numel(data)
    % Update file names in stc file
    nesrc = data(k).segmentname;
    nedst = [ndst(1:namepart) nesrc(namepart+1:end)];
    fpos = ftell(fid)+272;
    fwrite(fid,[nedst(1:min(end,255)) 0],'char');
    fseek(fid,fpos,'bof');
    % Update erd files
    fesrc = fullfile(cmds.Source,[nesrc '.erd']);
    fedst = fullfile(cmds.Destination,[nedst '.erd']);
    copyfile(fesrc,fedst,'f');
    ehead = xltekreadeegheader(fedst);
    ehead.FirstName  = cmds.FirstName;
    ehead.LastName   = cmds.LastName;
    ehead.MiddleName = cmds.MiddleName;
    feid = xltekwriteeegheader(fedst,'erd',ehead);
    fclose(feid);
    % etc files
    fesrc = fullfile(cmds.Source,[nesrc '.etc']);
    fedst = fullfile(cmds.Destination,[nedst '.etc']);
    copyfile(fesrc,fedst,'f');
    ehead = xltekreadeegheader(fedst);
    ehead.FirstName  = cmds.FirstName;
    ehead.LastName   = cmds.LastName;
    ehead.MiddleName = cmds.MiddleName;
    feid = xltekwriteeegheader(fedst,'etc',ehead);
    fclose(feid);
end
fclose(fid);


%%
% ent: Annotation file, header only
% ent.old: Annotation file, header only
for ext = {'.ent.old','.ent','.snc'}
    fsrc = fullfile(cmds.Source,[nsrc ext{1}]);
    fdst = fullfile(cmds.Destination,[ndst ext{1}]);
    % Copy source to destination
    copyfile(fsrc,fdst,'f');
    % Update header of the stc file
    head = xltekreadeegheader(fsrc,ext{1});
    % Identify the header if necessary
    head.FirstName = cmds.FirstName;
    head.LastName = cmds.LastName;
    head.MiddleName = cmds.MiddleName;
    fid  = xltekwriteeegheader(fdst,ext{1},head);
    fclose(fid);
end

%% epo: Epoch file, no change
fsrc = fullfile(cmds.Source,[nsrc '.epo']);
fdst = fullfile(cmds.Destination,[ndst '.epo']);
% Copy source to destination
copyfile(fsrc,fdst,'f');

%% vtc: Video filename list, data only
fsrc = fullfile(cmds.Source,[nsrc '.vtc']);
fdst = fullfile(cmds.Destination,[ndst '.vtc']);
% Copy source to destination
copyfile(fsrc,fdst,'f');
% Update header of the stc file
[data,head] = xltekreadvtcfile(fsrc);
% Identify the header if necessary
head.FirstName = cmds.FirstName;
head.LastName = cmds.LastName;
head.MiddleName = cmds.MiddleName;
fid  = xltekwriteeegheader(fdst,'vtc',head);
for k=1:numel(data)
    % Update file names in stc file
    nesrc = data(k).FileName;
    nedst = [ndst(1:namepart) nesrc(namepart+1:end)];
    fpos = ftell(fid)+293;
    fwrite(fid,[nedst(1:min(end,256)) 0],'char');
    fseek(fid,fpos,'bof');
    % Update avi files
    fesrc = fullfile(cmds.Source,nesrc);
    fedst = fullfile(cmds.Destination,nedst);
    copyfile(fesrc,fedst,'f');
end
fclose(fid);




