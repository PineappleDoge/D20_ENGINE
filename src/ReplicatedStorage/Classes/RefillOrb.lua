local Framework = shared.Framework

local RefillOrb = shared.Class:new()
RefillOrb.objects = {}
RefillOrb.creators = {}
RefillOrb.object = nil
RefillOrb.created = nil
RefillOrb.lastUpdated = 0
RefillOrb.refilled = false
RefillOrb.cooldown = 5

function RefillOrb:getPosition()
	return self.object.Position
end

local TS = game:GetService("TweenService")
function RefillOrb:refill()
	if not self.refilled and Framework.Character.specialMoves > 0 and Framework.localPlayer.Data.moves ~= math.huge then
		Framework.Character.specialMoves = 0
		if Framework.Character.state ~= "WallClimb" and Framework.Character.state ~= "WallSlide" then
			Framework.Character.wallNormal = nil
		end
		self.refilled = true
		self.object.Attachment.Flash:Emit(1)
		TS:Create(self.object, TweenInfo.new(.5), {
			Transparency = .5,
			Color = Color3.new()
		}):Play()
		TS:Create(self.object.Hitbox, TweenInfo.new(.5), {
			Transparency = 1,
			Color = Color3.new()
		}):Play()
		Framework.Util.Time:wait(self.cooldown - .5)
		TS:Create(self.object, TweenInfo.new(.5), {
			Transparency = 0,
			Color = Color3.new(0,1,0)
		}):Play()
		TS:Create(self.object.Hitbox, TweenInfo.new(.5), {
			Transparency = .95,
			Color = Color3.new(0,1,0)
		}):Play()
		Framework.Util.Time:wait(.5)
		self.refilled = false
	end
end

function RefillOrb:update(dt)
	
end

function RefillOrb:isObject(inst)
	return inst.Name:sub(1,6) == "Refill"
end

function RefillOrb:Destroy()
	self.object:Destroy()
end

RefillOrb:construct("RefillOrb", function(newRefillOrb, inst)
	inst.Transparency = 1
	
	local object = game.ReplicatedStorage.Assets.RefillOrb:Clone()
	object.Parent = workspace.Classes
	object.CFrame = inst.CFrame
	object.Hitbox.CFrame = object.CFrame
	
	newRefillOrb.object = object
	newRefillOrb.objects[object] = newRefillOrb
	newRefillOrb.created = inst
	newRefillOrb.creators[inst] = newRefillOrb
	
	object.AncestryChanged:connect(function()
		if not object:IsDescendantOf(game) then
			newRefillOrb:destroy()
		end
	end)
end)

return RefillOrb