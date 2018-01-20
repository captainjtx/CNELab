text_h = findobj(gca, 'Type', 'text');
for cnt = 1:length(text_h)
        yshift=get(text_h(cnt), 'Position');
        yshift(2)=yshift(2)-10;
%         yshift(1)=yshift(1)+5;
        set(text_h(cnt), 'Position', yshift);
end