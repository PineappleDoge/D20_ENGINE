local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.tightrope = nil

function State:start(character)
	character.charAnim = ""
	character.charAnimSpeed = 1
	character.tiltMod = .5
	self.timeStart = tick()
	self.startVel = math.max(-character.physics.Velocity.Y,0)
end

function State:update(dt, character)
	if self.tightrope.tween then
		self.tightrope.tween:Cancel()
	end
	local Util = Framework.Util
	character.actualGravity = 0
	character.charAnim = ""
	character:addForce(character.addVel, character.input * character.speed * 2/3, 50)
	character.charAnimSpeed = 1
	character.specialMoves = 0
	character.normal = self.tightrope.hitbox.CFrame.lookVector
	local vel = Util.Lines:getClosestPoint(Vector3.new(), self.tightrope.stop.Position - self.tightrope.start.Position, character.physics.Velocity - character.addVel)
	if vel.magnitude > 5 then
		character.charAnim = "TightropeRun"
		character.charAnimSpeed = vel.magnitude/9
	else
		character.charAnim = "TightropeIdle"
	end
	character.trailEnabled = false
	local getPos = self.tightrope:getPos(character.physics.Position)
	local fixPos = self.tightrope:invPos(getPos)
	if getPos < 0 or getPos > 1 then
		character:changeState("None")
	else
		local time = 4 * (tick() - self.timeStart)
		local height = -math.clamp(self.tightrope.stretch/(2 * time),0,1) * math.sin(time * 2 * math.pi)
		self.height = height
		height = (height + (4 * getPos^2 - 4 * getPos)) * self.tightrope.stretch
		fixPos = fixPos + Vector3.new(0,height,0)
		self.tightrope.middle.CFrame = CFrame.new(fixPos)
		character.physics.CFrame = CFrame.new(fixPos + Vector3.new(0,1.55,0))
		character.physics.Velocity = vel
	end
end

function State:stop(character)
	character.charAnim = ""
	character.charAnimSpeed = 1
	if self.height and self.tightrope and self.tightrope.stretch and self.height > 0 and self.tightrope.stretch > 0 then
		character:boost(self.height * self.startVel / 2)
	end
	self.tightrope:reset()
end

return State