local Framework = shared.Framework

return function(Platform)
	local i = 0
	while true do
		i = i + 1
		local dir = math.fmod(i,2) * 10 - 5
		local newPos = script.Parent.Position + Vector3.new(0,dir * 5,0)
		Platform:setVel(Vector3.new(0,dir,0))
		Framework.Util.Time:waitObject(5, Platform)
		Platform:setVel(Vector3.new())
		Platform.CFrame = CFrame.new(newPos) * Framework.Util.CFrames:getRot(script.Parent.CFrame)
	end
end