-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (_, players, speed)
	for _, player in pairs(players) do
		Framework.Players[player.userId]:fireNet(Framework.Players[player.userId].object, "charProperty", "speed", speed)
	end

	return ("Changed the speed of %d players."):format(#players)
end