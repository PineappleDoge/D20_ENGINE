-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (context, players, r, g, b)
	local color
	if r and g and b then
		color = Color3.fromRGB(r,g,b)
	end
	for _, v in pairs(players) do
		local player = Framework.Players[v.userId]
		player.chatColor = color
		player:update()
	end

	return ("Changed the chat color of %d players."):format(#players)
end