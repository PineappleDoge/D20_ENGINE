-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Players = game:GetService("Players")

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

		local p = Players:GetPlayerFromCharacter(target:FindFirstAncestorOfClass("Model"))

		return p and p.Name or ""
	end
}