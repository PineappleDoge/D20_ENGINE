local Framework = shared.Framework

local DieSpot = shared.Class:new()
DieSpot.objects = {}
DieSpot.object = nil
DieSpot.popped = false
DieSpot.lastUpdated = 0

function DieSpot:pop()
	if not self.popped then
		self.popped = true
		self.object.DieSpotParticle:Emit(20)
		self.object.DieSpotParticle.Enabled = false
		if self.object.Transparency == 0 then
			Framework.Sounds:play("Dig")
		end
		self.object.Transparency = 1
		self:setParent(nil)
		local dieObject = self.object:GetChildren()[1]
		local toPosition = dieObject.position
		local fromPosition = self.object.Position
		dieObject.CFrame = self.object.CFrame
		local Die = shared.Class:create("Die", dieObject)
		local cube = Die.object.Cube
		local dots = Die.object.Dots
		local Util = Framework.Util
		coroutine.wrap(function()
			local maxTime = .25 + (toPosition - fromPosition).magnitude/100
			Util.Time:renderLoop(function(t,dt)
				local constrainedTime = t/maxTime
				local addedHeight = (-4 * constrainedTime^2 + 4 * constrainedTime) * math.sqrt((toPosition - fromPosition).magnitude)
				cube.CFrame = CFrame.new(fromPosition:lerp(toPosition, constrainedTime) + Vector3.new(0,addedHeight,0)) * Util.CFrames:getRot(cube.CFrame)
				dots.CFrame = cube.CFrame
			end, maxTime)
			cube.CFrame = CFrame.new(toPosition) * Util.CFrames:getRot(cube.CFrame)
			dots.CFrame = cube.CFrame
		end)()
	end
end

function DieSpot:getPosition()
	return self.object.Position
end

function DieSpot:update(dt)
	if Framework.Character.health > 0 and (Framework.Character.physics.Position - self.object.Position).magnitude < 10 then
		self:pop()
	end
end

function DieSpot:isObject(inst)
	return inst.Name:sub(1,7) == "DieSpot"
end

function DieSpot:Destroy()
	self.object:Destroy()
end

DieSpot:construct("DieSpot", function(newDieSpot, inst)
	newDieSpot:setName(inst.Name)
	newDieSpot.object = inst
	newDieSpot.objects[inst] = newDieSpot
	newDieSpot:setParent(Framework.RangedClasses)
	
	local dieObject = inst:GetChildren()[1]
	dieObject.Transparency = 1
	
	local particle = game.ReplicatedStorage.Assets.DieSpotParticle:Clone()
	particle.Parent = inst
	particle.Color = ColorSequence.new(inst.Color)
	particle.Transparency = NumberSequence.new(inst.Transparency, 1)
	
	inst.AncestryChanged:connect(function()
		if not inst:IsDescendantOf(game) then
			newDieSpot:destroy()
		end
	end)
end)

return DieSpot