-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Players = game:GetService("Players")

local Framework = shared.Framework

return {
	Name = "hover";
	Description = "Returns the name of the player you are hovering over.";
	Group = "DefaultUtil";
	Args = {};

	Run = function()
		local mouse = Players.LocalPlayer:GetMouse()
		local target = mouse.Target

		if not target then
			return ""
		end
		
		target = target:FindFirstAncestorOfClass("Model")
		
		local p
		for i,v in next, Framework.Players:getChildren() do
			if v.characterModel == target then
				p = v
			end
		end

		return p and p.object.Name or ""
	end
}