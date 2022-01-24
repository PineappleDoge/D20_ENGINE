local Framework = shared.Framework
local Util, Sounds

local Character = shared.Class:new()
Character:setName("Character")
Character.physics = nil
Character.hitbox = nil
Character.character = nil
Character.dieCollision = nil
Character.trail = nil
Character.floor = nil
Character.floorPos = nil
Character.normal = nil
Character.force = 0
Character.dtSum = 0
Character.dtCount = 0
Character.height = 1.5
Character.gravity = 120
Character.actualGravity = 0
Character.input = Vector3.new()
Character.lookAt = Vector3.new(0,0,-1)
Character.rawInput = Vector3.new()
Character.inputs = {}
Character.state = "None"
Character.addVel = Vector3.new()
Character.speed = 25
Character.jump = 35
Character.charAnim = ""
Character.charAnimSpeed = 1
Character.tiltMod = .5
Character.lastTurn = 0
Character.lastRollBoost = 0
Character.specialMoves = 0
Character.texture = "texture"
Character.minimumWalkAngle = 51 --db will start sliding down at 52
Character.health = 4
Character.healCooldown = 0
Character.hurtCooldown = 0
Character.interactGui = game.ReplicatedStorage.Assets.InteractGui
Character.interactGui.Parent = game.Players.LocalPlayer.PlayerGui
Character.interactRadius = 10
Character.interactObject = nil
Character.trailEnabled = false
Character.deathPlane = -25

function Character:Destroy()
	Framework.Character = nil
	self.physics.Parent = nil
	self.hitbox.Parent = nil
	self.character.Parent = nil
	self.dieCollision.Parent = nil
	self.trail.Parent = nil
	self.animController:destroy()
	Framework.localPlayer:fireNet("remove")
end

local FloorRays = {}
for i = 1,8 do
	local pos = Vector3.new(math.sin(i * math.pi/4),0,math.cos(i * math.pi/4))
	FloorRays[i + 1] = pos * 1/8
	FloorRays[i + 9] = pos * 1/4
	FloorRays[i + 17] = pos * 1/2
	FloorRays[i + 25] = pos
end

function Character:getFloor(dt)
	dt = dt or self.averageDT
	local Util = Framework.Util
	local mod = .005
	for _,pos in next, FloorRays do
		local ray = Ray.new(self.physics.Position + pos * .875, Vector3.new(0,-self.height - mod + math.min(0,self.physics.Velocity.Y * 1/30),0))
		self.floor, self.floorPos, self.normal = Util.Modules.Raycast(ray, self.ignoreTable, function(part, pos, normal)
			return part.CanCollide and math.deg(math.acos(normal.Y)) <= self.minimumWalkAngle
		end)
		if self.floor then
			local y = Util.Planes:solveFor("Y", self.normal, self.floorPos, self.physics.Position)
			self.floorPos = Util.Vectors:hor(self.physics.Position, y)
			return
		end
	end
end

function Character:castShadow()
	local ray = Ray.new(self.physics.Position, Vector3.new(0,-100,0))
	local floor,pos,normal = Util.Modules.Raycast(ray, self.ignoreTable, function(part, pos, normal)
		return part.CanCollide and part.Transparency <= .95
	end)
	if floor then
		local dist = (self.physics.Position - pos).magnitude
		local szm = 1.25 * dist/25 - .25
		local tm = 1.25 * dist/50 - .25
		self.shadow.Transparency = floor.Transparency + (1 - floor.Transparency) * (1 - tm)
		self.shadow.Size = Vector3.new(0,1.5,1.5) * math.clamp(szm,0,1)
		self.shadow.CFrame = CFrame.new(pos,pos + normal) * CFrame.Angles(0,math.pi/2,0)
	else
		self.shadow.Transparency = 1
	end
end

function Character:canAdjust()
	return self.state ~= "Rolling" and self.state ~= "Roulette" and self.state ~= "Dead"
end

function Character:updateVel(newVel)
	if self.floor and self:canAdjust() and self.physics.Velocity.Y - Util.Planes:solveFor("Y", self.normal, Vector3.new(), self.physics.Velocity) < 1 then
		self.physics.Velocity = Util.Vectors:hor(newVel, Util.Planes:solveFor("Y", self.normal, Vector3.new(), newVel))
	else
		self.physics.Velocity = newVel
	end
