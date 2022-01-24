local Framework = shared.Framework

local AC = shared.Class:new()
AC.controllers = {}
AC.controller = nil
AC.tracks = {}
AC.animation = ""

function AC:changeAnimation(anim)
	if self.animation ~= anim then
		if anim == "Roll" or anim == "Die" then
			self.tracks.Idle:Stop(.1)
		else
			self.tracks.Idle:Play(.1)
		end
		if self.tracks[self.animation] then
			self.tracks[self.animation]:Stop(.1)
		end
		self.animation = anim
		if self.tracks[self.animation] then
			self.tracks[self.animation]:Play(.1)
		end
	end
end

function AC:changeSpeed(speed)
	if self.tracks[self.animation] and self.tracks[self.animation].Speed ~= speed then
		self.tracks[self.animation]:AdjustSpeed(speed)
	end
end

function AC:update(anim, speed)
	self:changeAnimation(anim)
	self:changeSpeed(speed)
end

AC:construct("AnimationController", function(newAC, controller)
	newAC.controller = controller
	newAC.controllers[controller] = newAC
	newAC.tracks = {}
	for i,v in next, game.ReplicatedStorage.Animations:GetChildren() do
		if v:IsA("Animation") then
			newAC.tracks[v.Name] = controller:LoadAnimation(v)
		end
	end
	newAC.tracks.Idle:Play(.25)
end)

return AC