function plot_covariance(axe,col,row,pos,neg,cov_matrix,pos_t,neg_t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

delete(findobj(axe,'tag','cov'));

pos_t=cat(1,sort(pos_t(:)),1);
neg_t=cat(1,-1,sort(neg_t(:)));

cov_matrix=cov_matrix/max(max(abs(cov_matrix)));
if pos
    for r=1:size(cov_matrix,1)
        for c=1:size(cov_matrix,2)
            for t=1:length(pos_t)-1
                if cov_matrix(r,c)>=pos_t(t)&&cov_matrix(r,c)<pos_t(t+1)
                    %                 hold on
                    line([col(r),col(c)],[row(r),row(c)],'color','k','linewidth',2*t-1,...
                        'tag','cov','parent',axe,'linestyle','-');
                end
            end
        end
    end
end

if neg
    for r=1:size(cov_matrix,1)
        for c=1:size(cov_matrix,2)
            for t=length(neg_t):-1:2
                if cov_matrix(r,c)<=neg_t(t)&&cov_matrix(r,c)>neg_t(t-1)
%                 hold on
                line([col(r),col(c)],[row(r),row(c)],'color','k','linewidth',2*(length(neg_t)-t)+1,...
                    'tag','cov','parent',axe,'linestyle','-');
                end
            end
        end
    end
end

drawnow
end

