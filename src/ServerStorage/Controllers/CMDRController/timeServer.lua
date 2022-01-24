-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (_, players, time)
	local jump = 30 * time
	local speed = 20 * time
	local grav = 120 * time^2
	for _, player in pairs(players) do
		Framework.Players[player.userId]:fireNet(Framework.Players[player.userId].object, "charProperty", "speed", speed)
		Framework.Players[player.userId]:fireNet(Framework.Players[player.userId].object, "charProperty", "jump", jump)
		Framework.Players[player.userId]:fireNet(Framework.Players[player.userId].object, "charProperty", "gravity", grav)
	end

	return ("Changed the speed of %d players."):format(#players)
end