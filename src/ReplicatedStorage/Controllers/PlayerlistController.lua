local Framework = shared.Framework
local Util = Framework.Util

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)
Controller.gui = game.Players.LocalPlayer.PlayerGui.GUIs.MainHUD.PlayerList
Controller.example = Controller.gui.Example
Controller.example.Parent = nil

game.StarterGui:SetCoreGuiEnabled("All", false)
game.StarterGui:SetCoreGuiEnabled("Chat", true)
game.Players.LocalPlayer.PlayerGui:SetTopbarTransparency(1)
local updateCall = 0
function Controller:update()
	updateCall = updateCall + 1
	local thisUC = updateCall
	Util.Time:waitFor(.1)
	if thisUC ~= updateCall then
		return
	end
	Framework:waitForChild("Players")
	self.gui:ClearAllChildren()
	local players = Framework.Players:getChildren()
	for i,v in next, players do
		if not v.instance or not v.object or not v:find("Character") then
			table.remove(players, i)
		end
	end
	table.sort(players, function(a, b)
		return a.object.userId <= b.object.userId
	end)
	local lastLabel
	for i,v in next, players do
		local frame = self.example:Clone()
		frame.Parent = self.gui
		frame.Visible = true
		frame.Name = v.name
		frame.TextLabel.Text = v.playerName
		frame.Tag.TextColor3 = v.tagColor
		frame.Tag.TextStrokeColor3 = Util.Colors:shadow(v.primary, v.tagColor)
		frame.BackgroundColor3 = v.primary
		frame.Tri.ImageColor3 = v.primary
		frame.TextLabel.TextColor3 = v.secondary
		frame.TextLabel.TextStrokeColor3 = Util.Colors:shadow(v.primary, v.secondary)
		if v.tag and not v.hideTag then
			frame.Tag.Text = v.tag
			frame.Tag.Visible = true
			frame.Size = UDim2.new(0,frame.Tag.TextBounds.X + frame.TextLabel.TextBounds.X + 25,0,25)
		else
			frame.Tag.Visible = false
			frame.Size = UDim2.new(0,frame.TextLabel.TextBounds.X + 20,0,25)
		end
		Util.Guis:displayHighestAntique(v, frame.Antique)
		frame.Position = UDim2.new(1,0,0,35 * (i - 1))
		lastLabel = frame
	end
end

shared.Class:get("Player"):onEvent("create", Controller, function(newPlayer)
	newPlayer:waitForGen()
	newPlayer:onEvent("update", Controller, function(index)
		if not newPlayer.destroyed then
			Controller:update()
		end
	end)
	newPlayer:waitForChild("Data"):onEvent("update", Controller, function()
		if not newPlayer.destroyed then
			Controller:update()
		end
	end)
	newPlayer:waitForChild("Character"):onEvent("update", Controller, function(index)
		if index == "stage" then
			Controller:update()
		end
	end)
	newPlayer:onEvent("destroyed", Controller, function()
		Controller:update()
	end)
	newPlayer.Antiques:onEvent("descendantAdded", Controller, function()
		Controller:update()
	end)
	newPlayer.Antiques:onEvent("descendantRemoved", Controller, function()
		Controller:update()
	end)
	Controller:update()
end)

return Controller