end

function Character:flash()
	self.physics.Attachment.Flash.Color = ColorSequence.new(Framework.localPlayer.primary:lerp(Color3.new(1,1,1),.5))
	self.physics.Attachment.Flash:Emit(1)
end

function Character:boost(vel)
	vel = math.sqrt(math.max(0,self.physics.velocity.Y)^2 + vel^2)
	self.physics.Velocity = Util.Vectors:hor(self.physics.velocity,vel)
end

function Character:boostSpeed(speed, add)
	self.physics.Velocity = Util.Vectors:hor(self.lookAt * (math.max(speed, Util.Vectors:hor(self.physics.Velocity).magnitude) + add), self.physics.Velocity.Y)
end

function Character:boostVelocity(addVel, includeY)
	local baseVel = self.physics.Velocity
	if not includeY then
		baseVel = Util.Vectors:hor(baseVel)
		addVel = Util.Vectors:hor(addVel)
	end
	local magnitudeSum = baseVel.magnitude + addVel.magnitude
	local vectorSum = baseVel * (baseVel.magnitude/magnitudeSum) + addVel * (addVel.magnitude/magnitudeSum)
	if not includeY then
		vectorSum = Util.Vectors:hor(vectorSum, baseVel.Y)
	end
	self.physics.Velocity = vectorSum
end

function Character:doInput(int) --1 is space, 2 is shift, 3 is e
	self.inputs[int] = true
	self:getFloor()
	if int == 1 then
		if self.state == "Swimming" then
			return
		end
		if self.state == "None" or self.state == "Tightrope" then
			if self.floor or self.state == "Tightrope" then
				self:changeState("None")
				for i = 1,5 do
					local vel = self.physics.Velocity/4 + Vector3.new(math.random() * 10 - 5,0,math.random() * 10 - 5)
					vel = Util.Vectors:hor(vel,Util.Planes:solveFor("Y",self.normal,Vector3.new(),vel) + math.random() * 5)
					shared.Class:create("Dust",nil,vel)
				end
				self.physics.CFrame = self.physics.CFrame + Vector3.new(0,1,0)
				self:boost(self.jump)
				Sounds:play("Jump")
			elseif self.addVel.Y <= 0 then
				self:changeState("DoubleJump")
			end
		elseif self.state == "WallClimb" or self.state == "WallSlide" then
			self.physics.CFrame = self.physics.CFrame + self.wallNormal
			for i = 1,5 do
				local vel = self.physics.Velocity/4 + Vector3.new(math.random() * 10 - 5,0,math.random() * 10 - 5)
				vel = vel + Vector3.new(0,math.random() * 5,0) + self.wallNormal * math.random() * 5
				shared.Class:create("Dust",nil,vel)
			end
			self.physics.Velocity = Util.Vectors:hor(self.wallNormal * self.speed,self.physics.Velocity.Y)
			self:changeState("None")
			self:boost(self.jump)
			Sounds:play("Jump")
			self.charAnim = self:jumpAnim()
		elseif self.state == "Rolling" and self.floor then
			if not self:isFloorSlippery(.25) then
				if self.rawInput.magnitude < .5 then
					self:changeState("Backflip")
				else
					self:changeState("LongJump")
				end
			end
		elseif self.state == "LongJump" or self.state == "Backflip" or self.state == "SpecialMove" and Framework.localPlayer.Data.move ~= "Platform" then
			self:changeState("Cancel")
		end
	elseif int == 2 then
		if self.state == "Swimming" then
			return
		end
		if self.state == "None" and self.floor then
			self:changeState("Rolling")
		elseif self.state ~= "Tightrope" and not self.floor and self.state ~= "Rolling" and self.state ~= "WallClimb" and self.state ~= "WallSlide" then
			if (Framework.localPlayer.Data.hat == "Dominus Messor" or self.specialMoves < Framework.localPlayer.Data.moves) and Framework.localPlayer.Data.move ~= "None" then
				self:changeState("SpecialMove", true)
			end
		end
	elseif int == 3 then
		if self.state == "Rolling" then
			--if (tick() - self.lastRollBoost >= 1/8) then -- Util.Vectors:hor(self.physics.Velocity - self.addVel).magnitude <= 2 * self.speed
				Framework.Sounds:play("Jump")
				self:updateVel(self.physics.Velocity + self.lookAt * self.speed/12)
				self.lastRollBoost = tick()
				self:flash()
				local Util = Framework.Util
				local rotate = CFrame.new(Vector3.new(),self.lookAt)
				for i = 1,5 do
					local vel = Vector3.new(math.random() * 10 - 5,math.random() * 10 - 5,0)
					vel = Util.Vectors:rotateVector(vel, rotate) - self.lookAt * math.random() * 5
					shared.Class:create("Dust",nil,vel)
				end
			--end
		elseif not self.floor and (self.state == "None" or self.state == "DoubleJump") and not self.inputs[2] and self.addVel.Y <= 0 then
			self:changeState("Roulette")
		elseif self.interactObject then
			self.interactObject:interact()
		end
	end
