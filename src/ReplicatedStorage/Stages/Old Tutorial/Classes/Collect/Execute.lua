local Framework = shared.Framework

local Move = "Dive"
local Number = 1

return function(Collect)
	local enum = Framework.Enums.Moves[Move]
	script.Parent.M.Color = enum.color:lerp(Color3.new(1,1,1), .25)
	script.Parent.O.Color = enum.color
	script.Parent.O.Attachment.ParticleEmitter.Color = ColorSequence.new(enum.color)
	
	function Collect:collect()
		Framework.localPlayer:invokeNet("awardMove",Move)
	end
	
	function Collect:isCollected()
		return Framework.localPlayer.Moves[Move]
	end

	Collect.text = "the "..Move.." Special Move!"
end