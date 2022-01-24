local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.count = 0

function State:start(character)
	character.tiltMod = 1
	character.charAnim = "Swimming"
	character.charAnimSpeed = 1
	character.wallNormal = nil
end

function State:update(dt, character)
	character.actualGravity = 0
	local vel = character.speed * (character.inputs[1] and 1 or character.inputs[2] and -1 or 0)
	character.force = character.force + Vector3.new(0,vel - character.physics.Velocity.Y) * 15 * character.physics:GetMass()
	character:addForce(character.addVel, character.input * character.speed, 15)
end

function State:stop(character)
	character.tiltMod = .5
end

return State