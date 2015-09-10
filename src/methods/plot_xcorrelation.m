function plot_xcorrelation(axe,col,row,pos,corr_matrix,pos_t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

delete(findobj(axe,'-regexp','tag','xcorr'));

if pos
    for r=1:size(corr_matrix,1)
        for c=1:size(corr_matrix,2)
            if corr_matrix(r,c)>pos_t
%                 hold on
                line([col(r),col(c)],[row(r),row(c)],'color','k','linewidth',1,...
                    'tag','xcorr','parent',axe,'linestyle','-');
            end
        end
    end
end

drawnow
end

