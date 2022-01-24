local Framework = shared.Framework

return function(Object)
	Object.interactPart = script.Parent
	
	function Object:getPosition()
		return self.interactPart.Position
	end
	
	function Object:interact()
		local menu = Framework.MenuController
		menu:start("Settings")
	end
	
	function Object:update(dt)
		script.Parent.CFrame = CFrame.new(script.Parent.CFrame.p) * CFrame.Angles(0,dt * math.pi,0) * Framework.Util.CFrames:getRot(script.Parent.CFrame)
	end
	
	Object:setInteract()
	
	Object:setParent(Framework.RangedClasses)
end