end

function Character:queryInput(int) --1 is space, 2 is shift, 3 is e
	if self.state == "Dead" then
		return
	end
	if int == 1 then
		if self.state == "Swimming" then
			return "Go Up"
		end
		if self.state == "None" or self.state == "Tightrope" then
			if self.floor or self.state == "Tightrope" then
				return "Jump"
			elseif self.addVel.Y <= 0 then
				return "Double Jump"
			end
		elseif self.state == "WallClimb" or self.state == "WallSlide" then
			return "Wall Jump"
		elseif self.state == "Rolling" and self.floor then
			if not self:isFloorSlippery(.25) then
				if self.rawInput.magnitude < .5 then
					return "Backflip"
				else
					return "Long Jump"
				end
			end
		elseif self.state == "LongJump" or self.state == "Backflip" or self.state == "SpecialMove" and Framework.localPlayer.Data.move ~= "Platform" then
			return "Cancel"
		end
	elseif int == 2 then
		if self.state == "Swimming" then
			return "Go Down"
		end
		if self.state == "None" and self.floor then
			return "Roll"
		elseif self.state ~= "Tightrope" and not self.floor and self.state ~= "Rolling" and self.state ~= "WallClimb" and self.state ~= "WallSlide" then
			if (Framework.localPlayer.Data.hat == "Dominus Messor" or self.specialMoves < Framework.localPlayer.Data.moves) and Framework.localPlayer.Data.move ~= "None" then
				if Framework.localPlayer.Data.hat == "Dominus Messor" or Framework.localPlayer.Data.moves - self.specialMoves == 1 then
					return Framework.localPlayer.Data.move
				else
					return Framework.localPlayer.Data.move.." x"..(Framework.localPlayer.Data.moves - self.specialMoves)
				end
			end
		end
	elseif int == 3 then
		if self.state == "Rolling" then
			if self.floor then
				return "Roll Boost"
			end
		elseif not self.floor and (self.state == "None" or self.state == "DoubleJump") and not self.inputs[2] and self.addVel.Y <= 0 then
			return "Roulette"
		elseif self.interactObject then
			return "Interact"
		end
	end
end

function Character:endInput(int) --1 is space, 2 is shift, 3 is e
	self.inputs[int] = false
	if int == 1 then
		--
	elseif int == 2 then
		if self.state == "Rolling" and self.floor and not self:isFloorSlippery(.5) then
			self:changeState("None")
		end
		if self.state == "SpecialMove" and Framework.localPlayer.Data.move == "Grapple" then
			self:changeState("Cancel")
		end
	elseif int == 3 then
		if self.state == "Roulette" then
			self:changeState("Cancel")
		end
	end
end

function Character:addForce(addVel, actualVel, power, friction)
	power = power or 10
	if (not friction) then
		friction = .15 --math.clamp(.25 + addVel.magnitude/500,0,1)
		if self.floor then
			friction = math.min(friction + .35,1)
		end
	end
	
	local charVel = Util.Vectors:hor(self.physics.Velocity)
	
	local dir = actualVel
	if dir.magnitude > 0 then
		dir = dir.Unit
	end
	local speed = actualVel.magnitude
	if self.floor and self.normal then
		speed = speed * self.normal.Y
	end
	if (charVel - addVel).magnitude > speed then
		speed = speed + ((charVel - addVel).magnitude - speed) * (1 - friction)
	end
	local addV = Util.Vectors:hor(speed * dir + addVel - charVel) * power
	addV = Util.Vectors:hor(addV, Util.Planes:solveFor("Y", self.normal, Vector3.new(), addV))
	self.force = self.force + addV
