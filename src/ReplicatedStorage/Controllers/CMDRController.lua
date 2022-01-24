local Framework = shared.Framework
local Util = Framework.Util

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)

coroutine.wrap(function()
	repeat wait() until Framework.localPlayer
	repeat game:GetService("RunService").RenderStepped:wait() until Framework.ClientController
	Framework.localPlayer:waitForGen()
	Controller.cmdr = require(game.ReplicatedStorage.Resources):LoadLibrary("CmdrClient")
	Controller.cmdr:SetActivationKeys({Enum.KeyCode.Semicolon})
	Controller.cmdr:SetEnabled(Framework.localPlayer.admin)
	
	if Framework.localPlayer.admin then
		game:GetService("RunService").RenderStepped:connect(function()
			Controller.cmdr:SetPlaceName(Framework.stage)
		end)
	end
end)()

return Controller