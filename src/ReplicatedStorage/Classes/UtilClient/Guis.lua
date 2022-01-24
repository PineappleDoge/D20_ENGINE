local Guis = {}

function Guis:displayAntique(player, object)
	if object:IsA("Camera") then
		return 0
	end
	local cname = object.Name
	player:waitForChild("Antiques")
	object.CurrentCamera = game.Players.LocalPlayer.PlayerGui.GUIs.MainHUD.Antiques.Camera
	if player.Antiques:find(cname) then
		local count = #player.Antiques[cname]:getChildren()
		for i,v in next, object:GetChildren() do
			local trans = ((tonumber(v.Name) == count) and .25 or 1)
			v.Transparency = trans
			for i,v in next, v:GetChildren() do
				v.Transparency = trans
			end
		end
		return count
	end
	for i,v in next, object:GetChildren() do
		local trans = 1
		v.Transparency = trans
		for i,v in next, v:GetChildren() do
			v.Transparency = trans
		end
	end
	return 0
end

function Guis:showPlace(place)
	coroutine.wrap(function()
		local label = game.Players.LocalPlayer.PlayerGui.GUIs.MainHUD.PlaceLabel
		local height = 100
		if self.place then
			self.place = place
		else
			self.place = place
			label.Text = place
			label.Frame.Size = UDim2.new(0,label.TextBounds.X + 10,0,3)
			label.Position = UDim2.new(0,-label.TextBounds.X - 20,1,-height)
			label:TweenPosition(UDim2.new(0,10,1,-height),"In","Sine",.375,true)
			wait(2.5)
			label:TweenPosition(UDim2.new(0,-label.TextBounds.X - 20,1,-height),"In","Sine",.375,true)
			wait(.5)
			if self.place ~= place then
				local newPlace = self.place
				self.place = nil
				self:showPlace(newPlace)
				return
			end
			self.place = nil
		end
	end)()
end

local index = {
	"Exploration",
	"Triangles",
	"Squares",
	"Pentagons",
	"Misfortune",
	"SecretFinder",
	"AlternateReality"
}
function Guis:displayHighestAntique(player, object)
	for i = #index, 1, -1 do
		local object = object[index[i]]
		local count = self:displayAntique(player, object)
		if count > 0 then
			return true
		end
	end
end

return Guis