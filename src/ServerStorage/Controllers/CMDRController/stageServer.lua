-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (context, players, stage)
	if not Framework.Enums.Stages:find(stage) then
		return "Invalid stage!"
	end
	
	for _, player in pairs(players) do
		Framework.Players[player.userId]:fireNet(Framework.Players[player.userId].object, "stage", stage)
	end

	return ("Teleported %d players."):format(#players)
end