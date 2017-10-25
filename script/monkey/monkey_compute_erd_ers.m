clear
clc
load('H564_Session_111505_Concat_LFP_Data.mat');
load('H564_Session_111505_Info_Triggers.mat');
%%
fs = 1000;
wd = 256;
ov = 236;
%%
%1: B, 2: Cue, 3: Go, 4: Move, 5: Target, 6: End
TrBase=cTrig(2,:); % 2:Cue, Baseline
base_alfp=getaligneddata(lfp,TrBase,[-512 0]);
TrNum = size(base_alfp, 3);
ChanNum = size(base_alfp, 2);
psdbase = [];
for c = 1:ChanNum
    [tf,f,t]=tfpower(squeeze(base_alfp(:,c,:)),[],fs,wd,ov,[]);
    psdbase = cat(2, psdbase, mean(tf,2));
end
%%
tfmat = cell(8,1);
Tr = cTrig(2, :); % 2, Cue, 3:Go
for i = 1:8
    dir = (i-1)*45;
    alfp=getaligneddata(lfp,Tr(direc==dir),[-512 1024]);
    tfmat{i} = [];
    for c = 1:ChanNum
        [tf,f,t]=tfpower(squeeze(alfp(:,c,:)),[],fs,wd,ov,[]);
        tfmat{i} = cat(3, tfmat{i}, tf);
    end
end
%%
% freq = [8, 32];
freq = [60, 200];

mat = [];
mat.data = [];
mat.ts = t;

for i = 1:8
    mat.data(i).direc = (i-1)*45;
    mat.data(i).ep = [];
    for c = 1:ChanNum
        tf = tfmat{i}(:,:,c); %tf for direction i, channel c
        fi = f>=freq(1)&f<=freq(2);
        pow_ratio = 10*log10(mean(tf(fi, :), 1) ./ mean(psdbase(fi, c), 1));
        mat.data(i).ep = cat(2, mat.data(i).ep, pow_ratio(:));
    end
end
%% Compute the ERD/ERS level for a given frequency band for CUE and GO alignment
% Save the values for each channel to be used in the directional_map Script
