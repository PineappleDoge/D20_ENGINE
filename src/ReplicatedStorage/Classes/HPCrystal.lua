local Framework = shared.Framework

local HPCrystal = shared.Class:new()
HPCrystal.objects = {}
HPCrystal.creators = {}
HPCrystal.object = nil
HPCrystal.created = nil
HPCrystal.collected = false
HPCrystal.lastUpdated = 0

function HPCrystal:collect()
	local Util = Framework.Util
	if not self.collected and Framework.Character.health < 4 then
		Framework.Character:heal(1)
		Framework.Character.physics.Attachment.Flash:Emit(1)
		self.collected = true
	end
end

function HPCrystal:getPosition()
	return self.object.Position
end

function HPCrystal:update(dt)
	self.object.CFrame = self.object.CFrame * CFrame.Angles(0,dt * 2 * math.pi,0)
	self.object.Transparency = (self.collected and .75 or 0)
end

function HPCrystal:isObject(inst)
	return inst.Name:sub(1,9) == "HPCrystal"
end

function HPCrystal:Destroy()
	self.object:Destroy()
end

HPCrystal:construct("HPCrystal", function(newHPCrystal, inst)
	local object = game.ReplicatedStorage.Assets.HPCrystal:Clone()
	object.CFrame = inst.CFrame
	object.Parent = workspace.Classes
	
	newHPCrystal:setName(object.Name)
	newHPCrystal.object = object
	newHPCrystal.objects[object] = newHPCrystal
	newHPCrystal.created = inst
	newHPCrystal.creators[inst] = newHPCrystal
	newHPCrystal:setParent(Framework.RangedClasses)
	
	object.AncestryChanged:connect(function()
		if not object:IsDescendantOf(game) then
			newHPCrystal:destroy()
		end
	end)
	
	inst.Transparency = 1
	
	Framework:onEvent("loadCharacter", newHPCrystal, function()
		newHPCrystal.collected = false
		newHPCrystal.object.Transparency = 0
	end)
end)

return HPCrystal