-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (_, players, name)
	for _, v in pairs(players) do
		local player = Framework.Players[v.userId]
		player.playerName = name or v.Name
		player:update()
	end

	return ("Changed the name of %d players."):format(#players)
end