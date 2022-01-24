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
	
	local border = workspace["Dice Dock"].Classes.TPZoneLeavePurpleShop
	
	Framework.localPlayer:onNetEvent("roll", Object, function()
		border.CanCollide = false
		border.Color = Color3.new(1,1,1)
		shared.Class:get("TPZone").objects[border].enabled = true
	end)
	Framework.localPlayer:onEvent("shop", Object, function()
		border.CanCollide = true
		border.Color = Color3.new()
		shared.Class:get("TPZone").objects[border].enabled = false
	end)
	
	Object:setInteract()
	
	Object:setParent(Framework.RangedClasses)
end