local Framework = shared.Framework

return function()
	local menuController = Framework.MenuController
	local Menu = shared.Class:new()

	local Camera = Instance.new("Camera")
	Camera.CFrame = CFrame.new(Vector3.new(-2.5,1,0),Vector3.new(0,.5,0))

	local Camera2 = Instance.new("Camera")
	Camera2.CFrame = CFrame.new(Vector3.new(-3,2,0),Vector3.new(0,.5,0))

	local Camera3 = Instance.new("Camera")
	Camera3.CFrame = CFrame.new(Vector3.new(-2.5,0,0),Vector3.new(0,0,0))

	local MenuItem = shared.Class:create("MenuItem")
	MenuItem:setParent(Menu)
	MenuItem.itemName = "Hub"
	MenuItem.desc = "Go back to the hub if you aren't in it already."
	MenuItem.error = "There's no hub to go to here!"
	MenuItem.display = script.Arrow
	MenuItem.secondDisplay = true
	MenuItem.canUse = function()
		local stage = Framework.stage
		local stageEnum = Framework.Enums.Stages[stage]
		return stageEnum.toHub ~= nil
	end
	MenuItem.func = function()
		local stage = Framework.stage
		local stageEnum = Framework.Enums.Stages[stage]
		if stageEnum.toHub then
			Framework.ClientController:teleport(stageEnum.toHub)
		end
	end

	local MenuItem = shared.Class:create("MenuItem")
	MenuItem:setParent(Menu)
	MenuItem.itemName = "Reset"
	MenuItem.desc = "Reset your character."
	MenuItem.error = "You can't reset while shopping!"
	MenuItem.canUse = function()
		return not Framework.localPlayer.shopItem and Framework.Character.health > 0
	end
	MenuItem.func = function()
		Framework.Character:hurt(math.huge, 0, true)
	end
	local char = game.ReplicatedStorage.Assets.Character:Clone()
	Framework.Util.Characters:applySkin(char, "Neon Red", "texture20")
	char:SetPrimaryPartCFrame(CFrame.Angles(0,0,math.pi/2))
	char.LArm:Destroy()
	char.RArm:Destroy()
	char.LLeg:Destroy()
	char.RLeg:Destroy()
	MenuItem.display = char
	MenuItem.secondDisplay = true
	MenuItem.camera = Camera

	local MenuItemS = shared.Class:create("MenuItem")
	MenuItemS:setParent(Menu)
	MenuItemS.itemName = "Skins"
	MenuItemS.desc = "Select a skin to use."
	MenuItemS.func = function()
		menuController:start("Skins")
		Menu.defaultSelection = 5
		Menu:refresh()
		return 0
	end

	local MenuItemH = shared.Class:create("MenuItem")
	MenuItemH:setParent(Menu)
	MenuItemH.itemName = "Hats"
	MenuItemH.desc = "Select a hat to use."
	MenuItemH.func = function()
		menuController:start("Hats")
		Menu.defaultSelection = 6
		Menu:refresh()
		return 0
	end

	local MenuItemM = shared.Class:create("MenuItem")
	MenuItemM:setParent(Menu)
	MenuItemM.itemName = "Moves"
	MenuItemM.desc = "Select a special move to use."
	MenuItemM.error = "You can't change your special move while using one!"
	MenuItemM.canUse = function()
		return Framework.Character and Framework.Character.state ~= "SpecialMove"
	end
	MenuItemM.func = function()
		menuController:start("Moves")
		Menu.defaultSelection = 7
		Menu:refresh()
		return 0
	end

	local MenuItem = shared.Class:create("MenuItem")
	MenuItem:setParent(Menu)
	MenuItem.itemName = "Freecam"
	MenuItem.desc = "Move the camera around to take pictures! Press the Pause button again to exit."
	MenuItem.error = "You can only use this on PC!"
	MenuItem.canUse = function()
		return game:GetService("UserInputService").KeyboardEnabled
	end
	MenuItem.display = script.Camera
	MenuItem.secondDisplay = true
	MenuItem:addCamera(CFrame.new(Vector3.new(1,1,-2.5),Vector3.new()))
	MenuItem.func = function()
		Menu.defaultSelection = 3
		shared.StartFreecam()
		repeat wait() until Framework.InputController.pauseButton
		shared.StopFreecam()
		return 0
	end

	local MenuItem = shared.Class:create("MenuItem")
	MenuItem:setParent(Menu)
	MenuItem.itemName = "Settings"
	MenuItem.desc = "Change your game settings."
	MenuItem.display = script.Settings
	MenuItem.secondDisplay = true
	MenuItem.func = function()
		menuController:start("Settings")
		Menu.defaultSelection = 4
		Menu:refresh()
		return 0
	end

	local MenuItem = shared.Class:create("MenuItem")
	MenuItem:setParent(Menu)
	MenuItem.itemName = "History"
	MenuItem.desc = "Open the version history."
	MenuItem.func = function()
		menuController:start("Versions")
		Menu.defaultSelection = 10
		Menu:refresh()
		return 0
	end
	local char = game.ReplicatedStorage.Assets.Character:Clone()
	Framework.Util.Characters:applySkin(char, "Black & White", "texture20")
	char:SetPrimaryPartCFrame(CFrame.Angles(0,0,math.pi/2))
	char.LArm:Destroy()
	char.RArm:Destroy()
	char.LLeg:Destroy()
	char.RLeg:Destroy()
	MenuItem.display = char
	MenuItem.secondDisplay = true
	MenuItem.camera = Camera

	function Menu:refresh()
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

		local move = Framework.Enums.Moves[Framework.localPlayer.Data.move].object:Clone()
		for i,v in next, move:GetChildren() do
			v.Transparency = v.Transparency/2
		end
		MenuItemM.display = move
		MenuItemM.secondDisplay = true
		MenuItemM.camera = Camera3
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