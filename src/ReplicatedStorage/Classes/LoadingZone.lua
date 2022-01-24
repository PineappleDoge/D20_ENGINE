local Framework = shared.Framework

local LoadingZone = shared.Class:new()
LoadingZone.objects = {}
LoadingZone.object = nil
LoadingZone.lastUpdated = 0
LoadingZone.teleporting = false
LoadingZone.enabled = true

function LoadingZone:isObject(inst)
	return inst.Name:sub(1,11) == "LoadingZone"
end

function LoadingZone:Destroy()
	self.object:Destroy()
end

function LoadingZone:teleport()
	if self.enabled and not self.teleporting and Framework.Character.health > 0 and not Framework.HUDController.fading then
		self.teleporting = true
		
		Framework.InputController.canInput:add(1)
		Framework.InputController.canPause:add(1)
		
		Framework.Character:changeState("None")
		Framework.Character.physics.Velocity = Vector3.new()
		Framework.Character.moveTo = self.object.Position
		
		workspace.CurrentCamera.CameraType = "Scriptable"
		game:GetService("TweenService"):Create(workspace.CurrentCamera,TweenInfo.new(.375,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{
			CFrame = CFrame.new((self.object.CFrame * CFrame.new(0,7.5,-15)).p,self.object.CFrame.p)
		}):Play()
		
		wait(1)

		local stage = self.object.Name:sub(12)
		local dcp = "Main"
		if (self.object:FindFirstChild("Checkpoint")) then
			dcp = self.object.Checkpoint.Value
		end
		Framework.ClientController.defaultCheckpoint = dcp
		Framework.ClientController:teleport(stage)

		Framework.InputController.canInput:sub(1)
		Framework.InputController.canPause:sub(1)
		
		self.teleporting = false
	end
end

LoadingZone:construct("LoadingZone", function(newLoadingZone, inst)
	newLoadingZone:setName(inst.Name)
	newLoadingZone.object = inst
	newLoadingZone.objects[inst] = newLoadingZone
	
	inst.AncestryChanged:connect(function()
		if not inst:IsDescendantOf(game) then
			newLoadingZone:destroy()
		end
	end)
end)

return LoadingZone