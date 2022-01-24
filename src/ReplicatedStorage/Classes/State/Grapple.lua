local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.cancel = Instance.new("BindableEvent")
State.velocity = Vector3.new()

function State:start(character)
	Framework.Sounds:play("Special")
	self.object = game.ReplicatedStorage.Assets.Grapple:Clone()
	self.object.Parent = workspace.CurrentCamera
	self.object.RopeConstraint.Length = character.speed/2
	self.object.CFrame = character.physics.CFrame + (Vector3.new(0,1,0) + character.input).Unit * character.speed/2
	self.velocity = Vector3.new()
	
	--grapplepoint implementation
	for i,v in next, shared.Class:get("GrapplePoint").objects do
		if v.enabled and (i.Position - character.physics.Position).magnitude <= character.speed then
			self.object.RopeConstraint.Length = (i.Position - character.physics.Position).magnitude
			self.object.CFrame = i.CFrame
		end
	end
	
	self.object.RopeConstraint.Attachment1 = character.physics.Attachment
	self.object.Beam.Attachment1 = character.physics.Attachment
	self.object.Color = Framework.localPlayer.primary
	self.object.Beam.Color = ColorSequence.new(Framework.localPlayer.secondary)
	character:flash()
	coroutine.wrap(function()
		local cancel
		local conn = State.cancel.Event:connect(function()
			cancel = true
		end)
		local t = 0
		repeat
			t = t + Framework.Util.Time:wait()
			State.object.Transparency = 1 - t * 4
			State.object.Beam.Transparency = NumberSequence.new(1 - t * 2,1)
		until t > .25 or cancel
		State.object.Transparency = 0
		State.object.Beam.Transparency = NumberSequence.new(.5,1)
		conn:disconnect()
	end)()
end

function State:update(dt, character)
	character.charAnimSpeed = 1
	character.charAnim = character:jumpAnim()
	character:addForce(character.addVel, character.input * character.speed * 4/3, 15, 0)
	character.trailEnabled = true
	
	--wind implementation
	local gotVel = Vector3.new()
	for i,v in next, shared.Class:get("Wind").objects do
		if v.enabled and Framework.Util.Vectors:isColliding(i,self.object.Position) then
			gotVel = gotVel + i.Velocity
		end
	end
	self.velocity = self.velocity:lerp(gotVel,Framework.Util.Numbers:invLerp(.1,1/30,dt))
	self.object.CFrame = self.object.CFrame + self.velocity * dt
end

function State:stop(character)
	self.cancel:Fire()
	if self.object then
		local obj = self.object
		obj.RopeConstraint.Length = 10000
		coroutine.wrap(function()
			local t = 0
			repeat
				t = t + Framework.Util.Time:wait()
				obj.Transparency = t * 4
				obj.Beam.Transparency = NumberSequence.new(.5 + t * 2,1)
			until t > .25
			obj:Destroy()
		end)()
	end
end

return State