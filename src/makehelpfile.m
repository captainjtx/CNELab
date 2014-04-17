function makehelpfile(mfile)
%Save the help file for documentation
%
%SYNTAX
%   makehelpfile functionname
%   OR
%   makehelpfile classname

%123456789012345678901234567890123456789012345678901234567890123456789012
%
%     BioSigPlot Copyright (C) 2010 Samuel Boudet, Faculté Libre de Médecine,
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

htmlstr = help2html(mfile,mfile,'-doc');
htmlfile=['help/' mfile '.html'];


%Change CSS path
n=strfind(htmlstr,'<link rel="stylesheet" href="');
n2=strfind(htmlstr,'helpwin.css">');
htmlstr=htmlstr([1:n+28 n2:end]);

htmlstr=strrep(htmlstr,'CONCEPTS AND GENERAL DESCRIPTION','</pre></div><div class="sectiontitle">Concepts and general description</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'INPUTS','</pre></div><div class="sectiontitle">Inputs</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'INPUT','</pre></div><div class="sectiontitle">Input</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'READ-ONLY PROPERTIES','</pre></div><div class="sectiontitle">Read-only properties</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'READ/WRITE PROPERTIES','</pre></div><div class="sectiontitle">Read/write properties</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'PROPERTIES','</pre></div><div class="sectiontitle">Properties</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'DESCRIPTION','</pre></div><div class="sectiontitle">Description</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'OUTPUTS','</pre></div><div class="sectiontitle">Outputs</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'OUTPUT','</pre></div><div class="sectiontitle">Output</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'SYNTAX','</pre></div><div class="sectiontitle">Syntax</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'USAGE','</pre></div><div class="sectiontitle">Usage</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'MAIN FEATURES','</pre></div><div class="sectiontitle">Main features</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'METHODS','</pre></div><div class="sectiontitle">Methods</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'EXAMPLES','</pre></div><div class="sectiontitle">Examples</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'EXAMPLE','</pre></div><div class="sectiontitle">Example</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'INSTALLATION','</pre></div><div class="sectiontitle">Installation</div><div class="helptext"><pre>');
htmlstr=strrep(htmlstr,'EVENTS','</pre></div><div class="sectiontitle">Events</div><div class="helptext"><pre>');

%Replace CAPS titles

fid = fopen(htmlfile,'w');
fprintf(fid,'%s',htmlstr);
fclose(fid);