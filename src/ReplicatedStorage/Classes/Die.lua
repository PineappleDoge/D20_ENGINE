local Framework = shared.Framework

local Die = shared.Class:new()
Die.objects = {}
Die.creators = {}
Die.amount = 1
Die.object = nil
Die.created = nil
Die.collected = false
Die.lastUpdated = 0

function Die:collect()
	local Util = Framework.Util
	if not self.collected then
		self.collected = true
		Framework.Sounds:play("Collect")
		Framework.localPlayer:fireNet("collectDie", self.amount)
		local CF = self.object.Cube.CFrame
		local size = self.object.Cube.Size
		local dotSize = self.object.Dots.Size
		local tim = 0
		coroutine.wrap(function()
			repeat
				tim = tim + Util.Time:wait() * 2
				self.object.Cube.Size = size * (1 - tim)
				self.object.Dots.Size = dotSize * (1 - tim)
				local heightMod = -6 * tim^2 + 5 * tim
				self.object.Cube.CFrame = (CF + Vector3.new(0, heightMod, 0)) * CFrame.Angles(tim * 2 * math.pi,tim * 2 * math.pi,tim * 2 * math.pi)
				self.object.Dots.CFrame = self.object.Cube.CFrame
			until tim >= 1
			self:destroy()
		end)()
	end
end

function Die:getPosition()
	return self.object.Cube.Position
end

function Die:update(dt)
	if not self.collected then
		local Util = Framework.Util
		if Framework.Character and (self.object.Cube.Position - Framework.Character.physics.Position).magnitude < 10 then
			local speed = 150/((self.object.Cube.Position - Framework.Character.physics.Position).magnitude^1.5)
			self.object.Cube.CFrame = CFrame.new(Util.Vectors:lerpStud(self.object.Cube.Position, Framework.Character.physics.Position, dt * speed)) * Util.CFrames:getRot(self.object.Cube.CFrame)
		end
		self.object.Cube.CFrame = self.object.Cube.CFrame * CFrame.Angles(dt * math.pi,dt * math.pi,dt * math.pi)
		self.object.Dots.CFrame = self.object.Cube.CFrame
	end
end

function Die:isObject(inst)
	return inst.Name:sub(1,3) == "Die"
end

function Die:Destroy()
	self.object:Destroy()
end

Die:construct("Die", function(newDie, inst)
	local object = game.ReplicatedStorage.Assets.Dice[inst.Name:sub(4)]:Clone()
	object.Cube.CFrame = CFrame.new(inst.Position)
	object.Dots.CFrame = object.Cube.CFrame
	object.Parent = workspace.Classes
	
	newDie:setName(object.Name)
	newDie.object = object
	newDie.objects[object] = newDie
	newDie.created = inst
	newDie.creators[inst] = newDie
	newDie.amount = tonumber(object.Name)
	newDie:setParent(Framework.RangedClasses)
	
	object.AncestryChanged:connect(function()
		if not object:IsDescendantOf(game) then
			newDie:destroy()
		end
	end)
	
	inst.Transparency = 1
end)

return Die