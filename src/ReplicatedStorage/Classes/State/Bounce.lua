local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.count = 0

function State:start(character)
	Framework.Sounds:play("Whoosh")
	local Util = Framework.Util
	character.physics.Velocity = Vector3.new(0,-50,0)
	self.count = self.count + 1
	local count = self.count
	character.charAnim = "Flip"
	character.charAnimSpeed = 1
	self.startHeight = character.physics.Position.Y
	self.doAnim = false
	character:flash()
	local Util = Framework.Util
	for i = 1,5 do
		local vel = character.physics.Velocity/4 + Vector3.new(math.random() * 10 - 5,math.random() * character.jump/2,math.random() * 10 - 5)
		shared.Class:create("Dust",nil,vel)
	end
	coroutine.wrap(function()
		Util.Time:wait(.25)
		if self.count == count and character.state == script.Name then
			self.doAnim = true
		end
	end)()
end

function State:update(dt, character)
	character:addForce(character.addVel, character.input * character.speed, 15)
	if self.doAnim then
		character.charAnimSpeed = 1
		character.charAnim = "Reach"
	end
	character.trailEnabled = true
end

function State:stop(character)
	
end

return State