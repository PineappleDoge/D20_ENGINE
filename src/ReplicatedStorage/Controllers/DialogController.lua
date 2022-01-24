local Framework = shared.Framework
local Util = Framework.Util
local Sounds

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)
Controller.gui = game.Players.LocalPlayer.PlayerGui.GUIs.MainHUD.Dialog
Controller.table = {}
Controller.index = 1
Controller.TextRender = Util.Modules.TextRender:new()
Controller.skip = false
Controller.dialogOpen = false
Controller.position = 150
Controller.chooseEvent = Instance.new("BindableEvent")
Controller.selection = 1
Controller.inputs = 0
Controller.bgColor = Color3.new(1,1,1)

Controller.functions = {
	DIALOG = function(str)
		Controller.dialogOpen = true
		Controller.skip = false
		local tab = Controller.TextRender:ParseText(str)
		local tx = Controller.TextRender:RenderText(tab,Controller.gui.MainFrame.AbsoluteSize.X,Controller.gui.MainFrame.AbsoluteSize.Y)
		Controller.gui.MainFrame:ClearAllChildren()
		tx.Parent = Controller.gui.MainFrame
		for i,v in next, tx:GetChildren() do
			v.Visible = false
		end
		Sounds.musicVolumeMod = Sounds.musicVolumeMod / 3
		for i = 1,#tx:GetChildren() do
			local v = tx[i]
			v.Visible = true
			v.ZIndex = 6
			if not Controller.skip then
				Sounds.sounds.Talk.Pitch = math.random(95,105)/100
				Sounds:play("Talk")
				Util.Time:waitFor(.03)
			end
		end
		Controller.skip = false
		repeat game:GetService("RunService").RenderStepped:wait() until Controller.skip
		Sounds.musicVolumeMod = Sounds.musicVolumeMod * 3
		Controller.dialogOpen = false
	end,
	CHOOSE = function(inputs, outputs)
		Controller.dialogOpen = true
		Controller.selection = #inputs
		Controller.inputs = #inputs
		for i = 1,4 do
			local v = Controller.gui["Choice"..i]
			v.Visible = i <= #inputs
			if v.Visible then
				v.Text = inputs[#inputs + 1 - i]
			end
		end
		Controller.selection = Controller.chooseEvent.Event:wait()
		Controller.dialogOpen = false
		for i = 1,4 do
			Controller.gui["Choice"..i].Visible = false
		end
		return outputs[#inputs + 1 - Controller.selection], 0
	end,
	DO = function(func)
		return func()
	end,
	NAME = function(name)
		Controller.gui.Nametag.Text = name or ""
	end,
	NAMECOLOR = function(color)
		Controller.gui.Nametag.TextColor3 = color or Color3.new(1,1,1)
	end,
	COLOR = function(color)
		Controller.bgColor = color or Color3.new(1,1,1)
		Controller.gui.BackgroundColor3 = Controller.bgColor
	end
}

for i = 1,4 do
	local v = Controller.gui["Choice"..i]
	v.MouseButton1Click:connect(function()
		Controller.chooseEvent:Fire(i)
	end)
end

local inputController = Framework.InputController
inputController:onEvent("startBypass", inputController, function(n)
	if n == 1 then
		Controller.skip = true
		Controller.chooseEvent:fire(Controller.selection)
	end
end)
inputController:onEvent("guiInput", inputController, function(dir)
	if dir.Y > 0 then
		Controller.selection = Controller.selection + 1
		if Controller.selection > Controller.inputs then
			Controller.selection = 1
		end
	elseif dir.Y < 0 then
		Controller.selection = Controller.selection - 1
		if Controller.selection < 1 then
			Controller.selection = Controller.inputs
		end
	end
end)

function Controller:start(node)
	Sounds = Framework.Sounds
	self.functions.NAME()
	self.functions.NAMECOLOR()
	self.functions.COLOR()
	self.gui.MainFrame:ClearAllChildren()
	inputController.canInput:add(1)
	inputController.canPause:add(1)
	self.table = node
	self.index = 1
	repeat
		local value = self.table[self.index]
		local func = value[1]
		table.remove(value, 1)
		local tab, ind = self.functions[func](unpack(value))
		table.insert(value,1,func)
		if tab then
			self.table = tab
		end
		if ind then
			self.index = ind
		end
		self.index = self.index + 1
	until not self.table or not self.index or not self.table[self.index]
	inputController.canInput:sub(1)
	inputController.canPause:sub(1)
	self.dialogOpen = false
end

game:GetService("RunService").RenderStepped:connect(function(dt)
	local position = 175
	if Controller.dialogOpen then
		position = -50
	end
	Controller.position = Controller.position + (position - Controller.position) * Util.Numbers:invLerp(.125,1/60,1/30)
	Controller.gui.Position = UDim2.new(.5,0,1,Controller.position)
	for i = 1,4 do
		local v = Controller.gui["Choice"..i]
		if i == Controller.selection then
			v.BG.BackgroundColor3 = Util.Colors:shift(Controller.bgColor)
		else
			v.BG.BackgroundColor3 = Controller.bgColor
		end
		v.TextStrokeColor3 = Util.Colors:shadow(v.TextColor3, v.BG.BackgroundColor3)
	end
end)

return Controller