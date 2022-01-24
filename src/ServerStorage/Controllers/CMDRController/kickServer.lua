-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (context, players)
	for _, player in pairs(players) do
		Framework.ServerController:kick(player, context.Executor)
	end

	return ("Kicked %d players."):format(#players)
end