local Framework = shared.Framework
local Util = Framework.Util

return function()
	local Menu = shared.Class:new()
	
	local Camera = Instance.new("Camera")
	Camera.CFrame = CFrame.new(Vector3.new(-3,2,0),Vector3.new(0,.5,0))
	
	local function newMenu(v)
		local hatEnum = Framework.Enums.Hats[v.name]
		
		local MenuItem = shared.Class:create("MenuItem")
		MenuItem.itemName = hatEnum.name
		MenuItem.desc = hatEnum.description
		MenuItem.camera = Camera
		
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
		
		MenuItem.func = function()
			Framework.localPlayer:invokeNet("setHat", hatEnum.name)
		end
		
		return MenuItem
	end
	
	local letters = {}
	local letterIndexes = {}
	local hats = Framework.localPlayer.Hats:getChildren()
	table.sort(hats, function(a,b)
		return a.name <= b.name
	end)
	local selection
	for i,v in next, hats do
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
		local hats = v[2]
		local item = v[3]
		local randomHat = hats[math.random(1,#hats)]
		v[3].itemName = letter
		v[3].desc = "Hats starting with the letter "..letter.."."
		v[3].func = nil
		v[3]:setParent(Menu)
		if letter == Framework.localPlayer.Data.hat:sub(1,1):upper() then
			Menu.defaultSelection = i
		end
		for i,h in next, hats do
			local menuItem = newMenu(h)
			menuItem:setParent(v[3])
			if h.name == Framework.localPlayer.Data.hat then
				item.defaultSelection = i
			end
			if h == randomHat then
				v[3].display = menuItem.display
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