end

function Character:changeState(newState, bypass)
	if self.state ~= "Dead" and (self.state ~= newState or bypass) then
		Framework.States[self.state]:stop(self)
		self.state = newState
		Framework.States[newState]:start(self)
	end
end

local lastCamOffset = Vector3.new()
function Character:getCameraCFrame(dt)
	if self.state ~= "Dead" then
		local offset = self.physics.Velocity/40
		offset = Util.Vectors:hor(
			lastCamOffset:lerp(offset,Util.Numbers:invLerp(.375,1/30,dt)),
			lastCamOffset.Y + (offset.Y - lastCamOffset.Y) * Util.Numbers:invLerp(.2,1/30,dt)
		)
		lastCamOffset = offset
		local cf = self.physics.CFrame - offset + Vector3.new(0,(shared.zoom)/7 + .5,0)
		if cf.p.Y < self.deathPlane + 25 then
			cf = CFrame.new(Util.Vectors:hor(cf.p, (cf.p.Y - (self.deathPlane + 25))/5 + (self.deathPlane + 25)))
		end
		self.physics.CameraPart.CFrame = cf
	end
end

function Character:hitboxTouched(part)
	if part.Name:sub(1,4) == "Heal" then
		local cd = .25
		if part:FindFirstChild("Cooldown") then
			cd = part.Cooldown.Value
		end
		self:heal(tonumber(part.Name:sub(5)), cd)
	end
	if part.Name:sub(1,4) == "Hurt" or part.Name:sub(1,4) == "Harm" then
		local cd = 2
		if part:FindFirstChild("Cooldown") then
			cd = part.Cooldown.Value
		end
		self:hurt(tonumber(part.Name:sub(5)), cd)
	end
	local Die = shared.Class:get("Die").objects[part.Parent]
	if Die then
		Die:collect()
		return
	end
	local HPCrystal = shared.Class:get("HPCrystal").objects[part]
	if HPCrystal then
		HPCrystal:collect()
		return
	end
	local Teleport = shared.Class:get("Teleport").objects[part]
	if Teleport then
		Teleport:teleport()
		return
	end
	local TPZone = shared.Class:get("TPZone").objects[part]
	if TPZone then
		TPZone:teleport()
		return
	end
	local LoadingZone = shared.Class:get("LoadingZone").objects[part]
	if LoadingZone then
		LoadingZone:teleport()
		return
	end
	local TempHPCrystal = shared.Class:get("TempHPCrystal").objects[part]
	if TempHPCrystal then
		TempHPCrystal:collect()
		return
	end
	local Wall = shared.Class:get("Wall").objects[part]
	if self.state ~= "WallClimb" and Wall and not self.floor then
		local ray = Ray.new(self.physics.Position,Util.Vectors:hor(part.Position - self.physics.Position))
		local p,pos,normal = Util.Modules.Raycast(ray, self.ignoreTable, function(npart)
			return shared.Class:get("Wall").objects[npart]
		end)
		if p then
			self.wallNormal = normal
			self:changeState("WallClimb")
		end
		return
	end
	local Water = shared.Class:get("Water").objects[part]
	if Water then
		self.inWater = true
		return
	end
	local RefillOrb = shared.Class:get("RefillOrb").objects[part.Parent]
	if RefillOrb then
		RefillOrb:refill()
		return
	end
	local Tightrope = shared.Class:get("Tightrope").hitboxes[part]
	if Tightrope and self.physics.Velocity.Y <= 10 then
		if self.state ~= "Tightrope" or Framework.States.Tightrope.tightrope ~= Tightrope then
			local pos = Tightrope:getPos(self.physics.Position)
			if pos > 0 and pos < 1 then
				if Framework.States.Tightrope.tightrope ~= nil then
					Framework.States.Tightrope.tightrope:reset()
				end
				Framework.States.Tightrope.tightrope = Tightrope
				self:changeState("Tightrope")
			end
		end
		return
	end
	if self.state ~= "WallSlide" and part.CanCollide and not self.floor and self.state ~= "Roulette" then
		local ray = Ray.new(self.physics.Position,Util.Vectors:hor(part.Position - self.physics.Position))
		local p,pos,normal = Util.Modules.Raycast(ray, self.ignoreTable, function(npart)
			return npart.CanCollide
		end)
		if p and not self:isSlippery(p) and math.abs(normal.Y) <= .001 and (not self.wallNormal or (normal - self.wallNormal).magnitude > math.sqrt(2)) then
			self.wallNormal = normal
			if self.state ~= "WallSlide" then
				self:changeState("WallSlide")
			end
		end
		return
	end
	local Collect = shared.Class:get("Collect").objects[part]
	if Collect ~= nil then
		Collect:get()
		return
	end
