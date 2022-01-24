local Framework = shared.Framework

local Collect = shared.Class:new()
Collect.object = nil
Collect.objects = {}
Collect.lastUpdated = 0
Collect.collectCheck = 0

function Collect:update(dt)
	if self.isCollected and self.collectCheck < 100 then
		self.collectCheck = self.collectCheck + 1
		if self:isCollected() then
			self:destroy()
			return
		end
	end
	if not self.collected then
		self.object.CFrame = self.object.CFrame * CFrame.Angles(0,dt * math.pi,0)
	end
end

function Collect:isObject(inst)
	return inst.Name:sub(1,7) == "Collect"
end

function Collect:Destroy()
	self.object:Destroy()
end

function Collect:getPosition()
	return self.object.Position
end

function Collect:get()
	if not self.collected and Framework.Character.health > 0  then
		self.collected = true
		if self.collect then
			self:collect()
		end
		
		Framework.InputController.canInput:add(1)
		Framework.InputController.canPause:add(1)
		
		local Label = game.Players.LocalPlayer.PlayerGui.GUIs.MainHUD.Collect
		Label.Thing.Text = self.text or "Object undefined."
		Label:TweenPosition(UDim2.new(0,0,.9,-100),"InOut","Quad",.5,true)
		workspace.CurrentCamera.CameraType = "Scriptable"
		workspace.CurrentCamera.CFrame = CFrame.new((self.startCF * CFrame.new(0,3,-6)).p,self.startCF.p + Vector3.new(0,1.5,0))
		Framework.Character.physics.Anchored = true
		Framework.Character.physics.CFrame = self.startCF
		Framework.Character.physics.Velocity = Vector3.new()
		Framework.Character:changeState("None")
		Framework.Character.lookAt = -self.startCF.lookVector
		Framework.Character.anim = "Collect"
		Framework.Character.animSpeed = 1
		self.object.CFrame = self.startCF + Vector3.new(0,2,0)
		Framework.Sounds:play("MajorCollect")
		wait(.5)
		game:GetService("TweenService"):Create(self.object, TweenInfo.new(1), {
			CFrame = self.startCF + Vector3.new(0,3,0)
		}):Play()
		wait(2)
		Label:TweenPosition(UDim2.new(0,0,1,0),"InOut","Quad",.5,true)
		wait(.5)
		Framework.Character.anim = nil
		Framework.Character.animSpeed = nil
		Framework.Character.physics.Anchored = false
		Framework.Character.lookAt = self.startCF.lookVector
		workspace.CurrentCamera.CameraType = "Custom"
		
		Framework.InputController.canInput:sub(1)
		Framework.InputController.canPause:sub(1)
		
		self:destroy()
	end
end

 -- make Collect:collect(), Collect:isCollected()

Collect:construct("Collect", function(newCollect, object)
	newCollect.startCF = object.CFrame
	newCollect.object = object
	newCollect.objects[object] = newCollect
	object.Parent = workspace.Classes
	object.Transparency = 1
	for i,v in next, object:GetChildren() do
		if v:IsA("BasePart") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
			local C1 = object.CFrame:inverse() * v.CFrame
			local W = Instance.new("Weld")
			W.Parent = v
			W.Part0 = v
			W.Part1 = object
			W.C1 = C1
			v.Anchored = false
		end
	end
	newCollect:setParent(Framework.RangedClasses)
end)

return Collect