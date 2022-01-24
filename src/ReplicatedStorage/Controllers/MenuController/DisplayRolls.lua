local Framework = shared.Framework
local Util = Framework.Util

return function()
	local Menu = shared.Class:new()
	
	local Camera = Instance.new("Camera")
	Camera.CFrame = CFrame.new(Vector3.new(-2.5,1,0),Vector3.new(0,.5,0))
	local Camera2 = Instance.new("Camera")
	Camera2.CFrame = CFrame.new(Vector3.new(-3,2,0),Vector3.new(0,.5,0))
	
	local function newHat(v)
		local hatEnum = Framework.Enums.Hats[v]
		
		local MenuItem = shared.Class:create("MenuItem")
		MenuItem.itemName = #Menu:getChildren() + 1
		MenuItem.desc = "Rolling a "..MenuItem.itemName..[[ will get you the "]]..v..[[" hat.]]
		MenuItem.camera = Camera2
		
		local hat = hatEnum.object
		if hat then
			hat = hat:Clone()
			hat.CFrame = CFrame.Angles(-math.pi/2,-math.pi/2,0) * hat.RotRelative.CFrame:inverse()
			for i,v in next, hat:GetChildren() do
				if v:FindFirstChild("HatOffset") then
					v.CFrame = hat.CFrame * v.HatOffset.CFrame:inverse()
				end
			end
			MenuItem.display = hat
		else
			MenuItem.display = "rbxassetid://150902481"
		end
		MenuItem.secondDisplay = true
		
		return MenuItem
	end
	
	local function newSkin(v)
		local skinEnum = Framework.Enums.Skins[v]
		
		local MenuItem = shared.Class:create("MenuItem")
		MenuItem.itemName = #Menu:getChildren() + 1
		MenuItem.desc = "Rolling a "..MenuItem.itemName..[[ will get you the "]]..v..[[" skin.]]
		MenuItem.camera = Camera
		
		local char = game.ReplicatedStorage.Assets.Character:Clone()
		Util.Characters:applySkin(char, skinEnum.name, "texture20")
		char:SetPrimaryPartCFrame(CFrame.Angles(0,0,math.pi/2))
		char.LArm:Destroy()
		char.RArm:Destroy()
		char.LLeg:Destroy()
		char.RLeg:Destroy()
		MenuItem.display = char
		MenuItem.secondDisplay = true
		
		return MenuItem
	end
	
	local items = Framework.localPlayer.RollItems:getChildren()
	table.sort(items, function(a,b)
		return tonumber(a.name) <= tonumber(b.name)
	end)
	for i,v in next, items do
		if v.type == "Hat" then
			local menuItem = newHat(v.item)
			menuItem:setParent(Menu)
		elseif v.type == "Skin" then
			local menuItem = newSkin(v.item)
			menuItem:setParent(Menu)
		end
	end
	
	coroutine.wrap(function()
		while not Menu.destroyed do
			local dt = game:GetService("RunService").RenderStepped:wait()
			Camera.CFrame = CFrame.Angles(0,dt,0) * Camera.CFrame
			Camera2.CFrame = CFrame.Angles(0,dt,0) * Camera2.CFrame
		end
	end)()
	
	if #Menu:getChildren() == 0 then
		local menuItem = newHat("Question Mark")
		menuItem.itemName = "N/A"
		menuItem.desc = "You can't get any items from this pack!"
		menuItem:setParent(Menu)
	end
	
	return Menu
end