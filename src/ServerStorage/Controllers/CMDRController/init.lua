local Framework = _G.Framework
local Util = Framework.Util

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)

Controller.cmdr = require(game.ReplicatedStorage.Resources):LoadLibrary("Cmdr")
Controller.cmdr:RegisterDefaultCommands(function(cmd)
	return not script:FindFirstChild(cmd.Name) -- This is absurd... but possible!
end)
Controller.cmdr:RegisterCommandsIn(script)
Controller.cmdr.Registry:AddHook("BeforeRun", function(context)
	if not context.Executor then
		return
	end
	local player = Framework.Players[context.Executor.userId]
	if not player or not player.admin then
		return "You don't have permission to run this command!"
	end
end)

return Controller