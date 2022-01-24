local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.count = 0
State.doAnim = false

function State:start(character)
	Framework.Sounds:play("Jump")
	character.physics.CFrame = character.physics.CFrame + Vector3.new(0,1,0)Vector3.new(0,1,0)
	character:boost(character.jump * 2/3)
	self.count = self.count + 1
	local count = self.count
	character.charAnim = "Flip"
	character.charAnimSpeed = 1
	self.doAnim = false
	character:flash()
	local Util = Framework.Util
	for i = 1,5 do
		local vel = Util.Vectors:hor(character.physics.Velocity/4) + Vector3.new(math.random() * 10 - 5,-math.random() * character.jump/2,math.random() * 10 - 5)
		shared.Class:create("Dust",nil,vel)
	end
	coroutine.wrap(function()
		wait(.3)
		if self.count == count and character.state == script.Name then
			self.doAnim = true
		end
	end)()
end

function State:update(dt, character)
	character:addForce(character.addVel, character.input * character.speed, 15)
	if self.doAnim then
		character.charAnimSpeed = 1
		character.charAnim = character:jumpAnim()
	end
	character.trailEnabled = false
end

function State:stop(character)
	
end

return State