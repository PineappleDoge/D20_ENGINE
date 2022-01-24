local Framework = shared.Framework

return function(Object)
	Object.interactPart = script.Parent.Head
	
	function Object:getPosition()
		return self.interactPart.Position
	end
	
	function Object:interact()
		local dialog = Framework.DialogController
		if Framework.localPlayer.shopItem then
			local key = Framework.console and "X" or "E"
			Framework.DialogController:start({
				{"NAME", "Purple"},
				{"DIALOG",("Here are the items you can get. Double jump and hold %s to roll yourself."):format(key)}
			})
			Framework.MenuController:start("DisplayRolls")
			return
		end
		dialog:start({
			{"NAME", "Purple"},
			{"DIALOG", "Welcome to my hat and skin shop!"},
			{"DO", function()
				Framework.MenuController:start("PurpleShop")
			end}
		})
	end
	
	Framework.localPlayer:onNetEvent("roll", Object, function()
		for i,v in next, script.Parent.ShopBorders:GetChildren() do
			v.CanCollide = false
		end
	end)
	Framework.localPlayer:onEvent("shop", Object, function()
		for i,v in next, script.Parent.ShopBorders:GetChildren() do
			v.CanCollide = true
		end
	end)
	
	Object:setInteract()
	
	Object:setParent(Framework.RangedClasses)
end