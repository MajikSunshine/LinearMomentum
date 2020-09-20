--Linear Momentum v1.0 by Rio --> Displays linear momentum based on ships mass/speed
	--diplay will turn yellow when cargo is heavier than ship, red at cargo 2X ship mass.
LM = {}
LMtimer = Timer()
LMv = "1.0"

LMlabel = iup.label{ title = "none"}
LMiup = iup.hbox{
	LMlabel
}

function LMupdate()
	if GetActiveShipMass() and GetActiveShipSpeed() then
		LMlabel.title = tostring(math.ceil((GetActiveShipMass() * GetActiveShipSpeed()))).." p"
		LM.shipitems = GetShipInventory(GetActiveShipID())
		local LMshipcargomass = 0
		for x,y in pairs(LM.shipitems.cargo) do
			LMshipcargomass = LMshipcargomass + GetInventoryItemMass(y) * GetInventoryItemQuantity(y)
		end
		if LMshipcargomass <= GetActiveShipMass() - LMshipcargomass then
			LMlabel.fgcolor = "255 255 255"
		elseif LMshipcargomass > (GetActiveShipMass() - LMshipcargomass ) * 2 then
			LMlabel.fgcolor = "255 0 0"
		else
			LMlabel.fgcolor = "255 255 0"
		end
	end
	iup.Refresh(iup.GetParent(HUD.leftbar))
	if LMtimer:IsActive() then LMtimer:Kill() end
	LMtimer:SetTimeout(500, function() LMupdate() end)
end

function LM:OnEvent(event, data)
	if event == "PLAYER_ENTERED_GAME" then
		print("Linear Motion v"..LMv)
		iup.Append(iup.GetParent(HUD.leftbar), LMiup)
		LMupdate()
	end
	
	if event == "HUD_SHOW" then
		if LMtimer:IsActive() then LMtimer:Kill() end
		LMtimer:SetTimeout(500, function() LMupdate() end)
	end
	
	if event == "HUD_HIDE" then
		if LMtimer:IsActive() then LMtimer:Kill() end
	end
	
	if event == "PLAYER_LOGGED_OUT" then
		if LMtimer:IsActive() then LMtimer:Kill() end
	end
end

RegisterEvent(LM, "PLAYER_ENTERED_GAME")
RegisterEvent(LM, "PLAYER_LOGGED_OUT")
RegisterEvent(LM, "HUD_SHOW")
RegisterEvent(LM, "HUD_HIDE")
