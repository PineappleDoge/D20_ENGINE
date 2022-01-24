-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (_, players, dmg)
	for _, player in pairs(players) do
		Framework.Players[player.userId]:fireNet(Framework.Players[player.userId].object, "heal", dmg)
	end

	return ("Healed %d players."):format(#players)
end