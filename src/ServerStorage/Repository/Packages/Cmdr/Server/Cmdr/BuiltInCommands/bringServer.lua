-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local teleport = require(script.Parent:WaitForChild("teleportServer"))

return function (context, fromPlayers)
	return teleport(context, fromPlayers, context.Executor)
end
