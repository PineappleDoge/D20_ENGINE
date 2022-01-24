local Framework = shared.Framework

local Replicator = shared.Class:new()
Replicator.cframe = nil
Replicator.controller = nil
Replicator.anim = ""
Replicator.animSpeed = 1
Replicator.object = nil
Replicator.objects = {}
Replicator.player = nil
Replicator:setName("Replicator")

function Replicator:Destroy()
	self.object:Destroy()
	self.controller:destroy()
end

function Replicator:pause()
	self.paused = true
	self.controller.tracks.Idle:AdjustSpeed(0)
	self.controller:changeSpeed(0)
end

function Replicator:unpause()
	self.paused = false
	self.controller.tracks.Idle:AdjustSpeed(1)
end

function Replicator:update(dt)
	if (Framework.menu) then
		return
	end
	local Util = Framework.Util
	if Framework.localPlayer and self.player.Character and not self.paused then
		self.texture = "texture"
		local character = self.player:find("Character")
		if character then
			self.anim = character.anim
			self.animSpeed = character.animSpeed
			self.cframe = character.cframe
			self.texture = character.texture
		else
			self.cframe = nil
		end
		if not self.cframe or Framework.localPlayer.Data.hideChars or self.player.stage ~= Framework.localPlayer.stage then
			self.cframe = CFrame.new(0,100000,0)
		end
		Util.Characters:applySkin(self.object, self.player.Data.skin, self.texture, self.player)
		Util.Characters:applyHat(self.object, self.player.Data.hat, self.texture)
		Util.Characters:setTag(self.object, self.player.playerName, self.player.tag, self.player.tagColor)
		self.object.Root.CFrame = self.object.Root.CFrame:lerp(self.cframe,Util.Numbers:invLerp(.25,1/60,dt))
		self.controller:update(self.anim, self.animSpeed)
	end
end

Replicator:construct("Replicator", function(newRep, player)
	local object = game.ReplicatedStorage.Assets.Character:Clone()
	object.Parent = workspace.CurrentCamera
	object.Root.CFrame = CFrame.new(0,10000,0)
	
	newRep.player = player
	newRep.object = object
	newRep.objects[object] = newRep
	newRep.controller = shared.Class:create("AnimationController", object.AnimationController)
	newRep:setParent(Framework.GameClasses)
	player.characterObject = object
end)

return Replicator