local Framework = shared.Framework

local Tightrope = shared.Class:new()
Tightrope.objects = {}
Tightrope.start = nil
Tightrope.stop = nil
Tightrope.middle = nil
Tightrope.hitbox = nil
Tightrope.hitboxes = {}
Tightrope.stretch = 1

function Tightrope:update(dt)
	
end

function Tightrope:isObject(inst)
	return inst.Name:sub(1,9) == "Tightrope"
end

function Tightrope:Destroy()
	self.start:Destroy()
end

function Tightrope:getMagnitude(vector, start, stop)
	local fUnit = (stop - start).Unit
	if (fUnit - (vector - start).Unit).magnitude > 1 then
		return -(vector - start).magnitude
	else
		return (vector - start).magnitude
	end
end

function Tightrope:getPos(pos)
	local Util = Framework.Util
	
	local start = Util.Vectors:hor(self.start.Position)
	local stop = Util.Vectors:hor(self.stop.Position)
	local closest = Util.Lines:getClosestPoint(start, stop, pos)
	
	return self:getMagnitude(closest, start, stop)/self:getMagnitude(stop, start, stop)
end
function Tightrope:invPos(pos)
	local Util = Framework.Util
	
	local start = self.start.Position
	local stop = self.stop.Position
	
	return start:lerp(stop, pos)
end
function Tightrope:fixPos(pos)
	return self:invPos(self:getPos(pos))
end
function Tightrope:reset()
	local start = self.start.Position
	local stop = self.stop.Position
	
	self.tween = game:GetService("TweenService"):Create(self.middle,TweenInfo.new(.5),{
		CFrame = CFrame.new((start + stop)/2)
	})
	self.tween:Play()
end

Tightrope:construct("Tightrope", function(newTightrope, inst)
	inst.Transparency = 1
	inst.End.Transparency = 1
	newTightrope.objects[inst] = newTightrope
	
	local mid = inst.End:Clone()
	mid.Name = "Middle"
	mid.CFrame = CFrame.new((inst.Position + inst.End.Position)/2)
	mid.Parent = inst
	
	local hitbox = Instance.new("Part")
	hitbox.Name = "Hitbox"
	hitbox.Size = Vector3.new(1,(inst.Position - inst.End.Position).magnitude + 1,1)
	hitbox.CFrame = CFrame.new((inst.Position + inst.End.Position)/2, inst.Position) * CFrame.Angles(math.pi/2,0,0)
	hitbox.Anchored = true
	hitbox.CanCollide = false
	hitbox.Transparency = 1
	hitbox.Parent = inst
	
	local att = Instance.new("Attachment")
	att.Parent = inst
	local att2 = att:Clone()
	att2.Parent = mid
	local att3 = att:Clone()
	att3.Parent = inst.End
	
	local line = Instance.new("RodConstraint")
	line.Length = 0
	line.Visible = true
	line.Thickness = .125
	line.Attachment0 = att
	line.Attachment1 = att2
	line.Color = inst.BrickColor
	line.Parent = inst
	local line2 = line:Clone()
	line2.Attachment0 = att2
	line2.Attachment1 = att3
	line2.Color = inst.End.BrickColor
	line2.Parent = inst
	
	inst:GetPropertyChangedSignal("Position"):connect(function()
		newTightrope:reset()
		hitbox.Size = Vector3.new(1,(inst.Position - inst.End.Position).magnitude + 1,1)
		hitbox.CFrame = CFrame.new((inst.Position + inst.End.Position)/2, inst.Position) * CFrame.Angles(math.pi/2,0,0)
	end)
	inst.End:GetPropertyChangedSignal("Position"):connect(function()
		newTightrope:reset()
		hitbox.Size = Vector3.new(1,(inst.Position - inst.End.Position).magnitude + 1,1)
		hitbox.CFrame = CFrame.new((inst.Position + inst.End.Position)/2, inst.Position) * CFrame.Angles(math.pi/2,0,0)
	end)
	
	newTightrope.start = inst
	newTightrope.stop = inst.End
	newTightrope.middle = mid
	newTightrope.hitbox = hitbox
	newTightrope.hitboxes[hitbox] = newTightrope
	newTightrope.stretch = math.sqrt((inst.End.position - inst.Position).magnitude)/4
	
	inst.AncestryChanged:connect(function()
		if not inst:IsDescendantOf(game) then
			newTightrope:destroy()
		end
	end)
end)

return Tightrope