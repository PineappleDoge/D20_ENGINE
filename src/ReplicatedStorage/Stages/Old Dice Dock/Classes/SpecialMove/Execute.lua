local Framework = shared.Framework

return function(Object)
	Object.interactPart = script.Parent.O
	
	function Object:getPosition()
		return self.interactPart.Position
	end
	
	function Object:interact()
		local menu = Framework.MenuController
		menu:start("Moves")
	end
	
	function Object:update()
		local move = Framework.Enums.Moves[Framework.localPlayer.Data.move or "None"]
		script.Parent.M.Color = move.object.M.Color
		script.Parent.O.Color = move.object.O.Color
		script.Parent.O.Attachment.ParticleEmitter.Color = move.object.O.Attachment.ParticleEmitter.Color
	end
	
	Object:setInteract()
	
	Object:setParent(Framework.Classes)
end