end

function Character:jumpAnim()
	return self.physics.Velocity.Y > 0 and "Rise" or "Fall"
end

function Character:isFloorSlippery(n)
	n = n or 0
	if self.floor then
		if self.floor.CustomPhysicalProperties then
			return self.floor.CustomPhysicalProperties.Friction <= n
		end
	end
end

function Character:isSlippery(part, n)
	n = n or 0
	if part.CustomPhysicalProperties then
		return part.CustomPhysicalProperties.Friction <= n
	end
end

function Character:canPause()
	return true
end

function Character:pause()
	self.physics.Anchored = true
	self.animController:changeSpeed(0)
	self.animController.tracks.Idle:AdjustSpeed(0)
	self.physics.CFrame = CFrame.new(self.hitbox.Position + Vector3.new(0,self.height - 1.25,0))
end

function Character:unpause()
	self.physics.Anchored = false
	self.animController.tracks.Idle:AdjustSpeed(1)
end

function Character:hurt(n, cd, bypass)
	if (tick() >= self.hurtCooldown or bypass) and self.health > 0 then
		self.hurtCooldown = tick() + (cd or .25)
		self.health = math.clamp(self.health - n,0,4)
		Framework.Sounds:play("Hit")
		local hudController = Framework.HUDController
		hudController:hurt(cd)
	end
end
function Character:heal(n, cd, bypass)
	if (tick() >= self.healCooldown or bypass) and self.health < 4 and self.health > 0 then
		self.healCooldown = tick() + (cd or -1)
		self.health = math.clamp(self.health + n,0,4)
		Framework.Sounds:play("Heal")
	end
end

