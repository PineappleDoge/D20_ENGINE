local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.count = 0
State.connection = nil

function State:start(character)
	Framework.Sounds:play("Whoosh")
	local Util = Framework.Util
	character.physics.CFrame = character.physics.CFrame + Vector3.new(0,1.5,0)
	character:updateVel(character.addVel + (character.physics.Velocity - character.addVel) * 1.25)
	character:boost(character.jump/2 + Util.Vectors:hor(character.physics.Velocity - character.addVel).magnitude/character.speed * character.jump/4)
	character.tiltMod = 1
	self.count = self.count + 1
	local count = self.count
	character.charAnim = "LongJump"
	character.charAnimSpeed = 1
	--character.BLJ = character.rawInput.Z >= .9
	local Util = Framework.Util
	for i = 1,5 do
		local vel = character.physics.Velocity/4 + Vector3.new(math.random() * 10 - 5,0,math.random() * 10 - 5)
		vel = Util.Vectors:hor(vel,Util.Planes:solveFor("Y",character.normal,Vector3.new(),vel) + math.random() * character.jump/3)
		shared.Class:create("Dust",nil,vel)
	end
	self.connection = character.physics.Touched:connect(function(hit)
		if hit.CanCollide and not character.floor then
			character:changeState("Cancel")
		end
	end)
	coroutine.wrap(function()
		Util.Time:wait(.3)
		if self.count == count and character.state == script.Name then
			character.charAnim = "Reach"
		end
	end)()
end

function State:update(dt, character)
	character:addForce(character.addVel, character.input * character.speed * 1.25 * 1.125, 5, 0)
	character.trailEnabled = true
end

function State:stop(character)
	if self.connection then
		self.connection:disconnect()
	end
end

return State