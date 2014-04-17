% Demonstration of BioSigPlot 
%   USAGE
%  >>biosigdemo
%
%  More info on BioSigPlot
%  >>doc BioSigPlot

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
% V0.1.2 Beta - 13/02/2013 - Initial Version
function biosigdemo
%Plot Signals
load filterdemo
a=BioSigPlot({data fdata},'srate',250,'Montage','1020system19','video','videodemo.avi');
assignin('base','a',a);
assignin('base','data',data);
assignin('base','fdata',fdata);
disp('load filterdemo')
disp('a=BioSigPlot({data fdata},''srate'',250,''Montage'',''1020system19'',''video'',''videodemo.avi'');')
disp('Press a key to continue');pause
%Define Events
a.Evts={10 'Electrode';64 'Muscle';86 'Muscle';110,'End HVT';144 'Smile'};
disp('a.Evts={10 ''Electrode'';64 ''Muscle'';86 ''Muscle'';110,''End HVT'';144 ''Smile''};')
disp('Press a key to continue');pause
%Change the Montage to Mean Reference Montage (Note that the filtered
%EEG is already Mean referenced)
a.MontageRef=2;
disp('a.MontageRef=2;')
disp('Press a key to continue');pause
%Move through Time
a.Time=40;
disp('a.Time=40;')
disp('Press a key to continue');pause
%Change to Horizontal View
a.DataView='Horizontal';
disp('a.DataView=''Horizontal'';')
disp('Press a key to continue');pause
%Change Scales of the 2 Datasets
a.Spacing=100;
disp('a.Spacing=100;')
disp('Press a key to continue');pause
%Change Spacing on the second dataset only
a.Spacing(2)=200;
disp('a.Spacing(2)=200;')
disp('Press a key to continue');pause
%Change the scale of the third electrod on dataset 1 (2nd Montage ie Mean Reference)
a.Montage{1}(2).mat(3,:)=a.Montage{1}(2).mat(3,:)/10;
disp('a.Montage{1}(2).mat(3,:)=a.Montage{1}(2).mat(3,:)/10;')
disp('Press a key to continue');pause
%Start the Fast Reading
a.StartFastRead
disp('a.StartFastRead')
disp('Press a key to continue');pause
%Stop it
a.StopFastRead
disp('a.StopFastRead')
disp('Press a key to continue');pause
%New example with BioSigPlotFHR
load FHRdemo
b=BioSigPlotFHR(FHR,TOCO);
assignin('base','b',b);
assignin('base','FHR',FHR);
assignin('base','TOCO',TOCO);
disp('load FHRdemo')
disp('b=BioSigPlotFHR(FHR,TOCO)');




