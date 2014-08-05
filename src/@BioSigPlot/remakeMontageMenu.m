function remakeMontageMenu(obj)
delete(get(obj.MenuMontage,'Children'));

MontageOptMenu=cell(1,obj.DataNumber);

for i=1:obj.DataNumber
    if obj.DataNumber==1
        parent=obj.MenuMontage;
    else
        parent=uimenu(obj.MenuMontage,'Label',['Data-' num2str(i)]);
    end
    
    for j=1:length(obj.Montage_{i})
        h=uimenu(parent,'Label',obj.Montage_{i}(j).name,...
            'Callback',@(src,evt)ChangeMontage(obj,src,i,j));
        if j==obj.MontageRef(i)
            set(h,'Checked','on');
        else
            set(h,'Checked','off');
        end
        
        MontageOptMenu{i}(j)=h;
    end
    
end

obj.MontageOptMenu=MontageOptMenu;

end



