function plot_cluster(axe,col,row,r,h,w,channames,badchan,clst,ratio)
%channames is optional
col=round(col*w);
row=round(row*h);
r=round(r*w);

%*bad channels
badchan=logical(badchan);

col=col(~badchan);
row=row(~badchan);
r=r(~badchan);
%**********************************

if ~isempty(channames)
    channames=channames(~badchan);
end
%**********************************

for i=1:length(channames)
    text(col(i),row(i)-10,channames{i},...
    'fontsize',round(8*ratio),'horizontalalignment','center','parent',axe,'interpreter','none');
end

for I=1:length(col)
%     if clst(I)==6;
%         color='r';
%     else
%         color='k';
%     end
    color='k';
    text(col(I),row(I),num2str(clst(I)),'parent',axe,'fontsize',round(15*ratio),'color',color,...
        'tag','cluster','horizontalalignment','center');
end

drawnow


end

