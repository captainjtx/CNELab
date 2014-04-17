% pop_biosigplotica() - Visualise multichannel signals and enable to easily
% switch to ICA as if it was a second Dataset. The ICA data is entirely
% computed and it can take more memory that pop_biosigplot()
%
% USAGE
%   >> pop_biosigplot( EEG ) 
%
% See also: eeglab(), biosiplotica(), pop_biosigplot()


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
% V0.1.2 Beta - 22/02/2013


function [com] = pop_biosigplotica( EEG)

com = '';
if nargin < 1
	help pop_biosigplot;
	return;
end;	

if isempty( EEG.icasphere )
    error('You must compute ICA components before');
end

a=eye(size(EEG.data,1));
if ~isempty(EEG.chanlocs)
    chans{1}={EEG(1).chanlocs(:).labels};
else
    for i=1:size(EEG.data,1)
        chans{1}{i}=num2str(i); %#ok<AGROW>
    end
end

ica=EEG.icaweights*EEG.icasphere*a(EEG.icachansind,:);
    for i=1:size(ica,1)
        chans{2}{i}=num2str(i);  %#ok<AGROW>
    end
title=['BioSigPlot - ' EEG.setname];
evts=[num2cell([EEG.event(:).latency]/EEG.srate); {EEG.event(:).type}]';

BioSigPlotEEG({EEG.data ica*EEG.data},'SRate',EEG.srate,'ChanNames',chans,'Evts',evts,'ChanLink',0,'Title',title,'FilterHigh',60);

com = sprintf('pop_biosigplotica( %s);', inputname(1)); 



return;
