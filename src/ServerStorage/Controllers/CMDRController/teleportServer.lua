-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (_, fromPlayers, toPlayer)
	local cframe = Framework.Players[toPlayer.userId].Character.cframe + Vector3.new(0,.5,0)
	
	for _, player in ipairs(fromPlayers) do
		Framework.Players[player.userId]:fireNet(Framework.Players[player.userId].object, "teleport", cframe)
	end
	
	return ("Teleported %d players."):format(#fromPlayers)
end
