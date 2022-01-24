local Framework = shared.Framework
local Util = Framework.Util

return function()
	local Menu = shared.Class:new()
	
	local Camera = Instance.new("Camera")
	Camera.CFrame = CFrame.new(Vector3.new(-2.5,0,0),Vector3.new(0,0,0))
	
	local function newMenu(v)
		local moveEnum = Framework.Enums.Moves[v.name]
		
		local MenuItem = shared.Class:create("MenuItem")
		MenuItem.itemName = moveEnum.name
		MenuItem.desc = moveEnum.description
		MenuItem.camera = Camera
		
		local move = moveEnum.object:Clone()
		for i,v in next, move:GetChildren() do
			v.Transparency = v.Transparency/2
		end
		MenuItem.display = move
		MenuItem.secondDisplay = true
		
		MenuItem.func = function()
			Framework.localPlayer:invokeNet("setMove", moveEnum.name)
		end
		
		return MenuItem
	end
	
	local moves = Framework.localPlayer.Moves:getChildren()
	table.sort(moves, function(a,b)
		return a.name <= b.name
	end)
	local selection
	for i,v in next, moves do
		local menuItem = newMenu(v)
		menuItem:setParent(Menu)
		if v.name == Framework.localPlayer.Data.move then
			Menu.defaultSelection = i
		end
	end
	
	return Menu
end