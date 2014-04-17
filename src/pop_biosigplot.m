% pop_biosigplot() - Visualise multichannel signals and enable to easily
% switch to ICA as if it was a Montage
%
% USAGE
%   >> pop_biosigplot( EEG ) 
%
% See also: eeglab(), BioSigPlot()


%123456789012345678901234567890123456789012345678901234567890123456789012
%
%     BioSigPlot Copyright (C) 2013 Samuel Boudet, Faculté Libre de Médecine,
%     samuel.boudet@gmail.com
%
%     This file is part of BioSigPlot
%
%     BioSigPlot is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     BioSigPlot is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% V0.1.2 Beta - 13/02/2013 


function [com] = pop_biosigplot( EEG)

com = '';
if nargin < 1
	help pop_biosigplot;
	return;
end;	

a=eye(size(EEG.data,1));
if ~isempty(EEG.chanlocs)
    chans={EEG(1).chanlocs(:).labels};
else
    for i=1:size(EEG.data,1)
        chans{i}=num2str(i); %#ok<AGROW>
    end
end
Montage=struct('name','Raw','mat',a);
Montage.channames=chans;

if ~isempty( EEG.icasphere )
    ica=EEG.icaweights*EEG.icasphere*a(EEG.icachansind,:);
    Montage(2).name='ICA';
    Montage(2).mat=ica;
    for i=1:size(ica,1)
        Montage(2).channames{i}=num2str(i); 
    end
end
title=['BioSigPlot - ' EEG.setname];
evts=[num2cell([EEG.event(:).latency]/EEG.srate); {EEG.event(:).type}]';

BioSigPlotEEG(EEG.data,'SRate',EEG.srate,'Montage',Montage,'Evts',evts,'Title',title,'FilterHigh',60);

com = sprintf('pop_biosigplot( %s);', inputname(1)); 



return;
