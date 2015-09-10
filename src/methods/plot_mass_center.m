function [erd_center,ers_center]=plot_mass_center(axe,mapval,col,row,erdchan,erschan,center_mass_opt,varargin)
%PLOT_MASS_CENTER Summary of this function goes here
%   Detailed explanation goes here
%center_mass_opt 0, no mass center, 1, single mass center, 2, hold on mass
%center,3 hold on mass without marker

erd_center=[];
ers_center=[];
mapval=abs(mapval);

pre_erd_center=[];
pre_ers_center=[];

if center_mass_opt>1
    if length(varargin)==1
        pre_erd_center=varargin{1};
    elseif length(varargin)==2
        pre_erd_center=varargin{1};
        pre_ers_center=varargin{2};
    end
end

erdchan=logical(erdchan);
erschan=logical(erschan);

if center_mass_opt==1
    delete(findobj(axe,'tag','mass'));
end

if ~isempty(erdchan)
    erdrow=row(erdchan);
    erdcol=col(erdchan);
    if ~isempty(erdcol)&&center_mass_opt
        weight=reshape(mapval(erdchan),length(erdcol),1);
        weight=weight/sum(weight);
        erd_center=[reshape(erdrow,1,length(erdrow));reshape(erdcol,1,length(erdcol))]*weight;
        %         I=insertMarker(I,[center(2),center(1)],'+','color','red','size',4);
        if center_mass_opt~=3
            text('position',[erd_center(2),erd_center(1)],'string','+','fontsize',15,'color','r','tag','mass',...
                'horizontalalignment','center','parent',axe);
        end
        if ~isempty(pre_erd_center)
            line([pre_erd_center(2),erd_center(2)],[pre_erd_center(1),erd_center(1)],...
                'parent',axe,'color','r','tag','mass','linestyle','-');
        end
        
    end
end
if ~isempty(erschan)
    ersrow=row(erschan);
    erscol=col(erschan);
    if ~isempty(erscol)&&center_mass_opt
        weight=reshape(mapval(erschan),length(erscol),1);
        weight=weight/sum(weight);
        ers_center=[reshape(ersrow,1,length(ersrow));reshape(erscol,1,length(erscol))]*weight;
        %         I=insertMarker(I,[center(2),center(1)],'+','color','blue','size',4);
        if center_mass_opt~=3
            text('position',[ers_center(2),ers_center(1)],'string','+','fontsize',15,'color','b','tag','mass',...
                'horizontalalignment','center','parent',axe);
        end
        if ~isempty(pre_ers_center)
            line([pre_ers_center(2),ers_center(2)],[pre_ers_center(1),ers_center(1)],...
                'parent',axe,'color',' b','tag','mass','linestyle','-');
        end
    end
end

end

