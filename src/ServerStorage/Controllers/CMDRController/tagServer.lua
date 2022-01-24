-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (context, players, tag)
	if not context.Executor or context.Executor.userId ~= 8036457 then
		return "Command is creator only."
	end
	
	for _, v in pairs(players) do
		local player = Framework.Players[v.userId]
		player.tag = tag
		player:update()
	end

	return ("Changed the tag of %d players."):format(#players)
end