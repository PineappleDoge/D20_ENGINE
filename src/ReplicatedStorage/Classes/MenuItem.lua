local Framework = shared.Framework

local MenuItem = shared.Class:new()
MenuItem.count = 0
MenuItem.cost = 0
MenuItem.costType = nil
MenuItem.itemName = "Item name not found. Report to the developer."
MenuItem.desc = "Item description not found. Report to the developer."
MenuItem.canUse = true
MenuItem.canExit = true
MenuItem.display = "rbxassetid://0"
MenuItem.secondDisplay = false
MenuItem.error = "You can't use this at the moment!"
MenuItem.gui = game.Players.LocalPlayer.PlayerGui.GUIs.MainHUD.Selection
MenuItem.camera = Instance.new("Camera")
MenuItem.camera.CFrame = CFrame.new(Vector3.new(1,1,-4),Vector3.new())
MenuItem.costImages = {
	Dice = "rbxassetid://1650256960",
	Coins = "rbxassetid://2143044758", -- deprecated
	Robux = "rbxasset://textures/ui/RobuxIcon.png" -- deprecated
}

MenuItem.func = nil --Setup the function! If the function is nil, object will act as another menu
					--If the function returns an integer, will go to the n-th previous menu: 0 will bring back to the menu you came from, 1 is prev, etc
					--If it returns nil, will exit all menus

function MenuItem:parse(value, ...) --Values above can be functions that return a value
	if type(value) == "function" then
		return value(self, ...)
	end
	return value
end

function MenuItem:addCamera(cframe)
	self.camera = Instance.new("Camera")
	self.camera.CFrame = cframe or CFrame.new(Vector3.new(1,1,-4),Vector3.new())
end

function MenuItem:decorateBox(box)
	local name = self:parse(self.itemName)
	box.Item.Text = name
	local canUse = self:parse(self.canUse)
	box.BackgroundColor3 = canUse and Color3.new(1,1,1) or Color3.new(.8,.8,.8)
	box.ImageTransparency = canUse and 0 or .2
	box.Item.TextTransparency = canUse and 0 or .2
	local display = self:parse(self.display)
	if type(display) == "string" then
		box.ViewportFrame.Visible = false
		box.Image = display
	else
		box.ViewportFrame.CurrentCamera = self.camera
		box.ViewportFrame.Visible = true
		box.Image = "rbxassetid://0"
		display:Clone().Parent = box.ViewportFrame
	end
end

function MenuItem:decorateSelection()
	local canUse = self:parse(self.canUse)
	local canExit = self:parse(self.canExit)
	local name = self:parse(self.itemName)
	local desc = self:parse(self.desc)
	if not canUse then
		desc = self:parse(self.error)
	end
	local secondDisplay = self:parse(self.secondDisplay)
	local display = self:parse(self.display)
	local cost = self:parse(self.cost)
	local costType = self:parse(self.costType)
	self.gui.Next.Visible = canUse
	self.gui.Back.Visible = canExit
	self.gui.Item.Text = name
	self.gui.Desc.Text = desc
	if secondDisplay then
		self.gui.Selection.Visible = true
		if type(display) == "string" then
			self.gui.Selection.ViewportFrame.Visible = false
			self.gui.Selection.Image = display
		else
			self.gui.Selection.ViewportFrame.CurrentCamera = self.camera
			self.gui.Selection.ViewportFrame:ClearAllChildren()
			self.gui.Selection.ViewportFrame.Visible = true
			self.gui.Selection.Image = "rbxassetid://0"
			display:Clone().Parent = self.gui.Selection.ViewportFrame
		end
		self.gui.Item.Position = UDim2.new(1,10,.5,-self.gui.Desc.TextBounds.Y - 5)
		self.gui.Desc.Position = UDim2.new(1,10,.5,-self.gui.Desc.TextBounds.Y - 5)
	else
		self.gui.Selection.Visible = false
		self.gui.Item.Position = UDim2.new(1,10,.5,0)
		self.gui.Desc.Position = UDim2.new(1,10,.5,0)
	end
	if costType then
		self.gui.Selection.Cost.Visible = true
		self.gui.Selection.Cost.Image = self.costImages[costType]
		self.gui.Selection.Cost.Amount.Text = "x"..Framework.Util.String:separateCommas(cost)
	else
		self.gui.Selection.Cost.Visible = false
	end
end

MenuItem:construct("MenuItem", function(newMI)
	MenuItem.count = MenuItem.count + 1
	newMI:setName(MenuItem.count)
end)

return MenuItem