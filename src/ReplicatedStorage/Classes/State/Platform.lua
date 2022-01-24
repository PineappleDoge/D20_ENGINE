local Framework = shared.Framework

local State = shared.Class:create("State")
State:setName(script.Name)
State:setParent(Framework.States)
State.count = 0

function State:start(character)
	Framework.Sounds:play("Special")
	self.count = self.count + 1
	local platform = game.ReplicatedStorage.Assets.Platform:Clone()
	platform.Parent = workspace.CurrentCamera
	platform.Name = "_Platform"
	platform.CFrame = CFrame.new(character.physics.Position - Vector3.new(0,1.625,0))
	if math.fmod(self.count, 2) == 1 then
		platform.Color = Framework.localPlayer.primary
	else
		platform.Color = Framework.localPlayer.secondary
	end
	character:flash()
	local Util = Framework.Util
	for i = 1,5 do
		local vel = Util.Vectors:hor(character.physics.Velocity/4) + Vector3.new(math.random() * 10 - 5,math.random() * 5,math.random() * 10 - 5)
		shared.Class:create("Dust",nil,vel)
	end
	coroutine.wrap(function()
		local t = 0
		local velocity = Vector3.new()
		repeat
			local dt = Framework.Util.Time:wait()
			t = t + dt
			platform.Transparency = .5 + math.clamp(-4 + t,0,1)/2
			local cf = platform.CFrame
			platform.Size = game.ReplicatedStorage.Assets.Platform.Size * math.clamp((5 - t)/10 + .5,.5,1)
			platform.CFrame = CFrame.new(cf.p) * CFrame.Angles(0,dt * 2 * math.pi,0) * Framework.Util.CFrames:getRot(cf)
	
			--wind implementation
			local gotVel = Vector3.new()
			for i,v in next, shared.Class:get("Wind").objects do
				if v.enabled and Framework.Util.Vectors:isColliding(i,platform.Position) then
					gotVel = gotVel + i.Velocity
				end
			end
			velocity = velocity:lerp(gotVel,Framework.Util.Numbers:invLerp(.1,1/30,dt))
			platform.CFrame = platform.CFrame + velocity * dt
			platform.Velocity = velocity
		until t > 5
		platform:Destroy()
	end)()
end

function State:update(dt, character)
	character.charAnim = character:jumpAnim()
	character.charAnimSpeed = 1
	character:addForce(character.addVel, character.input * character.speed, 15)
	character.trailEnabled = false
end

function State:stop(character)
	
end

return State