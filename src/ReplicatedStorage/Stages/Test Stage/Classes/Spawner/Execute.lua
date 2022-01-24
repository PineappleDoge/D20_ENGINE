local Framework = shared.Framework

return function(Spawner)
	Spawner.max = 25
	Spawner.cooldown = .125
	
	function Spawner:spawn()
		local randomPos = Framework.Util.Vectors:getRandomPos(script.Parent)
		local wParticle = shared.Class:create("WindParticle", randomPos, script.Parent.CFrame.lookVector * 100, 1)
		return wParticle
	end
end