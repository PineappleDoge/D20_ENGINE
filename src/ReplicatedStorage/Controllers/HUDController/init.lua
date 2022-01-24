local Framework = shared.Framework
local Util = Framework.Util

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)
Controller.hud = game.Players.LocalPlayer.PlayerGui.GUIs.MainHUD
Controller.load = game.Players.LocalPlayer.PlayerGui.GUIs.Loading
Controller.tip = nil

function Controller:getTip()
	if self.tip then
		local tip = self.tip
		self.tip = nil
		return tip
	end
	local Tips = {
		"Put your tips here!"
	}
	
	local month = os.date("*t").month
	local day = os.date("*t").wday
	if month == 4 then
		Tips[#Tips+1] = "Egg."
	elseif month == 10 then
		Tips[#Tips+1] = "Happy Halloween!"
	elseif month == 11 then
		Tips[#Tips+1] = "Happy Thanksgiving!"
	elseif month == 12 then
		Tips[#Tips+1] = "Merry Beesmas! I mean, merry Christmas!"
	end
	--if day == 4 then
	--	Tips[#Tips+1] = "You can BLJ on Wednesdays."
	--	Tips[#Tips+1] = "It is Wednesday, my dudes."
	--end
	return Tips[math.random(1,#Tips)]
end

function Controller:fade(tween, mid, func, color, fadein, image, imageRatio, bypass)
	local inputController = Framework.InputController
	fadein = fadein ~= false
	image = image or "rbxassetid://0"
	local function waitBypass(...)
		if not self.bypass then
			return wait(...)
		end
	end
	if not self.fading or bypass then
		if bypass then
			self.fadeBypass = true
		end
		inputController.canInput:add(1)
		inputController.canPause:add(1)
		self.fading = true
		color = color or Color3.fromRGB(30,30,30)
		self.load.Circle.ImageColor3 = color
		self.load.Circle.Frame1.BackgroundColor3 = color
		self.load.Circle.Frame2.BackgroundColor3 = color
		self.load.Circle.Frame3.BackgroundColor3 = color
		self.load.Circle.Frame4.BackgroundColor3 = color
		self.load.Tip.Text = self:getTip()
		self.load.ImageLabel.Image = image
		if imageRatio then
			self.load.ImageLabel.Size = UDim2.new(imageRatio/2, 0, .5, 0)
		end
		self.load.ImageLabel.Circle.ImageColor3 = color
		self.load.Circle:TweenSize(UDim2.new(),"Out","Sine",fadein and tween or 0,true)
		wait(fadein and tween or 0)
		self.load.ImageLabel.Visible = true
		if mid > .5 then
			game:GetService("TweenService"):Create(self.load.Load, TweenInfo.new(.25), {
				TextTransparency = 0
			}):Play()
			game:GetService("TweenService"):Create(self.load.ImageLabel, TweenInfo.new(.25), {
				ImageTransparency = 0
			}):Play()
			game:GetService("TweenService"):Create(self.load.Tip, TweenInfo.new(.25), {
				TextTransparency = 0
			}):Play()
			game:GetService("TweenService"):Create(self.load.TipLabel, TweenInfo.new(.25), {
				TextTransparency = 0
			}):Play()
		end
		waitBypass(mid/2)
		if func then
			func()
		end
		waitBypass(mid/2 - .25)
		if mid > .5 then
			game:GetService("TweenService"):Create(self.load.Load, TweenInfo.new(.25), {
				TextTransparency = 1
			}):Play()
			game:GetService("TweenService"):Create(self.load.ImageLabel, TweenInfo.new(.25), {
				ImageTransparency = 1
			}):Play()
			game:GetService("TweenService"):Create(self.load.Tip, TweenInfo.new(.25), {
				TextTransparency = 1
			}):Play()
			game:GetService("TweenService"):Create(self.load.TipLabel, TweenInfo.new(.25), {
				TextTransparency = 1
			}):Play()
		end
		wait(.25)
		self.load.ImageLabel.Visible = false
		self.load.Circle:TweenSize(UDim2.new(math.sqrt(2),0,math.sqrt(2),0),"In","Sine",tween,true)
		waitBypass(tween)
		inputController.canInput:sub(1)
		inputController.canPause:sub(1)
		self.fading = false
		return true
	end
	return false
end

local invTime = 0
function Controller:hurt(cd)
	invTime = tick() + cd
	coroutine.wrap(function()
		local TweenService = game:GetService("TweenService")
		game.Lighting.HurtEffect.TintColor = Color3.new(1,.5,.5)
		wait(.05)
		TweenService:Create(game.Lighting.HurtEffect, TweenInfo.new(.15), {
			TintColor = Color3.new(1,1,1)
		}):Play()
	end)()
end

function Controller:message(txt)
	coroutine.wrap(function()
		local msg = self.hud.AdminLog:Clone()
		msg.Name = "_"..msg.Name
		msg.Text = txt
		msg.Parent = self.hud
		msg:TweenPosition(UDim2.new(.5,0,.25,0),"InOut","Quad",.5)
		wait(2.5)
		msg:TweenPosition(UDim2.new(-.5,0,.25,0),"InOut","Quad",.5)
		wait(.5)
		msg:Destroy()
	end)()
end

function Controller:getText(tip)
	game:GetService("RunService").RenderStepped:wait()
	tip = tip or "Enter your text here."
	Framework.InputController.canInput:add(1)
	Controller.hud.EnterText.Visible = true
	Controller.hud.EnterText.Enter.Text = tip
	Controller.hud.EnterText.Text = ""
	Controller.hud.EnterText:CaptureFocus()
	Controller.hud.EnterText.FocusLost:wait()
	Framework.InputController.canInput:sub(1)
	Controller.hud.EnterText.Visible = false
	return Controller.hud.EnterText.Text
end

function Controller:queryControls()
	local hud = Controller.hud.Controls
	hud[1].Visible = false
	hud[2].Visible = false
	hud[3].Visible = false
	if Framework.Character then
		local queries = {}
		for i = 1,3 do
			local key = (Framework.console and (i == 1 and "A" or i == 2 and "RT" or i == 3 and "X") or
				(i == 1 and "Space" or i == 2 and "Shift" or i == 3 and "E"))
			local input = Framework.Character:queryInput(i)
			if input then
				queries[#queries + 1] = {key, input}
			end
		end
		for i,v in next, queries do
			hud[i].Visible = true
			hud[i].Control.Text = v[1]
			hud[i].Move.Text = v[2]
			hud[i].Size = UDim2.new(0,hud[i].Control.TextBounds.X + 10,0,20)
			hud[i].Frame.Size = UDim2.new(0,hud[i].Move.TextBounds.X + 15,0,1)
		end
	end
end

local lastDice = -1
function Controller:updateCurrency()
	local hud = self.hud
	hud.Dice.TextLabel.Text = Util.String:separateCommas(Framework.localPlayer.Data.dice)
	if lastDice ~= -1 and lastDice ~= Framework.localPlayer.Data.dice then
		local frame = hud.Dice.GetEffect:Clone()
		frame.Name = "_GetEffect"
		frame.Parent = hud.Dice
		local diff = Framework.localPlayer.Data.dice - lastDice
		local sign = "+"
		if diff < 0 then
			diff = -diff
			sign = "-"
		end
		diff = Util.String:separateCommas(Framework.localPlayer.Data.dice - lastDice)
		frame.Text = diff
		frame.Behind.Text = sign
		frame.Position = UDim2.new(1, hud.Dice.TextLabel.TextBounds.X + 25, .5, 0)
		frame.Visible = true
		game:GetService("TweenService"):Create(frame, TweenInfo.new(.5), {
			TextTransparency = 1
		}):Play()
		game:GetService("TweenService"):Create(frame.Behind, TweenInfo.new(.5), {
			TextTransparency = 1
		}):Play()
		frame:TweenPosition(frame.Position + UDim2.new(0,math.random(0,50),0,-math.random(75,100)),"In","Linear",.5)
		coroutine.wrap(function()
			wait(1)
			frame:Destroy()
		end)
	end
	lastDice = Framework.localPlayer.Data.dice
end

local lastHP = 4
local lastChange = 0
local hpChange = 1
local dir = 1


local hpCam = Instance.new("Camera")
hpCam.Parent = Controller.hud.HP
hpCam.CFrame = CFrame.new(Vector3.new(0,0,-6),Vector3.new())
Controller.HPtet = game.Players.LocalPlayer.PlayerGui.GUIs.MainHUD.HP.HP
Controller.HPtet.Parent.CurrentCamera = hpCam
local hpColors = {
	[0] = BrickColor.new("Black").Color,
	BrickColor.new("Bright red").Color,
	BrickColor.new("Neon orange").Color,
	BrickColor.new("Bright yellow").Color,
	BrickColor.new("Sea green").Color
}
function Controller:updateHP(dt)
	if Framework.Character then
		local thisHP = Framework.Character.health
		self.HPtet.Color = self.HPtet.Color:lerp(hpColors[thisHP], Util.Numbers:invLerp(.25,1/30,dt))
		if thisHP > 0 then
			self.HPtet.CFrame = self.HPtet.CFrame:lerp(self.HPtet[thisHP].Value, Util.Numbers:invLerp(.25,1/30,dt))
			local transparency = 0
			if tick() < invTime then
				transparency = .125 * (1 - math.cos((invTime - tick()) * 4 * math.pi))/2
			end
			self.HPtet.Transparency = transparency
			self.HPtet.Decal.Transparency = transparency
		else
			self.HPtet.Transparency = self.HPtet.Transparency + dt * 2
			self.HPtet.Decal.Transparency = self.HPtet.Decal.Transparency + dt * 2
		end
	end
end

local antiqueCam = Instance.new("Camera")
antiqueCam.Parent = Controller.hud.Antiques
antiqueCam.CFrame = CFrame.new(Vector3.new(0,0,-3),Vector3.new())
antiqueCam.FieldOfView = 30
function Controller:updateAntiqueCam(dt)
	antiqueCam.CFrame = CFrame.Angles(0,math.pi/2 * dt,0) * antiqueCam.CFrame
end

Controller.load.Circle.Size = UDim2.new()

coroutine.wrap(function()
	repeat wait() until Framework.localPlayer
	Framework.localPlayer:waitForGen()
	Controller:update()
	Framework.localPlayer.Data:onEvent("update", Controller, function()
		Controller:update()
	end)
	Framework.localPlayer.Antiques:onEvent("descendantAdded", Controller, function()
		Controller:update()
	end)
	Framework.localPlayer.Antiques:onEvent("descendantRemoved", Controller, function()
		Controller:update()
	end)
end)()

game:GetService("RunService").RenderStepped:connect(function(dt)
	Controller:queryControls()
	Controller:updateHP(dt)
	Controller:updateAntiqueCam(dt)
	local S = (Controller.load.AbsoluteSize.X > Controller.load.AbsoluteSize.Y and "XX" or "YY")
	Controller.load.Circle.SizeConstraint = "Relative"..S
end)

function Controller:update()
	for i,v in next, self.hud.Antiques:GetChildren() do
		Util.Guis:displayAntique(Framework.localPlayer, v)
	end
	Controller:updateCurrency()
end

local Assets = require(script.LoadAssets)

coroutine.wrap(function()
	repeat game:GetService("RunService").RenderStepped:wait() until Framework.ClientController and Framework.Enums and Framework.stage
	local stageEnum = Framework.Enums.Stages[Framework.stage]
	Controller.tip = stageEnum.tip
	local image, ratio = stageEnum.image, stageEnum.imageRatio
	Controller:fade(.375, 2, function()
		repeat wait() until Framework.localPlayer
		game:GetService("ContentProvider"):PreloadAsync(Assets)
		if Framework.menu then
			Controller.hud.Dice.Visible = false
			Controller.hud.PlayerList.Visible = false
			Controller.hud.Antiques.Visible = false
			Controller.hud.HP.Visible = false
			Controller.hud.Controls.Visible = false
			coroutine.wrap(function()
				Framework.ClientController:doMenu()
			end)()
		end
	end, nil, false, image, ratio, true)
end)()

return Controller