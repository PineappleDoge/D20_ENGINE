local Framework = shared.Framework

local Checkpoint = shared.Class:new()
Checkpoint.object = nil
Checkpoint.objects = {}
Checkpoint.checkpoints = {}

function Checkpoint:update(dt)
	if self.pad then
		local c = Color3.new()
		if Framework.checkpoint == self.name then
			c = Framework.localPlayer.primary
		end
		self.pad.Color.Color = c
	end
end

function Checkpoint:getCheckpoint(name)
	return self.checkpoints[name]
end

function Checkpoint:getPosition()
	return self.object.Position
end

function Checkpoint:isObject(inst)
	return inst.Name:sub(1,10) == "Checkpoint"
end

Checkpoint:construct("Checkpoint", function(newCheckpoint, inst)
	inst.Transparency = 1
	
	if inst:FindFirstChild("Pad") and inst.Pad.Value then
		newCheckpoint.pad = game.ReplicatedStorage.Assets.Checkpoint:Clone()
		newCheckpoint.pad.Parent = workspace.Classes
		newCheckpoint.pad:SetPrimaryPartCFrame(inst.CFrame * CFrame.new(0,-inst.Size.Y/2 + .05,0) * CFrame.Angles(0,0,-math.pi/2))
	end
	
	inst.Touched:connect(function(h)
		if h == Framework.Character.hitbox and Framework.checkpoint ~= newCheckpoint.name then
			Framework.checkpoint = newCheckpoint.name
			if inst:FindFirstChild("Place") then
				Framework.Util.Guis:showPlace(inst.Place.Value)
			end
			if newCheckpoint.pad then
				Framework.Character:heal(4)
			end
		end
	end)
	
	newCheckpoint.object = inst
	newCheckpoint.objects[inst] = newCheckpoint
	newCheckpoint:setName(inst.Name:sub(11))
	newCheckpoint.checkpoints[newCheckpoint.name] = newCheckpoint
	
	newCheckpoint:setParent(Framework.Classes)
end)

return Checkpoint