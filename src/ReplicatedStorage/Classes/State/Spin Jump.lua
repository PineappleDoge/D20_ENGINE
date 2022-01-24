local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.count = 0
State.doAnim = false

function State:start(character)
	Framework.Sounds:play("Whoosh")
	character.physics.CFrame = character.physics.CFrame + Vector3.new(0,1,0)
	character:boost(character.jump * 5/4)
	self.count = self.count + 1
	local count = self.count
	character.charAnim = "SJump"
	character.charAnimSpeed = 1
	self.doAnim = false
	coroutine.wrap(function()
		wait(.3)
		if self.count == count and character.state == "SpecialMove" then
			self.doAnim = true
		end
	end)()
	local Util = Framework.Util
	for i = 1,5 do
		local vel = Util.Vectors:hor(character.physics.Velocity/4) + Vector3.new(math.random() * 10 - 5,-math.random() * character.jump/2,math.random() * 10 - 5)
		shared.Class:create("Dust",nil,vel)
	end
	character:flash()
end

function State:update(dt, character)
	character:addForce(character.addVel, character.input * character.speed * 3/2, 15)
	if self.doAnim then
		character.charAnimSpeed = 1
		character.charAnim = "SJumpLoop"
	end
	character.trailEnabled = true
end

function State:stop(character)
	
end

return State