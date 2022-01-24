local Framework = shared.Framework

local Spawner = shared.Class:new()
Spawner.object = nil
Spawner.objects = {}
Spawner.classes = {}
Spawner.max = 5
Spawner.cooldown = 1
Spawner.rate = 1
Spawner.lastSpawn = 0
Spawner.lastUpdated = 0
Spawner.enabled = true

function Spawner:update(dt)
	if self.enabled then
		for i,v in next, self.classes do
			if v.destroyed then
				table.remove(self.classes, i)
			end
		end
		if #self.classes < self.max then
			self.lastSpawn = self.lastSpawn + dt
			if self.lastSpawn >= self.cooldown then
				self.lastSpawn = self.lastSpawn - self.cooldown
				self:emit(self.rate, true)
			end
		end
	end
end

function Spawner:spawn()
	--custom function
end

function Spawner:enable()
	self.enabled = true
end

function Spawner:disable()
	self.enabled = false
end

function Spawner:emit(n, respectMax)
	n = n or 1
	for i = 1,n do
		if not respectMax or #self.classes < self.max then
			self.classes[#self.classes + 1] = self:spawn()
		end
	end
end

function Spawner:isObject(inst)
	return inst.Name == "Spawner"
end

function Spawner:Destroy()
	self.object:Destroy()
end

function Spawner:getPosition()
	return self.object.Position
end

Spawner:construct("Spawner", function(newSpawner, object)
	newSpawner.classes = {}
	newSpawner.object = object
	newSpawner.objects[object] = newSpawner
	newSpawner:setParent(Framework.RangedClasses)
	object.Parent = workspace.Classes
end)

return Spawner