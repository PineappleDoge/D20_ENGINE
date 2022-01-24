local Framework = shared.Framework

return function()
	local Menu = shared.Class:new()
	
	local Camera = Instance.new("Camera")
	Camera.CFrame = CFrame.new(Vector3.new(-2.5,1,0),Vector3.new(0,.5,0))
	
	local Camera2 = Instance.new("Camera")
	Camera2.CFrame = CFrame.new(Vector3.new(-2.5,0,0),Vector3.new(0,0,0))
	
	local MMenuItem = shared.Class:create("MenuItem")
	MMenuItem:setParent(Menu)
	MMenuItem.itemName = "Music"
	MMenuItem.desc = "Change the music settings."
	MMenuItem.display = script.Music
	MMenuItem.secondDisplay = true
	
	local CMenuItem = shared.Class:create("MenuItem")
	CMenuItem:setParent(Menu)
	CMenuItem.itemName = "Characters"
	CMenuItem.desc = "Change the character settings."
	CMenuItem.display = game.ReplicatedStorage.Assets.Character:Clone()
	Framework.Util.Characters:applySkin(CMenuItem.display, "Black & White", "texture20")
	CMenuItem.display:SetPrimaryPartCFrame(CFrame.Angles(0,0,math.pi/2))
	CMenuItem.display.LArm:Destroy()
	CMenuItem.display.RArm:Destroy()
	CMenuItem.display.LLeg:Destroy()
	CMenuItem.display.RLeg:Destroy()
	CMenuItem.camera = Camera
	CMenuItem.secondDisplay = true
	
	local GMenuItem = shared.Class:create("MenuItem")
	GMenuItem:setParent(Menu)
	GMenuItem.itemName = "Game"
	GMenuItem.desc = "Change the game settings."
	GMenuItem.display = Framework.Enums.Moves.None.object:Clone()
	for i,v in next, GMenuItem.display:GetChildren() do
		v.Transparency = v.Transparency/2
	end
	
	local menuItem = shared.Class:create("MenuItem")
	menuItem:setParent(Menu)
	menuItem.itemName = "Secret Codes"
	menuItem.secondDisplay = true
	menuItem.desc = "Enter in secret codes and get hidden goodies!"
	menuItem.func = function()
		local code = Framework.HUDController:getText("Enter in your secret code.")
		local ret = Framework.localPlayer:invokeNet("secretCode",code)[1][1]
		Framework.DialogController:start({
			{"DIALOG",ret}
		})
		return 0
	end
	menuItem.display = script.Settings
	menuItem.secondDisplay = true
	
	do
		local menuItem = shared.Class:create("MenuItem")
		menuItem:setParent(MMenuItem)
		menuItem.itemName = "Mute Music"
		menuItem.desc = function() return "Mute the music. This setting is "..(Framework.localPlayer.Data.muteMusic and "on." or "off.") end
		menuItem.display = script.Music:Clone()
		menuItem.display.Color = Color3.new(1,.3,.6)
		menuItem.secondDisplay = true
		menuItem.func = function()
			Framework.localPlayer:invokeNet("muteMusic")
			return 0
		end
		
		local menuItem = shared.Class:create("MenuItem")
		menuItem:setParent(MMenuItem)
		menuItem.itemName = "Custom Music"
		menuItem.desc = function()
			if Framework.localPlayer.Data.customMusic then
				return "Change the music. Your current ID is "..Framework.localPlayer.Data.customMusic.."."
			else
				return "Change the music."
			end
		end
		menuItem.display = script.Music:Clone()
		menuItem.display.Color = Color3.new(.3,1,.6)
		menuItem.secondDisplay = true
		menuItem.func = function()
			local id = Framework.HUDController:getText("Enter in your sound ID! Leave blank for no custom music.")
			Framework.localPlayer:invokeNet("customMusic", tonumber(id))
			return 0
		end
	end
	
	do
		local menuItem = shared.Class:create("MenuItem")
		menuItem:setParent(CMenuItem)
		menuItem.itemName = "Hide Characters"
		menuItem.desc = function() return "Hide other characters. This setting is "..(Framework.localPlayer.Data.hideChars and "on." or "off.") end
		menuItem.display = game.ReplicatedStorage.Assets.Character:Clone()
		menuItem.display.LArm:Destroy()
		menuItem.display.RArm:Destroy()
		menuItem.display.LLeg:Destroy()
		menuItem.display.RLeg:Destroy()
		menuItem.display:SetPrimaryPartCFrame(CFrame.Angles(0,0,math.pi/2))
		Framework.Util.Characters:applySkin(menuItem.display, "Black & White", "texture20")
		menuItem.camera = Camera
		menuItem.secondDisplay = true
		menuItem.func = function()
			Framework.localPlayer:invokeNet("hideChars")
			return 0
		end
		
		local menuItem = shared.Class:create("MenuItem")
		menuItem:setParent(CMenuItem)
		menuItem.itemName = "Hide Yourself"
		menuItem.desc = function() return "Block others from seeing you. This setting is "..(Framework.localPlayer.Data.hideMe and "on." or "off.") end
		menuItem.display = game.ReplicatedStorage.Assets.Character:Clone()
		menuItem.display.LArm:Destroy()
		menuItem.display.RArm:Destroy()
		menuItem.display.LLeg:Destroy()
		menuItem.display.RLeg:Destroy()
		menuItem.display:SetPrimaryPartCFrame(CFrame.Angles(0,0,math.pi/2))
		Framework.Util.Characters:applySkin(menuItem.display, "Purple & White", "texture20")
		menuItem.camera = Camera
		menuItem.secondDisplay = true
		menuItem.func = function()
			Framework.localPlayer:invokeNet("hideMe")
			return 0
		end
	end
	
	do
		local menuItem = shared.Class:create("MenuItem")
		menuItem:setParent(GMenuItem)
		menuItem.itemName = "Special Moves"
		menuItem.desc = function() return "Change how many Special Moves you can use in a jump.\nCurrent moves: "..Framework.localPlayer.Data.moves.."\nMax moves: "..Framework.localPlayer.Data.maxMoves end
		menuItem.display = Framework.Enums.Moves.None.object:Clone()
		for i,v in next, menuItem.display:GetChildren() do
			v.Transparency = v.Transparency/2
		end
		menuItem.secondDisplay = true
		menuItem.camera = Camera2
		menuItem.func = function()
			local n = Framework.HUDController:getText("Enter in the amount of moves you want per jump.")
			Framework.localPlayer:invokeNet("setMoves",tonumber(n))
			return 0
		end
		
		local menuItem = shared.Class:create("MenuItem")
		menuItem:setParent(GMenuItem)
		menuItem.itemName = "Skin BG"
		menuItem.desc = function()
			local color = Framework.localPlayer.Data.skinBG
			local r,g,b = color.r * 255,color.g * 255,color.b * 255
			r,g,b = string.format("%x",r),string.format("%x",g),string.format("%x",b)
			r,g,b = r:upper(),g:upper(),b:upper()
			if #r == 1 then
				r = "0"..r
			end
			if #g == 1 then
				g = "0"..g
			end
			if #b == 1 then
				b = "0"..b
			end
			return "Change the background color of the Custom Skin. Your current color is #"..r..g..b.."."
		end
		menuItem.display = game.ReplicatedStorage.Assets.Character:Clone()
		menuItem.display.LArm:Destroy()
		menuItem.display.RArm:Destroy()
		menuItem.display.LLeg:Destroy()
		menuItem.display.RLeg:Destroy()
		menuItem.display:SetPrimaryPartCFrame(CFrame.Angles(0,0,math.pi/2))
		Framework.Util.Characters:applySkin(menuItem.display, "Black & Red", "texture20")
		menuItem.camera = Camera
		menuItem.secondDisplay = true
		menuItem.func = function()
			local hex = Framework.HUDController:getText("Enter in your hex code! Format (0-F): '#RRGGBB'")
			local ret = Framework.localPlayer:invokeNet("bgColor",hex)[1][1]
			Framework.DialogController:start({
				{"DIALOG",ret}
			})
			return 0
		end
		
		local menuItem = shared.Class:create("MenuItem")
		menuItem:setParent(GMenuItem)
		menuItem.itemName = "Skin Text"
		menuItem.desc = function()
			local color = Framework.localPlayer.Data.skinFG
			local r,g,b = color.r * 255,color.g * 255,color.b * 255
			r,g,b = string.format("%x",r),string.format("%x",g),string.format("%x",b)
			r,g,b = r:upper(),g:upper(),b:upper()
			if #r == 1 then
				r = "0"..r
			end
			if #g == 1 then
				g = "0"..g
			end
			if #b == 1 then
				b = "0"..b
			end
			return "Change the text color of the Custom Skin. Your current color is #"..r..g..b.."."
		end
		menuItem.display = game.ReplicatedStorage.Assets.Character:Clone()
		menuItem.display.LArm:Destroy()
		menuItem.display.RArm:Destroy()
		menuItem.display.LLeg:Destroy()
		menuItem.display.RLeg:Destroy()
		menuItem.display:SetPrimaryPartCFrame(CFrame.Angles(0,0,math.pi/2))
		Framework.Util.Characters:applySkin(menuItem.display, "Red & White", "texture20")
		menuItem.camera = Camera
		menuItem.secondDisplay = true
		menuItem.func = function()
			local hex = Framework.HUDController:getText("Enter in your hex code! Format (0-F): '#RRGGBB'")
			local ret = Framework.localPlayer:invokeNet("textColor",hex)[1][1]
			Framework.DialogController:start({
				{"DIALOG",ret}
			})
			return 0
		end
		
		local menuItem = shared.Class:create("MenuItem")
		menuItem:setParent(GMenuItem)
		menuItem.itemName = "Face Image"
		menuItem.desc = function()
			local face = Framework.localPlayer.Data.face
			if not face then
				return "Change the face of the Custom Skin."
			end
			return "Change the face of the Custom Skin. Your current texture ID is "..face.."."
		end
		menuItem.display = game.ReplicatedStorage.Assets.Character:Clone()
		menuItem.display.LArm:Destroy()
		menuItem.display.RArm:Destroy()
		menuItem.display.LLeg:Destroy()
		menuItem.display.RLeg:Destroy()
		menuItem.display:SetPrimaryPartCFrame(CFrame.Angles(0,0,math.pi/2))
		Framework.Util.Characters:applySkin(menuItem.display, "Blue & White", "texture20")
		menuItem.camera = Camera
		menuItem.secondDisplay = true
		menuItem.func = function()
			local texture = Framework.HUDController:getText("Enter in your texture ID! Leave blank for the default face.")
			Framework.localPlayer:invokeNet("customFace",tonumber(texture))
			return 0
		end
	end
	
	coroutine.wrap(function()
		while not Menu.destroyed do
			local dt = game:GetService("RunService").RenderStepped:wait()
			Camera.CFrame = CFrame.Angles(0,dt,0) * Camera.CFrame
		end
	end)()
	
	return Menu
end