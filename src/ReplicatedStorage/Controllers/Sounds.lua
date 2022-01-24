local Framework = shared.Framework

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)
Controller.music = nil
Controller.musicName = nil
Controller.musicVolumeMod = 1
Controller.sfxVolumeMod = 1
Controller.customId = nil
Controller.musicLoudness = 0

Controller.tween1 = nil
Controller.tween1vol = 0
Controller.tween1inst = nil
Controller.tween2 = nil
Controller.tween2vol = .5
Controller.tween2inst = nil
Controller.sounds = {}

for i,v in next, script:GetChildren() do
	v.Parent = game.Players.LocalPlayer.PlayerGui
	Controller.sounds[v.Name] = v
	v.Name = "_"..v.Name
end

function Controller:playMusic(new, vol, ti)
	if new ~= self.musicName and self.musicName ~= "Shutdown" then
		self.musicName = new
		if self.music then
			self:tweenVol(self.music, 0, ti)
		end
		self.music = self.sounds[new]
		if self.music then
			self.music:Play()
			self.music.Volume = 0
			self.music.SoundGroup = game.ReplicatedStorage.Assets.MusicGroup
			self:tweenVol2(self.music, vol or .5, ti)
		end
	end
end

local TweenService = game:GetService("TweenService")

function Controller:tweenVol(inst, vol, ti)
	if self.tween1 and self.tween1.PlaybackState.Name == "Playing" then
		self.tween1:Cancel()
		self.tween1inst.Volume = self.tween1vol
	end
	self.tween1 = TweenService:Create(inst, TweenInfo.new(ti or 2), {
		Volume = vol
	})
	self.tween1vol = vol
	self.tween1inst = inst
	self.tween1:Play()
end
function Controller:tweenVol2(inst, vol, ti)
	if self.tween2 and self.tween2.PlaybackState.Name == "Playing" then
		self.tween2:Cancel()
		self.tween2inst.Volume = self.tween2vol
	end
	self.tween2 = TweenService:Create(inst, TweenInfo.new(ti or 2), {
		Volume = vol
	})
	self.tween2vol = vol
	self.tween2inst = inst
	self.tween2:Play()
end

function Controller:play(name)
	self.sounds[name].SoundGroup = game.ReplicatedStorage.Assets.SFXGroup
	local dupe = self.sounds[name]:Clone()
	dupe.Name = "PLAYING"
	dupe.Parent = game.Players.LocalPlayer.PlayerGui
	dupe.Looped = false
	dupe.Ended:connect(function()
		dupe:Destroy()
	end)
	dupe:Play()
end

local Util = Framework.Util

game:GetService("RunService").RenderStepped:connect(function()
	if Controller.musicName == "Shutdown" then
		Framework.localPlayer.Data.customMusic = nil --won't update and will return the sound to shutdown to keep the feel of it going
	end
	local sfxg = game.ReplicatedStorage.Assets.SFXGroup
	local mg = game.ReplicatedStorage.Assets.MusicGroup
	local mod = (Framework.localPlayer and (Framework.localPlayer.Data.muteMusic or Framework.localPlayer.Data.customMusic)) and 0 or 1
	sfxg.Volume = sfxg.Volume + (Controller.sfxVolumeMod - sfxg.Volume) * Util.Numbers:invLerp(.125,1/60,1/30)
	mg.Volume = mg.Volume + (Controller.musicVolumeMod * mod - mg.Volume) * Util.Numbers:invLerp(.125,1/60,1/30)
	Controller.sounds.Custom.Volume = Controller.sounds.Custom.Volume +
		(Controller.musicVolumeMod/2 * ((Framework.localPlayer and (Framework.localPlayer.Data.muteMusic)) and 0 or 1) - Controller.sounds.Custom.Volume) *
		Util.Numbers:invLerp(.125,1/60,1/30)
	if Framework.localPlayer and Framework.localPlayer.Data.customMusic ~= Controller.customId then
		if Framework.localPlayer.Data.customMusic then
			Controller.sounds.Custom.TimePosition = 0
			Controller.sounds.Custom.SoundId = "rbxassetid://"..Framework.localPlayer.Data.customMusic
			Controller.sounds.Custom:Play()
		else
			Controller.sounds.Custom:Stop()
		end
		Controller.customId = Framework.localPlayer.Data.customMusic
	end
	if Controller.sounds.Custom.IsPlaying then
		Controller.musicLoudness = Controller.sounds.Custom.PlaybackLoudness
	elseif Controller.music then
		Controller.musicLoudness = Controller.music.PlaybackLoudness
	end
end)

return Controller