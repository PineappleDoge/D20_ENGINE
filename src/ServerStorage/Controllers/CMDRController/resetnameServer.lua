-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (context, players)
	for _, v in pairs(players) do
		local player = Framework.Players[v.userId]
		player.playerName = player.object.Name
		player.chatNameColor = nil
		player.chatColor = nil
		player:update()
	end

	return ("Reset the tag of %d players."):format(#players)
end