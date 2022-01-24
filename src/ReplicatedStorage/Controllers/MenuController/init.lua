local Framework = shared.Framework

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)
Controller.objects = {}
Controller.selection = 1
Controller.gui = game.Players.LocalPlayer.PlayerGui.GUIs.MainHUD.Selection
Controller.example = Controller.gui.ScrollFrame.Example
Controller.example.Parent = nil
Controller.inMenu = shared.Class:create("Threshold")
Controller.tween = nil

local TweenService = game:GetService("TweenService")

function Controller:start(menuObject, ...)
	Framework.InputController.canInput:add(1)
	Framework.InputController.canPause:add(1)
	self.inMenu:add(1)
	if type(menuObject) == "string" then
		menuObject = require(script[menuObject])(...)
	else
		menuObject = require(menuObject)(...)
	end
	local menus = {menuObject}
	repeat
		local object = self:openMenu(menus[#menus])
		if object and object.func then
			local value = object.func()
			if value == nil then
				menus = {}
			elseif value > 0 then
				for i = 1, value do
					menus[#menus].backSelection = nil
					menus[#menus] = nil
				end
			end
		elseif not object then
			menus[#menus].backSelection = nil
			menus[#menus] = nil
		elseif #object:getChildren() > 0 then
			menus[#menus + 1] = object
		else
			menus = {}
		end
	until #menus == 0
	Framework.InputController.canInput:sub(1)
	Framework.InputController.canPause:sub(1)
	self.inMenu:sub(1)
	menuObject:destroy() --can't have memory leaks
end

function Controller:updateMenu()
	self.gui.ScrollFrame.Position = UDim2.new(.5,0,.5,-95 * (self.selection - 1))
	self.objects[self.selection]:decorateSelection()
end

function Controller:openMenu(menuObject)
	self.usingMenu = true
	self.gui:TweenPosition(UDim2.new(.25,0,.5,0),"InOut","Quad",.25,true)
	self.gui.ScrollFrame:ClearAllChildren()
	self.gui.ScrollFrame.Position = UDim2.new(.5,0,.5,0)
	self.selection = menuObject.backSelection or menuObject.defaultSelection or 1
	self.objects = {}
	local offset = math.huge
	for i,v in next, menuObject:getChildren() do
		offset = math.min(offset,tonumber(v.name) - 1)
	end
	for i = 1,#menuObject:getChildren() do
		local v = menuObject[i + offset]
		self.objects[i] = v
		local item = self.example:Clone()
		item.Name = i
		item.Position = UDim2.new(.5,0,i - .5,0)
		v:decorateBox(item)
		item.Parent = self.gui.ScrollFrame
		item.MouseButton1Down:connect(function()
			self.selection = i
			self:updateMenu()
		end)
	end
	self:updateMenu()
	local ret = self.gui.MenuEvent.Event:wait()
	if ret then
		ret = self.objects[ret]
	end
	self.gui:TweenPosition(UDim2.new(0,-500,.5,0),"InOut","Quad",.25,true)
	self.usingMenu = false
	menuObject.backSelection = self.selection
	return ret
end

function Controller:nextSel()
	if self.usingMenu then
		self.selection = self.selection + 1
		if self.selection > #self.objects then
			self.selection = 1
		end
		self:updateMenu()
	end
end
function Controller:prevSel()
	if self.usingMenu then
		self.selection = self.selection - 1
		if self.selection < 1 then
			self.selection = #self.objects
		end
		self:updateMenu()
	end
end

Controller.gui.Next.MouseButton1Click:connect(function()
	Controller.gui.MenuEvent:fire(Controller.selection)
end)
Controller.gui.Back.MouseButton1Click:connect(function()
	Controller.gui.MenuEvent:fire()
end)

coroutine.wrap(function()
	repeat wait() until Framework.InputController
	local inputController = Framework.InputController
	inputController:onEvent("guiInput", Controller, function(direction)
		if direction.Y > 0 then
			Controller:prevSel()
		elseif direction.Y < 0 then
			Controller:nextSel()
		end
	end)
	inputController:onEvent("startBypass", Controller, function(n)
		if (Controller.inMenu.count > 0) then
			if n == 1 then
				local object = Controller.objects[Controller.selection]
				if object and object:parse(object.canUse) then
					Controller.gui.MenuEvent:fire(Controller.selection)
				end
			elseif n == 2 then
				local object = Controller.objects[Controller.selection]
				if object and object:parse(object.canExit) then
					Controller.gui.MenuEvent:fire()
				end
			end
		end
	end)
end)()

return Controller