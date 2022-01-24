-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local Framework = _G.Framework

return function (_, fromPlayers, velocity)
	
	for _, player in ipairs(fromPlayers) do
		Framework.Players[player.userId]:fireNet(Framework.Players[player.userId].object, "loadstring", [[
			Framework.Character.physics.Velocity = Vector3.new(]]..((math.random() - .5) * velocity)..[[,]]..velocity..[[,]]..((math.random() - .5) * velocity)..[[)
			Framework.Character:changeState("Rolling")
		]])
	end
	
	return ("Flung %d players."):format(#fromPlayers)
end
