local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.rootOffset = game.ReplicatedStorage.Assets.Character.Head.CFrame:inverse() * game.ReplicatedStorage.Assets.Character.Root.CFrame
State.timeStill = 0

State.numberVectors = {
	Vector3.new(-0.031548544764519,-0.99938082695007,-0.015576747246087),
	Vector3.new(0.31920543313026,0.68409007787704,0.65584194660187),
	Vector3.new(-0.87990367412567,-0.33498975634575,0.33697390556335),
	Vector3.new(-0.75684398412704,0.31533291935921,0.57249653339386),
	Vector3.new(0.74366009235382,-0.31720700860023,-0.58851456642151),
	Vector3.new(-0.72989070415497,0.36170172691345,-0.58002710342407),
	Vector3.new(-0.33581909537315,-0.70968228578568,-0.61933559179306),
	Vector3.new(0.36726811528206,0.7240464091301,-0.58384150266647),
	Vector3.new(0.10054738819599,-0.37467333674431,0.92168873548508),
	Vector3.new(0.87351024150848,0.33406978845596,-0.35408642888069),
	Vector3.new(0.7205810546875,-0.37728103995323,0.58174049854279),
	Vector3.new(0.86295878887177,0.32021546363831,0.39085057377815),
	Vector3.new(0.65303128957748,-0.75701588392258,-0.021841865032911),
	Vector3.new(-0.65467488765717,0.75536900758743,0.028609428554773),
	Vector3.new(0.13214907050133,-0.29358547925949,-0.9467545747757),
	Vector3.new(-0.1111910417676,0.36405301094055,-0.92471724748611),
	Vector3.new(-0.87330961227417,-0.29865455627441,-0.38488408923149),
	Vector3.new(-0.10889412462711,0.29978069663048,0.94777297973633),
	Vector3.new(-0.32370373606682,-0.77564680576324,0.54183757305145),
	Vector3.new(0.012554184533656,0.99907672405243,0.041087105870247)
}

function State:start(character)
	local Util = Framework.Util
	character.charAnim = "Roll"
	character.physics.RotVelocity = Vector3.new(math.random(-30,30),math.random(-30,30),math.random(-30,30))
	character.physics.CFrame = CFrame.new(character.physics.Position) * Util.CFrames:getRot(character.character.Head.CFrame)
	character.physics.CanCollide = false
	character.dieCollision.Anchored = false
	character.dieCollision.CanCollide = true
	character.dieCollision.CFrame = character.physics.CFrame
	character.dieCollision.Velocity = character.physics.Velocity
	local weld = Instance.new("Weld")
	weld.Parent = character.dieCollision
	weld.Part0 = character.physics
	weld.Part1 = character.dieCollision
	character.specialMoves = math.huge
	self.timeStill = 0
end

function State:update(dt, character)
	character:addForce(character.addVel, -character.physics.Velocity, 10, 0)
	character.character.Root.CFrame = character.physics.CFrame * self.rootOffset
		+ Vector3.new(math.random()/1000 - 1/2000,math.random()/1000 - 1/2000,math.random()/1000 - 1/2000)
	if (character.physics.Velocity - character.addVel).magnitude < 1 and character.floor then
		self.timeStill = self.timeStill + dt
	end
	character.texture = "texture20"
	if self.timeStill > 1 and character.normal and character.normal.magnitude > 0 then
		local vector = character.dieCollision.CFrame:toObjectSpace(CFrame.new(Vector3.new(), character.normal)).lookVector
		local closest = 1
		for i = 2,#self.numberVectors do
			local c = self.numberVectors[closest]
			local v = self.numberVectors[i]
			if (v - vector).magnitude < (c - vector).magnitude then
				closest = i
			end
		end
		character:changeState("None")
		character:send("roll", closest)
	end
	character.trailEnabled = false
end

function State:stop(character)
	character.charAnim = ""
	character.physics.CanCollide = true
	character.dieCollision.Weld:Destroy()
	character.dieCollision.Anchored = true
	character.dieCollision.CanCollide = false
end

return State