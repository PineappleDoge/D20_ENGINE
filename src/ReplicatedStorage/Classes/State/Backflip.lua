local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.count = 0

function State:start(character)
	Framework.Sounds:play("Whoosh")
	local Util = Framework.Util
	character.physics.CFrame = character.physics.CFrame + Vector3.new(0,1.5,0)
	character:updateVel(character.physics.Velocity / 2)
	character:boost(character.jump * 1.5)
	character.tiltMod = .5
	self.count = self.count + 1
	local count = self.count
	character.charAnim = "Backflip"
	character.charAnimSpeed = 1
	local Util = Framework.Util
	for i = 1,5 do
		local vel = character.physics.Velocity/4 + Vector3.new(math.random() * 10 - 5,0,math.random() * 10 - 5)
		vel = Util.Vectors:hor(vel,Util.Planes:solveFor("Y",character.normal,Vector3.new(),vel) + math.random() * character.jump/2)
		shared.Class:create("Dust",nil,vel)
	end
	coroutine.wrap(function()
		Util.Time:wait(.3)
		if self.count == count and character.state == script.Name then
			character.charAnim = "BackflipLoop"
		end
	end)()
end

function State:update(dt, character)
	character:addForce(character.addVel, character.input * character.speed, 15)
	character.trailEnabled = true
end

function State:stop(character)
	
end

return State