local Framework = shared.Framework

return function(Object)
	Object.interactPart = script.Parent.Head
	
	function Object:getPosition()
		return self.interactPart.Position
	end
	
	function Object:interact()
		local dialog = Framework.DialogController
		dialog:start({
			{"NAME", "D20"},
			{"DIALOG", "what's up gamers"},
			{"CHOOSE", {
				"choice 1",
				"choice 2",
				"choice 3",
				"test teleport"
			},{
				{{"DIALOG","you picked choice 1"}},
				{{"DIALOG","you picked choice 2"}},
				{{"DIALOG","you picked choice 3"}},
				{{"DIALOG","lol this breaks the game now"}}
			}}
		})
	end
	
	Object:setInteract()
	
	Object:setParent(Framework.RangedClasses)
	
	local AnimationController = shared.Class:create("AnimationController", script.Parent.AnimationController)
	AnimationController:update("Fortnite", 1)
	AnimationController.tracks.Fortnite.Stopped:connect(function()
		AnimationController:update("", 1)
		AnimationController:update("Fortnite", 1)
	end)
	
	function Object:pause()
		AnimationController:changeSpeed(0)
	end
	
	function Object:unpause()
		AnimationController:changeSpeed(1)
	end
end