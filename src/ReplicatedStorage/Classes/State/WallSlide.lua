local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.lastDust = 0

function State:start(character)
	
end

function State:update(dt, character)
	local Util = Framework.Util
	local ray = Ray.new(character.physics.Position,-character.wallNormal * 1.25)
	local p,pos,normal = Util.Modules.Raycast(ray, character.ignoreTable, function(npart)
		return npart.CanCollide
	end)
	if not p or character:isSlippery(p) or math.abs(normal.Y) > .001 then
		character:changeState("None")
	else
		character.tiltMod = .25
		character.wallNormal = normal
		local speed = Vector3.new(character.input.X/2 * character.speed,-.125 * character.gravity,character.input.Z/2 * character.speed)
		speed = speed + p.Velocity
		speed = Util.Planes:getClosestPoint(character.wallNormal, Vector3.new(), speed)
		character.actualGravity = 0
		character.force = character.force - character.wallNormal * character.physics:GetMass() * 50
			+ (speed - character.physics.Velocity) * character.physics:GetMass() * 5
		character.charAnim = "WallSlide"
		character.charAnimSpeed = math.clamp((character.physics.Velocity - p.Velocity).magnitude/10,0,1)
		if tick() - .2 >= self.lastDust then
			self.lastDust = tick()
			local vel = Util.Planes:getClosestPoint(character.wallNormal, Vector3.new(), Vector3.new(math.random() - .5,0,math.random() - .5) * 2)
			vel = vel + math.random() * character.wallNormal/2 + Vector3.new(0,2,0)
			shared.Class:create("Dust",CFrame.new(character.physics.Position - character.wallNormal - Vector3.new(0,1,0)),vel)
		end
	end
end

function State:stop(character)
	
end

return State