local Framework = shared.Framework

local Dust = shared.Class:new()
Dust.object = nil
Dust.velocity = nil
Dust.time = .5
Dust.cTime = 0

function Dust:update(dt)
	self.cTime = self.cTime + dt
	if self.cTime >= self.time then
		self:destroy()
	else
		local cf = self.object.CFrame
		self.object.Size = game.ReplicatedStorage.Assets.Dust.Size * self.size * (1 - self.cTime/self.time)
		local newRVel = {}
		for i,v in next, self.rotVelocity do
			newRVel[i] = v * dt
		end
		self.object.CFrame = (cf + self.velocity * dt) * CFrame.Angles(unpack(newRVel))
	end
end

function Dust:Destroy()
	self.object:Destroy()
end

Dust:construct("Dust", function(newDust, cframe, velocity, time)
	local object = game.ReplicatedStorage.Assets.Dust:Clone()
	object.Parent = workspace.Classes
	
	newDust:setName(object.Name)
	newDust.object = object
	newDust.velocity = velocity or Vector3.new()
	newDust.size = math.random() * 1.5 + .5
	newDust.rotVelocity = {math.random() * math.pi - math.pi/2,math.random() * math.pi - math.pi/2,math.random() * math.pi - math.pi/2}
	newDust.time = time or math.random()/5 + .4
	newDust:setParent(Framework.Classes)
	
	object.Size = game.ReplicatedStorage.Assets.Dust.Size * newDust.size
	local height = (Framework.Character.state == "Rolling" and 1 or 1.5)
	object.CFrame = (cframe or (Framework.Character.physics.CFrame - Vector3.new(0,height - .25,0)))
		* CFrame.Angles(math.random() * math.pi * 2 - math.pi,math.random() * math.pi * 2 - math.pi,math.random() * math.pi * 2 - math.pi)
end)

return Dust