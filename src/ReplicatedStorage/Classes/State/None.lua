local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)

function State:start(character)
	character.charAnim = ""
	character.charAnimSpeed = 1
	character.tiltMod = .5
end

function State:update(dt, character)
	local Util = Framework.Util
	if character.floor then
		character.charAnim = ""
		character:addForce(character.addVel, character.input * character.speed, 50)
		character.charAnimSpeed = 1
		if Util.Vectors:hor(character.physics.Velocity - character.addVel).magnitude > 5 then
			character.charAnim = "Run"
			character.charAnimSpeed = (character.physics.Velocity - character.addVel).magnitude/8
		end
	else
		character.charAnim = character:jumpAnim()
		character.charAnimSpeed = 1
		character:addForce(character.addVel, character.input * character.speed, 15)
	end
	character.trailEnabled = false
end

function State:stop(character)
	character.charAnim = ""
	character.charAnimSpeed = 1
end

return State