function MoveElectrode( obj,src )

switch src
    case obj.ElectrodeRotateLeftMenu
        evt.Modifier={};
        evt.Key='leftarrow';
    case ElectrodeRotateRightMenu
        evt.Modifier={};
        evt.Key='rightarrow';
    case ElectrodeRotateUpMenu
        evt.Modifier={};
        evt.Key='uparrow';
    case ElectrodeRotateDownMenu
        evt.Modifier={};
        evt.Key='downarrow';
    case ElectrodePushInMenu
        evt.Modifier={'command'};
        evt.Key='downarrow';
    case ElectrodePullOutMenu
        evt.Modifier={'command'};
        evt.Key='uparrow';
    case ElectrodeSpinClockwiseMenu
        evt.Modifier={'command'};
        evt.Key='rightarrow';
    case ElectrodeSpinAntiClockwiseMenu
        evt.Modifier={'command'};
        evt.Key='leftarrow';
end
KeyPress(obj,src,evt);

end

