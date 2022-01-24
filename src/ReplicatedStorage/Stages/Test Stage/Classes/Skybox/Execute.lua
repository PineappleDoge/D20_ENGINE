local Framework = shared.Framework

return function(Object)
	Object.smoothUpdates = true
	
	function Object:getPosition()
		return script.Parent.Position
	end
	
	function Object:update(dt)
		script.Parent.CFrame = CFrame.new(script.Parent.CFrame.p) * CFrame.Angles(0,dt * math.pi/30,0) * Framework.Util.CFrames:getRot(script.Parent.CFrame)
	end
	
	Object:setParent(Framework.RangedClasses)
end