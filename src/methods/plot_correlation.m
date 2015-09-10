function plot_correlation(axe,col,row,pos,neg,sig,corr_matrix,pos_t,neg_t,p_matrix,p_t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

delete(findobj(axe,'-regexp','tag','corr'));

if pos
    for r=1:size(corr_matrix,1)
        for c=1:size(corr_matrix,2)
            if corr_matrix(r,c)>pos_t
%                 hold on
                line([col(r),col(c)],[row(r),row(c)],'color','k','linewidth',1,...
                    'tag','corr','parent',axe,'linestyle','-');
            end
        end
    end
end

if neg
    for r=1:size(corr_matrix,1)
        for c=1:size(corr_matrix,2)
            if corr_matrix(r,c)<neg_t
%                 hold on
                line([col(r),col(c)],[row(r),row(c)],'color','w','linewidth',1,...
                    'tag','corr','parent',axe,'linestyle','-');
            end
        end
    end
end

if sig
    for r=1:size(p_matrix,1)
        for c=1:size(p_matrix,2)
            if p_matrix(r,c)<p_t
                %this is unlikely to happen by chance
%                 hold on
                line([col(r),col(c)],[row(r),row(c)],'color','r','linewidth',1,...
                    'tag','corr','parent',axe,'linestyle','-');
            end
        end
    end
end

drawnow
end

