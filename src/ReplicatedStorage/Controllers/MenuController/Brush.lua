local Framework = shared.Framework

return function()
	local menuController = Framework.MenuController
	local Menu = shared.Class:new()
	Menu.defaultSelection = 2
	
	local Camera = Instance.new("Camera")
	Camera.CFrame = CFrame.new(Vector3.new(-2.5,1,0),Vector3.new(0,.5,0))
	
	local Camera2 = Instance.new("Camera")
	Camera2.CFrame = CFrame.new(Vector3.new(-3,2,0),Vector3.new(0,.5,0))
	
	local MenuItemH = shared.Class:create("MenuItem")
	MenuItemH:setParent(Menu)
	MenuItemH.itemName = "Hats"
	MenuItemH.desc = "Select a hat to use."
	MenuItemH.func = function()
		menuController:start("Hats")
		Menu.defaultSelection = 2
		Menu:refresh()
		return 0
	end
	
	local MenuItemS = shared.Class:create("MenuItem")
	MenuItemS:setParent(Menu)
	MenuItemS.itemName = "Skins"
	MenuItemS.desc = "Select a skin to use."
	MenuItemS.func = function()
		menuController:start("Skins")
		Menu.defaultSelection = 1
		Menu:refresh()
		return 0
	end
	
	function Menu:refresh()
		local hat = Framework.Enums.Hats[Framework.localPlayer.Data.hat].object
		if hat then
			hat = hat:Clone()
			hat.CFrame = CFrame.Angles(-math.pi/2,-math.pi/2,0) * hat.RotRelative.CFrame:inverse()
			for i,v in next, hat:GetChildren() do
				if v:FindFirstChild("HatOffset") then
					v.CFrame = hat.CFrame * v.HatOffset.CFrame:inverse()
				end
			end
			MenuItemH.display = hat
			MenuItemH.camera = Camera2
		else
			MenuItemH.display = "rbxassetid://150902481"
		end
		MenuItemH.secondDisplay = true
		
		local char = game.ReplicatedStorage.Assets.Character:Clone()
		Framework.Util.Characters:applySkin(char, Framework.localPlayer.Data.skin, "texture20")
		char:SetPrimaryPartCFrame(CFrame.Angles(0,0,math.pi/2))
		char.LArm:Destroy()
		char.RArm:Destroy()
		char.LLeg:Destroy()
		char.RLeg:Destroy()
		MenuItemS.display = char
		MenuItemS.secondDisplay = true
		MenuItemS.camera = Camera
	end
	Menu:refresh()
	
	coroutine.wrap(function()
		while not Menu.destroyed do
			local dt = game:GetService("RunService").RenderStepped:wait()
			Camera.CFrame = CFrame.Angles(0,dt,0) * Camera.CFrame
			Camera2.CFrame = CFrame.Angles(0,dt,0) * Camera.CFrame
		end
	end)()
	
	return Menu
end