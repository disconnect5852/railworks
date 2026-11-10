function OnControlValueChange ( name, index, value )
if Call( "*:ControlExists", name, index ) then
Call( "*:SetControlValue", name, index, value );
end
end