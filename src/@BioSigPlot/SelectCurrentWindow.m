function SelectCurrentWindow(obj,src)

selection=[round(obj.Time*obj.SRate);round((obj.Time+obj.WinLength)*obj.SRate)];
selection=max(1,min(selection,obj.TotalSample));

obj.Selection=selection;

end

