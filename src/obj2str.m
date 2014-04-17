%Converts any Matlab object (cells, struct or else...) into string
% If you eval the converted object, you will find the original object.
% USAGE
%   >> s=obj2str(obj1 [,obj2 [,...]]);
%
% INPUT
%   obj1,obj2,...  Any object. Can be numeric, string, matrix, struct, boolean, cell
%
% OUTPUT
%   s              String so which will build original objects when you "eval" it. If 
%                  several object are given in argument, each object are
%                  separated by comma


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
% V0.1.1 Beta - 13/02/2013 - Initial Version


function s=obj2str(varargin)
s='';
for m=1:nargin
    g=varargin{m};
    if iscell(g)
        s=[s '{'];
        for i=1:size(g,1)
            for j=1:size(g,2)
                s=[s obj2str(g{i,j})]; %#ok<*AGROW>
                if j~=size(g,2)
                    s=[s ' '];
                end
            end
            if i~=size(g,1)
                s=[s ';'];
            end
        end
        s=[s '}'];
    elseif ischar(g)
        s=[s '''' g ''''];
    elseif isnumeric(g)
        s=[s mat2str(g)];
    elseif islogical(g)
        if g
            s=[s 'true'];
        else
            s=[s 'false'];
        end
    elseif isstruct(g)
        s=[s '['];
        for i=1:size(g,1)
            for j=1:size(g,2)
                s=[s 'struct('];
                l=fieldnames(g(i,j));
                for k=1:length(l)
                    p=g(i,j).(l{k});
                    if iscell(p),p={p};end
                    s=[s '''' l{k} ''',' obj2str(p) ','];
                end
                s=[s(1:end-1) ') '];
            end
            if i~=size(g,1)
                s=[s ';'];
            end
        end
        s=[s(1:end-1) ']'];
    else
        s='null';
    end
    
    if m~=nargin
        s=[s ','];
    end
end
end