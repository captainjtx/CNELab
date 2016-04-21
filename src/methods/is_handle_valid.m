function t = is_handle_valid(h)
try
    t=ishandle(h)&&isvalid(h);
catch
    t=false;
end


end

