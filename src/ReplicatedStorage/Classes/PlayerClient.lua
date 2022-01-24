local Framework = shared.Framework

local Player = shared.Class:new()
Player:setName("Player")
Player.object = nil
Player.cframe = CFrame.new(0,10,0)
Player.animation = "idle"
Player.animationStart = 0
Player.tag = nil
Player.tagColor = Color3.new(1,1,1)
Player.skin = "B&W"
Player.hat = "None"
Player.move = "None"
Player.admin = false
Player.tester = false
Player.characterObject = nil

function Player:Destroy()
	if self.replicator then
		self.replicator:destroy()
	end
end

Player:construct("Player", function(newPlayer)
	newPlayer:onNetEvent("roll", newPlayer, function(number)
		if newPlayer.characterObject then
			Framework.Util.Characters:rollNumber(newPlayer.characterObject, number)
		end
	end)
end)

return Player