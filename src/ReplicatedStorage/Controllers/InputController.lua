local Framework = shared.Framework

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)
Controller.canInput = shared.Class:create("Threshold")
Controller.canPause = shared.Class:create("Threshold")
Controller.inputs = {}
Controller.console = false

Controller:onEvent("start", Controller, function(n)
	if Framework.Character then
		Framework.Character:doInput(n)
	end
end)
Controller:onEvent("end", Controller, function(n)
	if Framework.Character then
		Framework.Character:endInput(n)
	end
end)

function Controller:getMove()
	if not self.canInput:ready() then
		return Vector3.new()
	end
	local vector = require(game.Players.LocalPlayer.PlayerScripts.PlayerModule.ControlModule):GetMoveVector()
	if vector.magnitude > 0 then
		vector = vector.Unit * math.clamp(vector.magnitude,0,1)
	end
	return vector
end

function Controller:doInput(n, bypass)
	if not bypass and not self.canInput:ready() then
		self:send("startBypass",n)
		return
	end
	self:send("startBypass",n)
	self.inputs[n] = true
	self:send("start",n)
end

function Controller:endInput(n, bypass)
	if not bypass and not self.canInput:ready() then
		self.inputs[n] = false
		return
	end
	if self.inputs[n] then
		self.inputs[n] = false
		self:send("end",n)
	end
end

local CAS = game:GetService("ContextActionService")
CAS:BindAction("Space", function(_, state)
	if state.Name == "Begin" then
		Controller:doInput(1)
	else
		Controller:endInput(1)
	end
end, true, Enum.KeyCode.Space, Enum.KeyCode.ButtonA)
CAS:BindAction("Shift", function(_, state)
	if state.Name == "Begin" then
		Controller:doInput(2)
	else
		Controller:endInput(2)
	end
end, true, Enum.KeyCode.LeftShift, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonB)
CAS:BindAction("E", function(_, state)
	if state.Name == "Begin" then
		Controller:doInput(3)
	else
		Controller:endInput(3)
	end
end, true, Enum.KeyCode.E, Enum.KeyCode.ButtonX)
CAS:BindAction("Pause", function(_, state)
	if state.Name == "Begin" then
		Controller.pauseButton = true
		local clientController = Framework.ClientController
		if Controller.canPause:ready() and Framework.localPlayer and Framework.Character and Framework.Character:canPause() then
			clientController:pause()
			local menuController = Framework.MenuController
			menuController:start("Pause")
			clientController:unpause()
		end
	else
		Controller.pauseButton = false
	end
end, true, Enum.KeyCode.Tab, Enum.KeyCode.ButtonStart)

Controller.lastVector = Vector2.new()
game:GetService("RunService").RenderStepped:connect(function()
	Controller.console = game:GetService("UserInputService"):GetLastInputType().Name:find("Gamepad")
	local vector = require(game.Players.LocalPlayer.PlayerScripts.PlayerModule.ControlModule):GetMoveVector()
	local x = math.floor(vector.X + .5)
	local y = -math.floor(vector.Z + .5)
	local sendVector = {0,0}
	if x ~= Controller.lastVector.X then
		sendVector[1] = x
	end
	if y ~= Controller.lastVector.Y then
		sendVector[2] = y
	end
	if sendVector[1] ~= 0 or sendVector[2] ~= 0 then
		Controller:send("guiInput", Vector2.new(unpack(sendVector)))
	end
	Controller.lastVector = Vector2.new(x,y)
end)

return Controller