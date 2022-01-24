local Class = require(game.ReplicatedStorage.Class)
_G.Class = Class
shared.Class = Class

local Framework = Class:new()
Framework.instance = game.ReplicatedStorage
Class.__instances[game.ReplicatedStorage] = Framework
_G.Framework = Framework
shared.Framework = Framework

if Framework.__server then
	
	Class:bindGenerate(game.ReplicatedStorage.Objects)
	for i,v in next, game.ServerStorage.Classes:GetChildren() do
		if v:IsA("ModuleScript") then
			require(v)
			for i,v in next, v:GetChildren() do
				require(v)
			end
		end
	end
	for i,v in next, game.ServerStorage.Controllers:GetChildren() do
		if v:IsA("ModuleScript") then
			require(v)
		end
	end
	
else
	
	repeat wait() until game.Players.LocalPlayer.Character
	
	for i,v in next, game.ReplicatedStorage.Classes:GetChildren() do
		if v:IsA("ModuleScript") then
			require(v)
			for i,v in next, v:GetChildren() do
				require(v)
			end
		end
	end
	require(game.ReplicatedStorage.Controllers.InputController)
	for i,v in next, game.ReplicatedStorage.Controllers:GetChildren() do
		if v:IsA("ModuleScript") then
			require(v)
		end
	end
	
	game.ReplicatedStorage.Framework.Parent = nil
	game.ReplicatedStorage.Classes.Parent = nil
	game.ReplicatedStorage.Controllers.Parent = nil
	script.Parent = nil
	
	wait(1)
	Class:bindGenerate(game.ReplicatedStorage.Objects)
	
end

return Framework