function Character:update(dt)
	if self.destroyed or self ~= Framework.Character then
		return
	end
	
	self.inWater = false
	for i,v in next,self.hitbox:GetTouchingParts() do
		self:hitboxTouched(v)
	end
	
	dt = math.clamp(dt,0,1)
	self.dtSum = self.dtSum + dt
	self.dtCount = self.dtCount + 1
	self.averageDT = self.dtSum/self.dtCount
	self.ignoreTable = {self.physics, self.hitbox, self.character, self.dieCollision}
	self.height = 1.55
	
	if self.floor and self.floor.RotVelocity.magnitude > 0 then
		local rv = Util.CFrames:getRVelocity(self.floor, dt)
		self.lookAt = Util.Vectors:hor((rv * CFrame.new(self.lookAt)).p).Unit
	end
	
	self.rawInput = Util.Vectors:lerpStud(self.rawInput, Framework.InputController:getMove())
	self.input = Util.Vectors:rotateVector(self.rawInput, workspace.CurrentCamera.CFrame)
	
	if self.moveTo then
		if Util.Vectors:hor(self.moveTo - self.physics.Position).magnitude > 1 then
			self.input = (self.moveTo - self.physics.Position).Unit
		end
	end
	
	self.texture = "texture"
	
	if workspace.CurrentCamera.CameraType.Name == "Fixed" then
		workspace.CurrentCamera.CameraType = "Custom"
	end
	if workspace.CurrentCamera.CameraType.Name == "Custom" then
		workspace.CurrentCamera.CameraSubject = self.physics.CameraPart
	end
	self.force = Vector3.new()
	
	if self.physics.Position.Y <= self.deathPlane then
		self:hurt(math.huge, 0, true)
	end
	if self.health <= 0 then
		self:changeState("Dead")
	end
	
	if self.destroyed or self ~= Framework.Character then
		return
	end
	
	local lastFloor = self.floor
	self:getFloor(dt)
	if self:canAdjust() and self.floor then
		self.actualGravity = 0
		self.physics.CFrame = Util.CFrames:getRot(self.physics.CFrame) + Util.Vectors:hor(self.physics.Position, self.floorPos.Y + self.height)
	else
		self.actualGravity = self.gravity
	end

	if self.inWater and self.state ~= "Dead" then
		self:changeState("Swimming")
		self.specialMoves = 0
	elseif self.state == "Swimming" then
		self:changeState("None")
	end
	
	if self.floor then
		if self.state == "SpecialMove" and Framework.localPlayer.Data.move == "Bounce" then
			self:changeState("DoubleJump")
			self.floor = nil
			local height = (Framework.States.Bounce.startHeight - self.physics.Position.Y)
			local time = math.sqrt(height * 2 / self.gravity)
			self.physics.Velocity = Util.Vectors:hor(self.physics.Velocity) + self.normal * time * self.gravity
		else
			self.addVel = Util.Vectors:getVelocity(self.floor, self.floorPos + Vector3.new(0,self.height,0))
			if self.state ~= "Dead" and (self.state ~= "Roulette" or self:isFloorSlippery(0)) and self.floor.Name ~= "_Platform" then
				self:changeState(((self.inputs[2]) or self:isFloorSlippery(.5)) and "Rolling" or "None")
			elseif self.floor.Name == "_Platform" and self.state ~= "None" and self.state ~= "Rolling" then
				self:changeState("None")
			end
			if self.floor.Name ~= "_Platform" then
				self.specialMoves = 0
			end
		end
		if self.state == "None" or self.state == "Rolling" then
			self.wallNormal = nil
		end
	else
		--push implementation
		local gotVel = Vector3.new()
		for i,v in next, shared.Class:get("Push").objects do
			if v.enabled and Framework.Util.Vectors:isColliding(i,self.physics.Position) then
				gotVel = gotVel + i.Velocity
			end
		end
		self.addVel = gotVel
		if self.addVel.Y ~= 0 then
			self.actualGravity = (self.physics.Velocity.Y - self.addVel.Y) * 3
			if self.addVel.Y > 0 and (self.state == "Cancel" or self.state == "DoubleJump") then
				self:changeState("None")
			end
		end
	end
	
	local lastLookAt = self.lookAt
	if self.input.magnitude > 0 then
		self.lookAt = self.input.Unit
	end
	if self.state == "WallClimb" then
		self.lookAt = -self.wallNormal
	end
	if self.state == "WallSlide" then
		self.lookAt = (self.wallNormal + self.input/5).Unit
	end
	self.lookAt = Util.Vectors:hor(self.lookAt).Unit
	
	local cf = self.character.Root.CFrame
	Framework.States[self.state]:update(dt, self)
	
	local fTilt = 0
	local sTilt = 0
	if self.normal.magnitude > 0 then
		fTilt = -self.normal:Dot(self.lookAt)
		sTilt = self.normal:Dot(Util.Vectors:rot90(self.lookAt))
	else
		fTilt = math.atan2(self.physics.Velocity.Y,math.max(15,Util.Vectors:hor(self.physics.Velocity).magnitude)) * self.tiltMod
	end
	
	local turn = -self.lookAt:Cross(lastLookAt).Y
	turn = self.lastTurn + (turn - self.lastTurn) * Util.Numbers:invLerp(.1,1/60,dt)
	self.lastTurn = turn
	
	if self.character.Root.CFrame == cf then
		local cpos = self.physics.Position - Vector3.new(0,.2,0)
		if self.floor then
			local floorPos = Util.Vectors:hor(self.physics.Position - self.normal * 1.5, Util.Planes:solveFor("Y",self.normal,self.floorPos,self.physics.Position - self.normal * 1.5))
			cpos = floorPos + self.normal * 1.35
		end
		local lookAt = self.lookAt
		--if os.date("*t").wday == 4 and self.state == "LongJump" and self.BLJ then
		--	lookAt = -lookAt
		--end
		self.character.Root.CFrame = Util.CFrames:lerpRotation(self.character.Root.CFrame,
			CFrame.new(cpos) *
				CFrame.new(Vector3.new(),lookAt) *
				CFrame.new(-.01,-.11,0) *
				CFrame.Angles(fTilt,0,sTilt + turn) *
				CFrame.Angles(-math.pi/2,-math.pi/2,0),
			Util.Numbers:invLerp(.25,1/60,dt)
		)
	end
	self.hitbox.CFrame = CFrame.new(self.physics.Position - Vector3.new(0,self.height - 1.25,0)) * CFrame.Angles(0,0,math.pi/2)
		+ Vector3.new(math.random()/1000 - 1/2000,math.random()/1000 - 1/2000,math.random()/1000 - 1/2000) --jitter helps hitbox collision run every frame
	
	local interactObjects = Util.Class:getObjectsInRadius(shared.Class:get("Object").interacts, self.physics.Position, self.interactRadius)
	table.sort(interactObjects, function(a,b)
		return (a:getPosition() - self.physics.Position).magnitude < (b:getPosition() - self.physics.Position).magnitude
	end)
	self.interactObject = nil
	for i = 1,#interactObjects do
		local v = interactObjects[i]
		if v.interactPart and v.canInteract and v:canInteract() then
			self.interactObject = v
			break
		end
	end
	if self.interactObject then
		self.interactGui.Size = self.interactGui.Size:lerp(UDim2.new(2,0,2,0), Util.Numbers:invLerp(.25,1/60,dt))
		self.interactGui.StudsOffset = self.interactGui.StudsOffset:lerp(Vector3.new(0,1,0), Util.Numbers:invLerp(.25,1/60,dt))
		self.interactGui.Adornee = self.interactObject.interactPart
		self.interactGui.ImageLabel.ImageColor3 = Framework.localPlayer.primary
		self.interactGui.Triangle.ImageColor3 = Framework.localPlayer.primary
		self.interactGui.TextLabel.TextColor3 = Framework.localPlayer.secondary
		self.interactGui.TextLabel.TextStrokeColor3 = Util.Colors:shadow(Framework.localPlayer.primary, Framework.localPlayer.secondary)
		self.interactGui.TextLabel.Text = Framework.InputController.console and "X" or "E"
		self.interactGui.Enabled = true
	else
		self.interactGui.Size = self.interactGui.Size:lerp(UDim2.new(), Util.Numbers:invLerp(.25,1/60,dt))
		self.interactGui.StudsOffset = self.interactGui.StudsOffset:lerp(Vector3.new(), Util.Numbers:invLerp(.25,1/60,dt))
	end
	
	local touchObjects = Util.Class:getObjectsInRadius(shared.Class:get("Object").touches, self.physics.Position, 1, true)
	for i = 1,#touchObjects do
		local v = touchObjects[i]
		v.lastTouched = Framework.ClientController.frame
		if not v.entered then
			v.entered = true
			v:enter()
		end
		v:touch(dt)
		coroutine.wrap(function()
			Framework.Util.Time:wait(.1)
			if v.entered and Framework.ClientController.frame > v.lastTouched then
				v.entered = false
				v:exit()
			end
		end)()
	end
	
	self.character.Head.Face.ImageLabel.ImageRectOffset = Vector2.new()
	
	Util.Characters:applySkin(self.character, Framework.localPlayer.Data.skin, self.texture, Framework.localPlayer)
	Util.Characters:applyHat(self.character, Framework.localPlayer.Data.hat, self.texture)
	Util.Characters:setTag(self.character, Framework.localPlayer.playerName, Framework.localPlayer.tag, Framework.localPlayer.tagColor)
	self.animController:update(self.anim or self.charAnim, self.animSpeed or self.charAnimSpeed)
	
	self.force = self.force - Vector3.new(0, self.actualGravity * self.physics:GetMass(), 0)
	self.physics.BodyForce.Force = self.force
	
	shared.zoom = shared.zoom or 8
	if self.hidden or shared.zoom <= 1.25 and workspace.CurrentCamera.CameraType.Name ~= "Scriptable" and self.physics.Position.Y > -2 then
		Util.Characters:setTransparency(self.character, 1)
		self.trailEnabled = false
		self.physics.Attachment.Flash.Transparency = NumberSequence.new(1)
		self.hideCharacter = true
	else
		Util.Characters:setTransparency(self.character, 0)
		self.physics.Attachment.Flash.Transparency = NumberSequence.new(.5,1)
		self.hideCharacter = false
	end
	self.character.Head.Nametag.Enabled = not Framework.menu
	
	if self.trailEnabled then
		self.trail.CFrame = CFrame.new(self.physics.Position, self.physics.Position + self.physics.Velocity)
		self.trail.Trail.Color = ColorSequence.new(Framework.localPlayer.secondary:lerp(Color3.new(1,1,1),.5))
		self.trail.Trail.Enabled = true
	else
		self.trail.Trail.Enabled = false
	end
	
	self:castShadow()
	self:updateVel(self.physics.Velocity)
	self:getCameraCFrame(dt)
