local Framework = shared.Framework
local Util = Framework.Util

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)
Controller.modifiers = {}

function Controller:addModifier(mod)
	self.modifiers[#self.modifiers + 1] = mod
	return function()
		for i,v in next, self.modifiers do
			if v == mod then
				table.remove(self.modifiers, i)
			end
		end
	end
end

do
	local CFOV = 70
	local CCT = game.Lighting.ClockTime
	Controller:addModifier(function(tab, dt)
		local FOV = tab.FieldOfView
		local CT = tab.ClockTime
		if Framework.localPlayer.Data.musicFX then
			FOV = FOV - 3 + 6 * Framework.Sounds.musicLoudness/500
			CT = 4.5 + 1 * Framework.Sounds.musicLoudness/500
		end
		tab.FieldOfView = FOV + (FOV - CFOV) * Util.Numbers:invLerp(.025,1/30,dt)
		tab.ClockTime = CCT + (CT - CCT) * Util.Numbers:invLerp(.1,1/60,dt)
		CFOV = tab.FieldOfView
		CCT = tab.ClockTime
	end)
end

Controller.tab = {
	FieldOfView = 70,
	Ambient = game.Lighting.Ambient,
	OutdoorAmbient = game.Lighting.OutdoorAmbient,
	ColorShift_Bottom = game.Lighting.ColorShift_Bottom,
	ColorShift_Top = game.Lighting.ColorShift_Top,
	FogColor = game.Lighting.FogColor,
	FogStart = game.Lighting.FogStart,
	FogEnd = game.Lighting.FogEnd,
	Brightness = game.Lighting.Brightness,
	ClockTime = game.Lighting.ClockTime
}
function Controller:update(dt)
	if not Framework.localPlayer then
		return
	end
	local tab = {}
	for i,v in next,self.tab do
		tab[i] = v
	end
	for i,v in next, self.modifiers do
		v(tab,dt)
	end
	for i,v in next, tab do
		if i ~= "FieldOfView" then
			game.Lighting[i] = v
		else
			workspace.CurrentCamera[i] = v
		end
	end
end

return Controller