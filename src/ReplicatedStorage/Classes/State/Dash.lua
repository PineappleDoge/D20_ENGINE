local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.connection = nil

function State:start(character)
	Framework.Sounds:play("Whoosh")
	character:boost(5)
	character:boostSpeed(character.speed, character.speed)
	character:flash()
	local Util = Framework.Util
	local rotate = CFrame.new(Vector3.new(),character.lookAt)
	for i = 1,5 do
		local vel = Vector3.new(math.random() * 10 - 5,math.random() * 10 - 5,0)
		vel = Util.Vectors:rotateVector(vel, rotate) - character.lookAt * math.random() * 5
		shared.Class:create("Dust",nil,vel)
	end
end

function State:update(dt, character)
	character.charAnim = character:jumpAnim()
	character.charAnimSpeed = 1
	character.tiltMod = .5
	character:addForce(character.addVel, character.lookAt * character.speed, 15)
	character.trailEnabled = true
end

function State:stop(character)
	character.charAnim = ""
	if self.connection then
		self.connection:disconnect()
	end
end

return State