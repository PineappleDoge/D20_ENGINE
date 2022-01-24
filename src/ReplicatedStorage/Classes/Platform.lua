local Framework = shared.Framework

local Platform = shared.Class:new()
Platform.object = nil
Platform.objects = {}
Platform.lastUpdated = 0
Platform.rotVel = CFrame.new()
Platform.velocity = Vector3.new()
Platform.localVel = Vector3.new()

function Platform:update(dt)
	self.object.Velocity = self.velocity +
		(Framework.Util.CFrames:getRot(self.object.CFrame) * CFrame.new(self.localVel)).p/2 +
		(Framework.Util.CFrames:getRot(self.object.CFrame) * CFrame.new():lerp(self.rotVel,dt) * CFrame.new(self.localVel)).p/2
	self.object.CFrame = self.object.CFrame * CFrame.new():lerp(self.rotVel,dt) + (self.object.Velocity * dt)
	for i,v in next, self.object:GetChildren() do
		if v.Name ~= "WorldVelocity" and v.Name ~= "RotationSpeed" and v.Name ~= "LocalVelocity" and (v:IsA("BasePart") or v:IsA("UnionOperation")) then
			v.Velocity = self.object.velocity
			v.RotVelocity = self.object.RotVelocity
			v.CFrame = self.object.CFrame * v.Weld.C0
		end
	end
end

function Platform:setRotVel(cf)
	self.rotVel = cf
	local _,_,_,m00,m01,m02,_,_,m12,_,_,m22 = cf:components()
	local x = math.atan2(-m12,m22)
	local y = math.asin(m02)
	local z = math.atan2(-m01,m00)
	self.object.RotVelocity = Vector3.new(x,y,z)
end

function Platform:setVel(v3)
	self.velocity = v3
end

function Platform:setLocalVel(v3)
	self.localVel = v3
end

function Platform:Destroy()
	self.object:Destroy()
end

function Platform:getPosition()
	return self.object.Position
end

function Platform:isObject(inst)
	return inst.Name:sub(1,8) == "Platform"
end

function Platform:weld()
	for i,v in next, self.object:GetChildren() do
		if v.Name ~= "WorldVelocity" and v.Name ~= "RotationSpeed" and v.Name ~= "LocalVelocity" and (v:IsA("BasePart") or v:IsA("UnionOperation")) and not v:FindFirstChild("Weld") then
			local cfo = self.object.CFrame:inverse() * v.CFrame
			local weld = Instance.new("Weld")
			weld.Part0 = self.object
			weld.Part1 = v
			weld.C0 = cfo
			weld.Parent = v
			local objv = Instance.new("ObjectValue")
			objv.Name = "Pivot"
			objv.Value = self.object
			objv.Parent = v
		end
	end
end

Platform:construct("Platform", function(newPlatform, inst)
	newPlatform.object = inst
	newPlatform.objects[inst] = newPlatform
	
	if inst:FindFirstChild("WorldVelocity") then
		newPlatform:setLocalVel(inst.WorldVelocity.Position - inst.Position)
		inst.LocalVelocity.Transparency = 1
	end
	
	if inst:FindFirstChild("RotationSpeed") then
		newPlatform:setRotVel(inst.CFrame:inverse() * inst.RotationSpeed.CFrame)
		inst.RotationSpeed.Transparency = 1
	end
	
	if inst:FindFirstChild("LocalVelocity") then
		newPlatform:setLocalVel((inst.CFrame:inverse() * inst.LocalVelocity.CFrame).p)
		inst.LocalVelocity.Transparency = 1
	end
	
	inst.AncestryChanged:connect(function()
		if not inst:IsDescendantOf(game) then
			newPlatform:destroy()
		end
	end)
	
	newPlatform:weld()
	newPlatform:setParent(Framework.RangedClasses)
end)

return Platform