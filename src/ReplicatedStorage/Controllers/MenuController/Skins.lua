local Framework = shared.Framework
local Util = Framework.Util

return function()
	local Menu = shared.Class:new()
	
	local Camera = Instance.new("Camera")
	Camera.CFrame = CFrame.new(Vector3.new(-2.5,1,0),Vector3.new(0,.5,0))
	
	local function newMenu(v)
		local skinEnum = Framework.Enums.Skins[v.name]
		
		local MenuItem = shared.Class:create("MenuItem")
		MenuItem.itemName = skinEnum.name
		MenuItem.desc = skinEnum.description
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
		
		MenuItem.func = function()
			Framework.localPlayer:invokeNet("setSkin", skinEnum.name)
		end
		
		return MenuItem
	end
	
	local letters = {}
	local letterIndexes = {}
	local skins = Framework.localPlayer.Skins:getChildren()
	table.sort(skins, function(a,b)
		return a.name <= b.name
	end)
	local selection
	for i,v in next, skins do
		local letter = v.name:sub(1,1):upper()
		if not letterIndexes[letter] then
			local menuItem = newMenu(v)
			letters[#letters+1] = {letter, {v}, menuItem}
			letterIndexes[letter] = #letters
		else
			local t = letters[letterIndexes[letter]][2]
			t[#t+1] = v
		end
	end
	for i,v in next, letters do
		local letter = v[1]
		local skins = v[2]
		local item = v[3]
		Util.Characters:applySkin(v[3].display, skins[math.random(1,#skins)].name, "texture20")
		v[3].itemName = letter
		v[3].desc = "Skins starting with the letter "..letter.."."
		v[3].func = nil
		v[3]:setParent(Menu)
		if letter == Framework.localPlayer.Data.skin:sub(1,1):upper() then
			Menu.defaultSelection = i
		end
		for i,s in next, skins do
			local menuItem = newMenu(s)
			menuItem:setParent(v[3])
			if s.name == Framework.localPlayer.Data.skin then
				item.defaultSelection = i
			end
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