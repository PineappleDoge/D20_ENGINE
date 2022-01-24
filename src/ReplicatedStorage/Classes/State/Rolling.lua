local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.rootOffset = game.ReplicatedStorage.Assets.Character.Head.CFrame:inverse() * game.ReplicatedStorage.Assets.Character.Root.CFrame
State.lastDust = 0

function State:start(character)
	local Util = Framework.Util
	character.charAnim = "Roll"
	character.physics.RotVelocity = Vector3.new()
	character.physics.CFrame = CFrame.new(character.physics.Position) * Util.CFrames:getRot(character.character.Head.CFrame)
end

function State:update(dt, character)
	local Util = Framework.Util
	
	local timeSinceBoost = math.clamp((tick() - character.lastRollBoost) * 5,0,1)
	local heightMod = -4 * timeSinceBoost^2 + 4 * timeSinceBoost
	character.character.Root.CFrame = character.physics.CFrame * self.rootOffset + Vector3.new(0,heightMod/4,0)
		+ Vector3.new(math.random()/1000 - 1/2000,math.random()/1000 - 1/2000,math.random()/1000 - 1/2000)
	
	if character.floor and not character:isFloorSlippery(0) then
		character:addForce(character.addVel, character.input * character.speed * 1.25, 15, (character:isFloorSlippery(.5) and 0 or .25))
		if character.physics.Velocity.magnitude > 5 and tick() - .2 >= self.lastDust then
			self.lastDust = tick()
			local vel = -character.physics.Velocity/4 + Vector3.new(math.random() * 10 - 5,0,math.random() * 10 - 5)
			vel = Util.Vectors:hor(vel,Util.Planes:solveFor("Y",character.normal,Vector3.new(),vel) + math.random() * 2)
			shared.Class:create("Dust",nil,vel)
		end
	end
	character.trailEnabled = true
end

function State:stop(character)
	character.charAnim = ""
end

return State