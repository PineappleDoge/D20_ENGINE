local Framework = shared.Framework

local Teleport = shared.Class:new()
Teleport.objects = {}
Teleport.creators = {}
Teleport.object = nil
Teleport.created = nil
Teleport.lastUpdated = 0
Teleport.teleporting = false
Teleport.enabled = true

function Teleport:getPosition()
	return self.object.Position
end

function Teleport:update(dt)
	if not self.teleporting then
		self.object.CFrame = self.object.CFrame * CFrame.Angles(0,dt * math.pi / 8,0)
		self.object.Back.CFrame = self.object.CFrame
	end
end

function Teleport:isObject(inst)
	return inst.Name:sub(1,8) == "Teleport"
end

function Teleport:Destroy()
	self.object:Destroy()
end

function Teleport:teleport()
	if self.enabled and not self.teleporting and Framework.Character.health > 0 and not Framework.HUDController.fading then
		self.teleporting = true
		
		Framework.InputController.canInput:add(1)
		Framework.InputController.canPause:add(1)
		
		Framework.Character:changeState("None")
		Framework.Character.physics.Anchored = true
		Framework.Character.physics.CFrame = self.created.CFrame
		Framework.Character.hidden = true
		Framework.Character.physics.Velocity = Vector3.new()
		
		workspace.CurrentCamera.CameraType = "Scriptable"
		game:GetService("TweenService"):Create(workspace.CurrentCamera,TweenInfo.new(.375,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{
			CFrame = CFrame.new((self.created.CFrame * CFrame.new(0,7.5,-15)).p,self.created.CFrame.p)
		}):Play()
		self.object.Transparency = 0
		self.object.Back.Transparency = 0
		
		local start,t = tick()
		local cf = self.object.CFrame
		repeat
			t = (tick() - start)
			local rot = t * 4 * math.pi
			local height = ((15 * t - 1)^2 - 1) / 5
			local size = (1 + t)^2
			self.object.Color = self.created.Color:lerp(Color3.new(1,1,1), t)
			self.object.Back.Color = self.object.Color
			self.object.CFrame = cf * CFrame.Angles(0,rot,0) * CFrame.new(0,height,0)
			self.object.Back.CFrame = self.object.CFrame
			self.object.Back.Mesh.Scale = Vector3.new(0.075, 0.075 * size, 0.075)
			self.object.Mesh.Scale = Vector3.new(0.075, 0.075 * size, 0.075)
			game:GetService("RunService").RenderStepped:wait()
		until t >= 1
		
		Framework.HUDController:fade(.375, 2, function()
			Framework.Character.physics.CFrame = self.created.Destination.CFrame
			Framework.Character.lookAt = self.created.Destination.CFrame.lookVector
			self.object.CFrame = self.created.Destination.CFrame
			self.object.Back.CFrame = self.created.Destination.CFrame
			workspace.CurrentCamera.CFrame = CFrame.new((self.created.Destination.CFrame * CFrame.new(0,7.5,15)).p,self.created.Destination.CFrame.p)
			self.object.Color = self.created.Destination.Color
			self.object.Back.Color = self.created.Destination.Color
			self.object.Sparkles.Color = ColorSequence.new(self.created.Destination.Color)
			self.object.Center.Flash.Color = ColorSequence.new(self.created.Destination.Color)
			self.object.Mesh.Scale = Vector3.new(0.075, 0.075, 0.075)
			self.object.Back.Mesh.Scale = Vector3.new(0.075, 0.075, 0.075)
		end, self.created.Color:lerp(Color3.new(1,1,1), .25))
		
		if self.cutscene then
			self:cutscene()
		end
		
		self.object.Transparency = .25
		self.object.Back.Transparency = .25
		Framework.Character.physics.Anchored = false
		Framework.Character.hidden = false
		
		Framework.InputController.canInput:sub(1)
		Framework.InputController.canPause:sub(1)
		workspace.CurrentCamera.CameraType = "Custom"
		
		local start,t = tick()
		local cf = self.object.CFrame
		repeat
			t = (tick() - start)
			local rot = t * 4 * math.pi
			local height = ((15 * t - 1)^2 - 1) / 5
			local size = (1 + t)^2
			self.object.Color = self.created.Destination.Color:lerp(Color3.new(1,1,1), t)
			self.object.Back.Color = self.object.Color
			self.object.CFrame = cf * CFrame.Angles(0,rot,0) * CFrame.new(0,height,0)
			self.object.Back.CFrame = self.object.CFrame
			self.object.Mesh.Scale = Vector3.new(0.075, 0.075 * size, 0.075)
			self.object.Back.Mesh.Scale = Vector3.new(0.075, 0.075 * size, 0.075)
			self.object.Transparency = .25 + .75 * t
			self.object.Back.Transparency = .25 + .75 * t
			game:GetService("RunService").RenderStepped:wait()
		until t >= 1
		
		self.object.Color = self.created.Color
		self.object.Back.Color = self.created.Color
		self.object.Sparkles.Color = ColorSequence.new(self.created.Color)
		self.object.Center.Flash.Color = ColorSequence.new(self.created.Color)
		self.object.Transparency = .25
		self.object.Back.Transparency = .25
		self.object.CFrame = self.created.CFrame
		self.object.Back.CFrame = self.created.CFrame
		self.object.Mesh.Scale = Vector3.new(0.075, 0.075, 0.075)
		self.object.Back.Mesh.Scale = Vector3.new(0.075, 0.075, 0.075)
		self.teleporting = false
	end
end

Teleport:construct("Teleport", function(newTeleport, inst)
	local object = game.ReplicatedStorage.Assets.Teleport:Clone()
	object.CFrame = inst.CFrame
	object.Back.CFrame = inst.CFrame
	object.Color = inst.Color
	object.Back.Color = inst.Color
	object.Sparkles.Color = ColorSequence.new(inst.Color)
	object.Center.Flash.Color = ColorSequence.new(inst.Color)
	object.Parent = workspace.Classes
	
	newTeleport:setName(object.Name)
	newTeleport.object = object
	newTeleport.objects[object] = newTeleport
	newTeleport.created = inst
	newTeleport.creators[inst] = newTeleport
	newTeleport:setParent(Framework.RangedClasses)
	
	object.AncestryChanged:connect(function()
		if not object:IsDescendantOf(game) then
			newTeleport:destroy()
		end
	end)
	
	inst.Transparency = 1
	inst.Destination.Transparency = 1
end)

return Teleport