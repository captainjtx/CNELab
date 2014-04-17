% eegplugin_biosigplot() - EEGLAB plugin to visualise signal. 
%
% USAGE
%   >> eegplugin_biosigplot(fig, trystrs, catchstrs);
%
% INPUTS
%   fig        - [integer]  EEGLAB figure
%   trystrs    - [struct] "try" strings for menu callbacks.
%   catchstrs  - [struct] "catch" strings for menu callbacks. 
%
% INSTALLATION
%   To install biosigplot as EEGLab pluggin you just have to copy
%   biosigplot folder into the EEGLAB "plugins" directory.
%
% DESCRIPTION
%   Provides the menu to open EEG and ICA channels into BioSigPlot
%   interface instead of eegplot function from EEGLab
%
%
% Create a plugin:
%   For more information on how to create an EEGLAB plugin see the
%   help message of eegplugin_besa() or visit
%   http://sccn.ucsd.edu/wiki/A07:_Contributing_to_EEGLAB
%
% Authors: Samuel Boudet (Faculté Libre de Médecine Lille France)


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
% V0.1.2 Beta - 22/02/2013 - 


function vers = eegplugin_biosigplot(fig, trystrs, catchstrs)
    
    vers = 'BioSigPlot0.1.1beta';
  if nargin < 3
      error('eegplugin_biosigplot requires 3 arguments');
  end;
    
  % add besa folder to path
  % -----------------------
  if ~exist('pop_biosigplot')
      p = which('eegplugin_biosigplot');
      p = p(1:findstr(p,'eegplugin_biosigplot.m')-1);
      addpath([ p vers ] );
  end;
  
  % find import data menu
  % ---------------------
  toolsmenu = findobj(fig, 'tag', 'plot');
  submenu = uimenu( toolsmenu, 'label', 'Plot EEG (and ICA sources) with BioSigPlot');

  
  % menu callbacks
  % --------------
  combio = [ trystrs.no_check '[LASTCOM] = pop_biosigplot(EEG);' catchstrs.add_to_hist ]; 
  combio2 = [ trystrs.no_check '[LASTCOM] = pop_biosigplotica(EEG);' catchstrs.add_to_hist ]; 
  
  % create menus if necessary
  % -------------------------
  uimenu( submenu, 'Label', 'ICA sources as Montage (More display possibility)',  'CallBack', combio2, 'Separator', 'on'); 
  uimenu( submenu, 'Label', 'ICA sources as Montage (Less memmory using but less convenient)',  'CallBack', combio, 'Separator', 'on'); 
  
