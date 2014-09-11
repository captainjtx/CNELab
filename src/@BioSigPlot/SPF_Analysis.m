function SPF_Analysis(obj,src)
%Subspace Projection Filter

[data,chanNames]=get_selected_data(obj);
switch src
    case obj.BtnPCA
        
        obj.SPFObj=SPFPlot(data);
end

end

