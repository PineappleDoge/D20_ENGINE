local Framework = shared.Framework

return function(Object)
	function Object:getPosition()
		return script.Parent.Position
	end
	
	function Object:enter()
		Framework.Sounds:playMusic("LavenderCanyon")
	end
	function Object:exit()
		
	end
	function Object:touch(dt)
		
	end
	
	Object:setTouch()
end