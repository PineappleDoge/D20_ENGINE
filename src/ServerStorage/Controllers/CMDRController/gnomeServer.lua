-- A fully extensible and type-safe admin-commands console
-- @documentation https://github.com/evaera/Cmdr/blob/master/README.md
-- @source https://github.com/evaera/Cmdr
-- @rostrap Cmdr
-- @author evaera

local stage = require(script.Parent:WaitForChild("stageServer"))

return function (context, players)
	stage(context, players, "http://www.noggin-clontith.com/")

	return ("Gnomed %d players."):format(#players)
end