end

Character:construct("LocalCharacter", function(newChar)
	Util = Framework.Util
	Sounds = Framework.Sounds
	if Framework.Character then
		Framework.Character:destroy()
	end
	newChar:setParent(Framework)
	
	newChar.inputs = {}
	newChar.physics = game.ReplicatedStorage.Assets.Physics:Clone()
	newChar.hitbox = game.ReplicatedStorage.Assets.Hitbox:Clone()
	newChar.character = game.ReplicatedStorage.Assets.Character:Clone()
	newChar.dieCollision = game.ReplicatedStorage.Assets.DieCollision:Clone()
	newChar.trail = game.ReplicatedStorage.Assets.Trail:Clone()
	newChar.shadow = game.ReplicatedStorage.Assets.Shadow:Clone()
	newChar.physics.Parent = workspace.CurrentCamera
	newChar.hitbox.Parent = workspace.CurrentCamera
	newChar.character.Parent = workspace.CurrentCamera
	newChar.dieCollision.Parent = newChar.character
	newChar.trail.Parent = workspace.CurrentCamera
	newChar.shadow.Parent = workspace.CurrentCamera
	
	newChar.dieCollision.Touched:connect(function(part)
		if newChar.state == "Roulette" and part ~= newChar.physics and part ~= newChar.shadow and part ~= newChar.hitbox and part ~= newChar.physics.CameraPart and not part:isDescendantOf(newChar.character) then
			Framework.Sounds:play("DiceHit")
		end
	end)
	
	newChar.animController = shared.Class:create("AnimationController", newChar.character.AnimationController)
	newChar.animController.tracks.Run:GetMarkerReachedSignal("Step"):connect(function()
		Framework.Sounds:play("Step")
		local vel = -newChar.physics.Velocity/4 + Vector3.new(math.random() * 10 - 5,0,math.random() * 10 - 5)
		vel = Util.Vectors:hor(vel,Util.Planes:solveFor("Y",newChar.normal,Vector3.new(),vel) + math.random() * 2)
		shared.Class:create("Dust",nil,vel)
	end)
	
	newChar.hitbox.Touched:connect(function()
		-- this is only here so the TouchInterest is created
	end)
	
	newChar.physics.AncestryChanged:connect(function()
		if not newChar.physics:IsDescendantOf(workspace) then
			newChar:destroy()
		end
	end)
	
	newChar.physics:GetPropertyChangedSignal("Velocity"):connect(function()
		newChar:updateVel(newChar.physics.Velocity)
	end)
	
	coroutine.wrap(function()
		while not newChar.destroyed do
			if Framework.localPlayer.Data.hideMe then
				Framework.localPlayer:fireNet("update",newChar.texture,CFrame.new(0,-10000,0),nil,1)
			else
				Framework.localPlayer:fireNet("update",newChar.texture,newChar.character.Root.CFrame,newChar.anim or newChar.charAnim, newChar.animSpeed or newChar.charAnimSpeed)
			end
			wait(.1)
		end
	end)()
	
	newChar:onEvent("roll", newChar, function(number)
		Framework.localPlayer:fireNet("roll", number)
	end)
	
	Framework.localPlayer.characterObject = newChar.character
	
	if shared.Class:get("Checkpoint"):getCheckpoint(Framework.checkpoint) then
		local checkpoint = shared.Class:get("Checkpoint"):getCheckpoint(Framework.checkpoint)
		newChar.physics.CFrame = CFrame.new(checkpoint.object.Position - Vector3.new(0,checkpoint.object.Size.Y/2 - 1.5,0))
		newChar.lookAt = Util.Vectors:hor(checkpoint.object.CFrame.lookVector).Unit
		workspace.CurrentCamera.CFrame = CFrame.new(checkpoint.object.Position - checkpoint.object.CFrame.lookVector * 10 + Vector3.new(0,5,0),checkpoint.object.Position)
	end
	
	Framework:fire("loadCharacter", newChar)
end)

return Character