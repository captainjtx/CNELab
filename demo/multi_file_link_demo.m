%A demo of linking raw matlab files
%input files, change it to your filenames
f=dir;
names={f.name};
input_files={};

for i=1:length(names)
    if regexp(names{i},'SL_LeftSTN_SUA.*.mat')
        input_files=cat(1,input_files,names(i));
    end
end
% input_files={'rest_04_10_2016_11_53_12_0000.mat',...
%              'rest_04_10_2016_11_53_12_0001.mat',...
%              'rest_04_10_2016_11_53_12_0002.mat',...
%              'rest_04_10_2016_11_53_12_0003.mat',...
%              'rest_04_10_2016_11_53_12_0004.mat',...
%              'rest_04_10_2016_11_53_12_0005.mat',...
%              'rest_04_10_2016_11_53_12_0006.mat',...
%              'rest_04_10_2016_11_53_12_0007.mat',...
%              'rest_04_10_2016_11_53_12_0008.mat',...
%              'rest_04_10_2016_11_53_12_0009.mat',...
%              'rest_04_10_2016_11_53_12_0010.mat',...
%              'rest_04_10_2016_11_53_12_0011.mat',...
%              'rest_04_10_2016_11_53_12_0012.mat',...
%              'rest_04_10_2016_11_53_12_0000.mat',...
%              'rest_04_10_2016_11_53_12_0000.mat',...
%              };
         
%sampling rate, very important
%%
fs=2400;

%output filename
out_filename='behv';

video_filename='';

%selected channels (optional)
chan=148:156;
         
CommonDataStructure.create_new_data_from_mat(input_files,out_filename,fs,chan,video_filename);