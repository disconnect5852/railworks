DEBUG = false

gTimerValue = 0.0
TIMEOUT_1000 = 8.0
gIsExpert = false

function Initialise()

	gIsExpert = Call ( "IsExpertMode" ) ~= 0
    DebugPrint ( ( "DEBUG: Initialise " ) )

-- Stores for checking when values have changed.

	gDriven = 0
	gTimerActive = 0
	Call( "*:SetControlValue", "panto01", 0, 1 )
	Call( "BeginUpdate" )
	
end

--

function Update( time )

	if gTimerActive == 1 then
		gTimerValue = gTimerValue - time
		if ( gTimerValue <= 0.0 ) then
			Call ( "*:SetControlValue", "EmergencyBrake", 0, 1)
		end
	end

-- Check for player train.

	if Call( "GetIsPlayer" ) == 1 then

-- Check if player is driving this engine.

		if ( Call( "GetIsEngineWithKey" ) == 1 ) then
			if gDriven == 0 then
				gDriven = 1
				Call( "*:SetControlValue", "Active", 0, 1 )
			end
			if (Call( "*:GetControlValue", "panto01", 0)==1 or Call( "*:GetControlValue", "panto02", 0)==1 or Call( "*:GetControlValue", "panto03", 0)==1 or Call( "*:GetControlValue", "panto04", 0)==1) then
				Call( "*:SetControlValue", "PantographControl", 0, 1 )
			else
				Call( "*:SetControlValue", "PantographControl", 0, 0 )
			end
		else
			if gDriven == 1 then
				gDriven = 0
				Call( "*:SetControlValue", "Active", 0, 0 )
			end
		end
	end

end

function OnControlValueChange ( name, index, value )
	Call( "*:SetControlValue", name, index, value );
	if ( name == "AWSReset" and value > 0 ) then
		Call ( "*:SetControlValue", "AWS", 0, 0 )
		Call ( "*:SetControlValue", "AWSWarnCount", 0, 0 )
		Call ( "*:SetControlValue", "EmergencyBrake", 0, 0 )
		gTimerActive = 0
	end
end

function OnConsistMessage ( message, arg, direction )
	DebugPrint ( ( "DEBUG: OnConsistMessage msg:" .. message .. ", arg:" .. arg .. ", dir" .. direction ) )
end

function OnCustomSignalMessage ( arg )
	DebugPrint ( ( "DEBUG: OnCustomSignalMessage arg:" .. arg ) )
	if ( gIsExpert ) then
		if ( arg == "1000" ) then
			Call ( "*:SetControlValue", "AWS", 0, 1 )
			Call ( "*:SetControlValue", "AWSWarnCount", 0, 1)
			gTimerValue = TIMEOUT_1000
			gTimerActive = 1
		elseif (arg == "2000" ) then
			local canPass = Call ( "GetRequestedSPAD" )
			DebugPrint ( ( "DEBUG: OnCustomSignalMessage: canPass " .. canPass ) )
			if canPass == 0 then
				Call ( "*:SetControlValue", "EmergencyBrake", 0, 1)
			end
		end
	end
end

function DebugPrint( message )
	if (DEBUG) then
		Print( message )
	end
end

