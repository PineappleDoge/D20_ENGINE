local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.connection = nil

function State:start(character)
	Framework.Sounds:play("Whoosh")
	character.physics.CFrame = character.physics.CFrame + Vector3.new(0,1,0)
	character:boost(character.jump * 3/4)
	self.connection = character.physics.Touched:connect(function(hit)
		if hit.CanCollide and not character.floor then
			character:changeState("Cancel")
		end
	end)
	local Util = Framework.Util
	for i = 1,5 do
		local vel = Util.Vectors:hor(character.physics.Velocity/4) + Vector3.new(math.random() * 10 - 5,-math.random() * character.jump/3,math.random() * 10 - 5)
		shared.Class:create("Dust",nil,vel)
	end
	character.tiltMod = .5
	character:flash()
end

function State:update(dt, character)
	character.charAnim = "Spin"
	character.charAnimSpeed = math.max(.75,Framework.Util.Vectors:hor(character.physics.Velocity - character.addVel).magnitude/20)
	character:addForce(character.addVel, character.input * character.speed * 4/3, 15, 0)
	character.force = character.force + Vector3.new(0,character.physics:GetMass() * character.gravity/2,0)
	character.trailEnabled = true
end

function State:stop(character)
	character.charAnim = ""
	if self.connection then
		self.connection:disconnect()
	end
end

return State