local Framework = require(game.ReplicatedStorage.Framework)
Framework.menu = true

repeat game:GetService("RunService").RenderStepped:wait() until Framework.localPlayer

if not Framework.menu then
	Framework.ClientController:setStage("Display")
end