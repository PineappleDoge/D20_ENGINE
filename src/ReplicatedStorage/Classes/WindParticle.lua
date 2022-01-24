local Framework = shared.Framework

local WindParticle = shared.Class:new()
WindParticle.object = nil
WindParticle.velocity = nil
WindParticle.time = 1
WindParticle.totalTime = 0
WindParticle.velocity = Vector3.new(0,10,0)
WindParticle.lastUpdated = 0

function WindParticle:update(dt)
	self.object.CFrame = self.object.CFrame + self.velocity * dt
	self.totalTime = self.totalTime + dt
	if self.totalTime/self.time < .25 then
		self.object.Transparency = 1 + (self.transparency - 1) * (self.totalTime/self.time) * 4
	elseif self.totalTime/self.time > .75 then
		self.object.Transparency = self.transparency + (1 - self.transparency) * (self.totalTime/self.time - .75) * 4
	else
		self.object.Transparency = self.transparency
	end
	if self.totalTime >= self.time then
		self:destroy()
	end
end

function WindParticle:Destroy()
	self.object:Destroy()
end

WindParticle:construct("WindParticle", function(newWP, pos, velocity, time)
	local object = Instance.new("Part")
	object.Parent = workspace.Classes
	object.Name = "WindParticle"
	object.Material = "Neon"
	object.CanCollide = false
	object.Anchored = true
	local width = .1 + math.random() * .15
	object.Size = Vector3.new(width,velocity.magnitude * (.125 + math.random()/8),width)
	object.Transparency = 1
	object.CFrame = CFrame.new(pos) * CFrame.new(Vector3.new(),velocity) * CFrame.Angles(math.pi/2,0,0)
	
	newWP.object = object
	newWP.velocity = velocity
	newWP.time = time
	newWP.transparency = .5 + math.random()/2
	newWP:setParent(Framework.Classes)
end)

return WindParticle