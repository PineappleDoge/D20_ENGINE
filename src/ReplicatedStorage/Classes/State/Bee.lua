local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.connection = nil
State.count = 0
State.lWing = nil
State.rWing = nil --can't let you do that star fox

function State:start(character)
	Framework.Sounds:play("Whoosh")
	character:boost(0)
	character.physics.Velocity = Framework.Util.Vectors:hor(character.physics.Velocity,character.physics.Velocity * math.sqrt(.5))
	self.lWing = game.ReplicatedStorage.Assets.BeeWing:Clone()
	self.rWing = game.ReplicatedStorage.Assets.BeeWing:Clone()
	self.lWing.Parent = workspace.CurrentCamera
	self.rWing.Parent = workspace.CurrentCamera
	local w = Instance.new("Weld")
	w.Parent = self.lWing
	w.Part0 = self.lWing
	w.Part1 = character.character.Head
	w.C1 = CFrame.Angles(-math.pi/2,-math.pi/2,0):inverse() * CFrame.new(-1.25,0,0) * CFrame.Angles(0,-math.pi/2,0)
	local w = Instance.new("Weld")
	w.Parent = self.rWing
	w.Part0 = self.rWing
	w.Part1 = character.character.Head
	w.C1 = CFrame.Angles(-math.pi/2,-math.pi/2,0):inverse() * CFrame.new(1.25,0,0) * CFrame.Angles(0,math.pi/2,0)
	self.count = self.count + 1
	local count = self.count
	character:flash()
	coroutine.wrap(function()
		Framework.Util.Time:wait(.5)
		if self.count == count and character.state == "SpecialMove" then
			character:changeState("Cancel")
		end
	end)()
end

function State:update(dt, character)
	character.charAnim = "Rise"
	character.charAnimSpeed = 1
	character.tiltMod = 1
	character:addForce(character.addVel, character.input * character.speed * 4/3, 15, 0)
	character.force = character.force + Vector3.new(0,character.physics:GetMass() * (character.gravity + character.jump * math.sqrt(2)),0)
	character.trailEnabled = true
end

function State:stop(character)
	character.charAnim = ""
	self.lWing:Destroy()
	self.rWing:Destroy()
	if self.connection then
		self.connection:disconnect()
	end
end

return State