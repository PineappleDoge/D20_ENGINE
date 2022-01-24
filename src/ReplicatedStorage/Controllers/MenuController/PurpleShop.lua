local Framework = shared.Framework

return function()
	local Menu = shared.Class:new()
	
	local Camera = Instance.new("Camera")
	Camera.CFrame = CFrame.new(Vector3.new(5,2.5,0),Vector3.new(0,.5,0))
	
	local MenuItem = shared.Class:create("MenuItem")
	MenuItem:setParent(Menu)
	MenuItem.itemName = "Purple's Skin Pack"
	MenuItem.desc = "Roll yourself to get one of the hats from Purple's Skin Pack."
	MenuItem.display = script.Skins
	MenuItem.secondDisplay = true
	MenuItem.camera = Camera
	MenuItem.cost = 1000
	MenuItem.costType = "Dice"
	MenuItem.func = function()
		local success = Framework.localPlayer:invokeNet("buyShopItem","PurpleSkinPack")[1][1]
		if success then
			Framework.localPlayer:fire("shop")
			local key = Framework.console and "X" or "E"
			Framework.DialogController:start({
				{"NAME", "Purple"},
				{"DIALOG",("Here are the items you can get. Double jump and hold %s to roll yourself."):format(key)}
			})
			Framework.MenuController:start("DisplayRolls")
		elseif success == false then
			Framework.DialogController:start({
				{"NAME", "Purple"},
				{"DIALOG","You have all the items in this pack."}
			})
		else
			Framework.DialogController:start({
				{"NAME", "Purple"},
				{"DIALOG","You don't have enough Dice for that."}
			})
		end
	end
	
	local MenuItem = shared.Class:create("MenuItem")
	MenuItem:setParent(Menu)
	MenuItem.itemName = "Purple's Hat Pack"
	MenuItem.desc = "Roll yourself to get one of the hats from Purple's Hat Pack."
	MenuItem.display = script.Hats
	MenuItem.secondDisplay = true
	MenuItem.camera = Camera
	MenuItem.cost = 1000
	MenuItem.costType = "Dice"
	MenuItem.func = function()
		local success = Framework.localPlayer:invokeNet("buyShopItem","PurpleHatPack")[1][1]
		if success then
			Framework.localPlayer:fire("shop")
			local key = Framework.console and "X" or "E"
			Framework.DialogController:start({
				{"NAME", "Purple"},
				{"DIALOG",("Here are the items you can get. Double jump and hold %s to roll yourself."):format(key)}
			})
			Framework.MenuController:start("DisplayRolls")
		elseif success == false then
			Framework.DialogController:start({
				{"NAME", "Purple"},
				{"DIALOG","You have all the items in this pack."}
			})
		else
			Framework.DialogController:start({
				{"NAME", "Purple"},
				{"DIALOG","You don't have enough Dice for that."}
			})
		end
	end
	
	return Menu
end