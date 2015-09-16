function SelectCurrentWindow(obj,src)

selection=[round(obj.Time*obj.SRate);round((obj.Time+obj.WinLength)*obj.SRate)];
selection=max(1,min(selection,size(obj.Data{1},1)));

obj.Selection=selection;

end

