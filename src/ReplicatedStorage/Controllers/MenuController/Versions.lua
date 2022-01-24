local Framework = shared.Framework
local Util = Framework.Util

local Versions = {
	{
		name = "v1 - Your Version Here",
		desc = "Welcome to your own D20!",
		skin = "Black & White",
		dialog = {
			{"DIALOG","Set this text to your description."},
			{"DIALOG","Enjoy [font:GothamSemibold]Your Version Here[/font]!"}
		}
	},
	{
		name = "Credits",
		desc = "See the developers and contributors that made the game possible.",
		skin = "Blue & Purple",
		dialog = {
			{"DIALOG","[font:GothamSemibold]Elidile[/font] - project lead & programming."},
			{"DIALOG","[font:GothamSemibold]FAVman33, Zerogenic, EpicGonlet[/font] - skins and hats."},
			{"DIALOG","[font:GothamSemibold]zKevin, Polyhex, Matt Makes Games Inc.[/font] - inspiration."},
			{"DIALOG","[font:GothamSemibold]All of my friends in Charx's server[/font] - support."},
			{"DIALOG","and [font:GothamSemibold]"..game.Players.LocalPlayer.Name.."[/font] - for playing the game."},
		}
	}
}

return function()
	local Menu = shared.Class:new()
	
	local Camera = Instance.new("Camera")
	Camera.CFrame = CFrame.new(Vector3.new(-2.5,1,0),Vector3.new(0,.5,0))
	
	for i,v in next, Versions do
		local MenuItem = shared.Class:create("MenuItem")
		MenuItem:setParent(Menu)
		MenuItem.itemName = v.name
		MenuItem.desc = v.desc
		local char = game.ReplicatedStorage.Assets.Character:Clone()
		Util.Characters:applySkin(char, v.skin, "texture20")
		char:SetPrimaryPartCFrame(CFrame.Angles(0,0,math.pi/2))
		char.LArm:Destroy()
		char.RArm:Destroy()
		char.LLeg:Destroy()
		char.RLeg:Destroy()
		MenuItem.display = char
		MenuItem.secondDisplay = true
		MenuItem.camera = Camera
		MenuItem.func = function()
			Menu.defaultSelection = i
			Framework.DialogController:start(v.dialog)
			return 0
		end
	end
	
	Menu.defaultSelection = #Versions - 1
	
	coroutine.wrap(function()
		while not Menu.destroyed do
			local dt = game:GetService("RunService").RenderStepped:wait()
			Camera.CFrame = CFrame.Angles(0,dt,0) * Camera.CFrame
		end
	end)()
	
	return Menu
end