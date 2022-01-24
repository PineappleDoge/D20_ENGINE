local Framework = shared.Framework

local TPZone = shared.Class:new()
TPZone.objects = {}
TPZone.object = nil
TPZone.lastUpdated = 0
TPZone.teleporting = false
TPZone.enabled = true

function TPZone:isObject(inst)
	return inst.Name:sub(1,6) == "TPZone"
end

function TPZone:Destroy()
	self.object:Destroy()
end

function TPZone:teleport()
	if self.enabled and not self.teleporting and Framework.Character.health > 0 then
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
		
		Framework.HUDController:fade(.375, 2, function()
			Framework.Character.physics.CFrame = self.object.Destination.CFrame
			Framework.Character.lookAt = self.object.Destination.CFrame.lookVector
			workspace.CurrentCamera.CFrame = CFrame.new((self.object.Destination.CFrame * CFrame.new(0,7.5,-15)).p,self.object.Destination.CFrame.p)
			Framework.Character.moveTo = nil
		end)
		
		if self.cutscene then
			self:cutscene()
		end
		
		Framework.InputController.canInput:sub(1)
		Framework.InputController.canPause:sub(1)
		workspace.CurrentCamera.CameraType = "Custom"
		
		self.teleporting = false
	end
end

TPZone:construct("TPZone", function(newTPZone, inst)
	
	newTPZone:setName(inst.Name)
	newTPZone.object = inst
	newTPZone.objects[inst] = newTPZone
	
	inst.AncestryChanged:connect(function()
		if not inst:IsDescendantOf(game) then
			newTPZone:destroy()
		end
	end)
	
	inst.Destination.Transparency = 1
end)

return TPZone