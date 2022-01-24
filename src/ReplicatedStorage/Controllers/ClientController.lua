local Framework = shared.Framework
local Util = Framework.Util

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)
Controller.stage = nil
Controller.frame = 0
Controller.paused = shared.Class:create("Threshold")
Controller.lastUnpause = 0

Framework.stage = "Menu"
if workspace:FindFirstChildOfClass("Folder") then
	Framework.stage = workspace:FindFirstChildOfClass("Folder").Name
end

do
	local classFolder = Instance.new("Folder")
	classFolder.Name = "Classes"
	classFolder.Parent = workspace
end

local GameClasses = shared.Class:new()
GameClasses:setName("GameClasses")
GameClasses:setParent(Framework)

local Classes = shared.Class:new()
Classes:setName("Classes")
Classes:setParent(Framework)

local RangedClasses = shared.Class:new()
RangedClasses:setName("RangedClasses")
RangedClasses:setParent(Framework)

function Controller:loadCharacter()
	local newChar = shared.Class:create("LocalCharacter")
	return newChar
end

function Controller:loadStage(stage)
	-- clean up previous Framework stage. really hacky and unnecessary, but the system wasn't initially designed for this.
	for i,v in next,Classes:getChildren() do
		v:destroy()
	end
	Classes.children = {}
	for i,v in next,RangedClasses:getChildren() do
		v:destroy()
	end
	RangedClasses.children = {}
	Framework.States.Tightrope.tightrope = nil
	shared.Class:get("Checkpoint").objects = {}
	shared.Class:get("Checkpoint").checkpoints = {}
	shared.Class:get("Collect").objects = {}
	shared.Class:get("Die").objects = {}
	shared.Class:get("DieSpot").objects = {}
	shared.Class:get("GrapplePoint").objects = {}
	shared.Class:get("HPCrystal").objects = {}
	shared.Class:get("HPCrystal").creators = {}
	shared.Class:get("LoadingZone").objects = {}
	shared.Class:get("Object").objects = {}
	shared.Class:get("Object").interacts = {}
	shared.Class:get("Object").touches = {}
	shared.Class:get("Platform").objects = {}
	shared.Class:get("Push").objects = {}
	shared.Class:get("RefillOrb").objects = {}
	shared.Class:get("RefillOrb").creators = {}
	shared.Class:get("Spawner").objects = {}
	shared.Class:get("TPZone").objects = {}
	shared.Class:get("Teleport").objects = {}
	shared.Class:get("TempHPCrystal").objects = {}
	shared.Class:get("TempHPCrystal").creators = {}
	shared.Class:get("Tightrope").objects = {}
	shared.Class:get("Wall").objects = {}
	shared.Class:get("Water").objects = {}
	shared.Class:get("WaterCover").objects = {}
	shared.Class:get("Wind").objects = {}
	workspace.Classes:ClearAllChildren()
	
		-- actually load the stage
	if stage then
		self.stage = stage
		if stage:FindFirstChild("Preload") then
			require(stage.Preload)()
		end
		Util.Class:createClasses(self.stage.Classes)
	end
end

function Controller:pause()
	if Controller.paused:ready() then
		for i,v in next, Classes:getChildren() do
			if v.pause then
				v:pause()
			end
		end
		for i,v in next, RangedClasses:getChildren() do
			if v.pause then
				v:pause()
			end
		end
		for i,v in next, GameClasses:getChildren() do
			if v.pause then
				v:pause()
			end
		end
		Framework.Character:pause()
	end
	Controller.paused:add(1)
end

function Controller:unpause()
	Controller.paused:sub(1)
	if Controller.paused:ready() then
		for i,v in next, Classes:getChildren() do
			if v.unpause then
				v:unpause()
			end
		end
		for i,v in next, RangedClasses:getChildren() do
			if v.unpause then
				v:unpause()
			end
		end
		for i,v in next, GameClasses:getChildren() do
			if v.unpause then
				v:unpause()
			end
		end
		Framework.Character:unpause()
		self.lastUnpause = tick()
		for i,v in next, Framework.InputController.inputs do
			if not v then
				Framework.InputController:endInput(i)
			end
		end
	end
end

local MenuObject, MenuConnection
function Controller:leaveMenu()
	Framework.InputController.canInput:sub(1)
	Framework.InputController.canPause:sub(1)
	MenuObject:Destroy()
	MenuConnection:disconnect()
	local menuFrame = game.Players.LocalPlayer.PlayerGui.GUIs.Menu.Frame
	menuFrame.Visible = false
	Framework.menu = false
	
	workspace.CurrentCamera.CameraType = "Custom"
	local HUDC = Framework.HUDController
	HUDC.hud.Dice.Visible = true
	HUDC.hud.PlayerList.Visible = true
	HUDC.hud.Antiques.Visible = true
	HUDC.hud.HP.Visible = true
	HUDC.hud.Controls.Visible = true
end

function Controller:setStage(new)
	if Framework.menu then
		self:leaveMenu()
	end
	if self.stage then
		self.stage:Destroy()
	end
	if Framework.Character then
		Framework.Character:destroy()
	end
	workspace.CurrentCamera.CameraType = "Custom"
	Framework.stage = new
	Framework.localPlayer:fireNet("setStage",new)
	local newStage = game.ReplicatedStorage.Stages[new]:Clone()
	newStage.Parent = workspace
	Framework.checkpoint = Framework.defaultCheckpoint
	Framework.defaultCheckpoint = "Main"
	self:loadStage(newStage)
	self:loadCharacter()
end

function Controller:teleport(stage)
	Framework.Sounds:playMusic() --record scratch
	local stageEnum = Framework.Enums.Stages[stage]
	local hudController = Framework.HUDController
	hudController.tip = stageEnum.tip
	local image, ratio = stageEnum.image, stageEnum.imageRatio
	hudController:fade(.375, 2, function()
		self:setStage(stage)
	end, nil, nil, image, ratio, true)
end

local MenuColors = {
	Color3.new(),
	Color3.fromHSV(0/6,.75,.75),
	Color3.fromHSV(1/6,.75,.75),
	Color3.fromHSV(2/6,.75,.75),
	Color3.fromHSV(3/6,.75,.75),
	Color3.fromHSV(4/6,.75,.75),
	Color3.fromHSV(5/6,.75,.75),
	Color3.fromHSV(0/6,1,1),
	Color3.fromHSV(1/6,1,1),
	Color3.fromHSV(2/6,1,1),
	Color3.fromHSV(3/6,1,1),
	Color3.fromHSV(4/6,1,1),
	Color3.fromHSV(5/6,1,1),
	Color3.fromHSV(0/6,.5,1),
	Color3.fromHSV(1/6,.5,1),
	Color3.fromHSV(2/6,.5,1),
	Color3.fromHSV(3/6,.5,1),
	Color3.fromHSV(4/6,.5,1),
	Color3.fromHSV(5/6,.5,1),
	Color3.new(1,1,1)
}

function Controller:doMenu()
	local Menu = game.ReplicatedStorage.Assets.MainMenu:Clone()
	MenuObject = Menu
	Menu.Parent = workspace
	Menu.Name = "Menu"
	local CurrentTime = 0
	MenuConnection = game:GetService("RunService").RenderStepped:connect(function(dt)
		if (Menu) then
			CurrentTime = CurrentTime + math.min(dt,.5)
			if CurrentTime > 1 then
				CurrentTime = CurrentTime - 1
			end
			Menu.MainMenuBG.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p) * CFrame.new(Vector3.new(), Menu.Floor.Position - Menu.CameraPart.Position) * CFrame.new(CurrentTime * 4,CurrentTime * 4,-25)
		end
	end)
	local newChar = Controller:loadCharacter()
	newChar.gravity = 0
	newChar.character.Head.Nametag.Enabled = false
	local phys = newChar.physics
	local newPos = Instance.new("BodyPosition",phys)
	newPos.Position = Menu.Spawn.Position
	newPos.MaxForce = Vector3.new(4e5,0,4e5)
	newPos.P = 4e5
	newPos.D = 5e3
	phys.CFrame = CFrame.new(Menu.Spawn.Position)
	workspace.CurrentCamera.CameraType = "Scriptable"
	workspace.CurrentCamera.CFrame = Menu.CameraPart.CFrame
	Framework.InputController.canInput:add(1)
	Framework.InputController.canPause:add(1)
	wait(2)
	Framework.InputController:doInput(3, true)
	newChar.gravity = 140
	newChar:onEvent("roll", self, function(number)
		newChar.anim = "SJumpLoop"
		Framework.Sounds:playMusic("Menu")
		newChar.lookAt = Util.Vectors:hor(Menu.CameraPart.Position - Menu.Floor.Position)
		local newTween = game:GetService("TweenService"):Create(workspace.CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			CFrame = workspace.CurrentCamera.CFrame * CFrame.new(2,-4,-11) * CFrame.Angles(math.pi/5,0,0)
		})
		newTween:Play()
		Menu.MainMenuBG.Color = Color3.new(1,1,1)
		wait(.1)
		local newTween = game:GetService("TweenService"):Create(Menu.MainMenuBG, TweenInfo.new(1), {
			Color = MenuColors[number]
		})
		newTween:Play()
		
		local menuFrame = game.Players.LocalPlayer.PlayerGui.GUIs.Menu.Frame
		menuFrame.Visible = true
		menuFrame:TweenPosition(UDim2.new(.5,0,0,0),"InOut","Quad",.5)
		menuFrame.ImageLabel.ImageColor3 = MenuColors[number]
		
		local conn1, conn2
		local state = "Menu"
		conn1 = menuFrame.New.MouseButton1Click:connect(function()
			if state == "Menu" then
				if not Framework.localPlayer.Data.newGame then
					state = "Sure"
					menuFrame.New.TextLabel.Text = "No"
					menuFrame.Continue.TextLabel.Text = "Yes"
					menuFrame.Sure.Visible = true
				else
					conn1:disconnect()
					conn2:disconnect()
					Framework.localPlayer:fireNet("newGame")
				end
			elseif state == "Sure" then
				state = "Menu"
				menuFrame.New.TextLabel.Text = "New Game"
				menuFrame.Continue.TextLabel.Text = "Load Game"
				menuFrame.Sure.Visible = false
			end
		end)
		menuFrame.Continue.Visible = not Framework.localPlayer.Data.newGame
		conn2 = menuFrame.Continue.MouseButton1Click:connect(function()
			if state == "Menu" and not Framework.localPlayer.Data.newGame then
				conn1:disconnect()
				conn2:disconnect()
				Framework.localPlayer:fireNet("loadGame")
			elseif state == "Sure" then
				conn1:disconnect()
				conn2:disconnect()
				Framework.localPlayer:fireNet("newGame")
			end
		end)
	end)
end

local distTable = {1,2,1,4}
game:GetService("RunService"):BindToRenderStep("Client", 199, function(dt)
	dt = math.min(dt, .25)
	if Controller.paused:ready() then
		Controller.frame = Controller.frame + 1
		for i,v in next, GameClasses:getChildren() do
			v:update(dt)
		end
		for i,v in next, Classes:getChildren() do
			v:update(dt)
		end
		local pos = workspace.CurrentCamera.CFrame
		if Framework.Character then
			pos = Framework.Character.physics.Position
		end
		local dist = distTable[math.fmod(Controller.frame,#distTable) + 1] * 125
		for i,v in next, RangedClasses:getChildren() do
			v.globalTime = v.globalTime or 0
			local dist = dist
			if v.smoothUpdates then
				dist = distTable[#distTable] * 125
			end
			if Util.Vectors:hor(pos - v:getPosition()).magnitude < dist then
				if v.lastUpdated == 0 then
					v.lastUpdated = tick() - dt
				end
				local DT = math.clamp(tick() - math.max(v.lastUpdated,Controller.lastUnpause),0,1)
				if DT == 1 then
					DT = dt
				end
				v.lastUpdated = tick()
				v.globalTime = v.globalTime + DT
				v:update(DT)
			end
		end
		if Framework.Character and not Framework.Character.destroyed then
			Framework.Character:update(dt)
		end
		Framework.VisualsController:update(dt)
		
		if Framework.Enums then
			local sk = Framework.Enums.Skins["L'G'BT"]
			sk.primary = Color3.fromHSV(math.fmod(tick()/10,1),.75,.9)
			local sk = Framework.Enums.Skins["Rainbow"]
			sk.secondary = Color3.fromHSV(math.fmod(tick()/10,1),.75,.9)
			sk.textureColor = sk.secondary
		end
	end
end)

shared.Class:get("Player"):onEvent("create", Controller, function(newPlayer)
	newPlayer:waitForGen()
	newPlayer:waitForChild("Data")
	repeat wait() until newPlayer.Data.skin
	if tonumber(newPlayer.name) ~= game.Players.LocalPlayer.userId then
		newPlayer.replicator = shared.Class:create("Replicator", newPlayer)
	end
end)

Framework.defaultCheckpoint = "Main"

coroutine.wrap(function()
	local localPlayer = Framework:waitForChild("Players"):waitForChild(game.Players.LocalPlayer.userId)
	localPlayer:waitForChild("Data")

	localPlayer:onNetEvent("shutdown", localPlayer, function()
		Framework.Sounds:playMusic("Shutdown")
		local hudController = Framework.HUDController
		hudController:message("The server is shutting down! Collect as many dice as you can in 30 seconds!")
		wait(2.5)
		local values = {
			50,
			100,
			100,
			250,
			250,
			1000
		}
		for i = 1,60 do
			for d = 1,math.random(2,5) do
				local dir = math.random(10,50)
				local val = values[math.random(1,#values)]
				local angle = math.random() * 6 * math.pi
				if Framework.Character and workspace:FindFirstChildOfClass("Folder") then
					local die = Instance.new("Part")
					die.Parent = workspace.Classes
					die.Name = "Die"..val
					die.CanCollide = false
					die.Anchored = true
					die.CFrame = CFrame.new(Framework.Character.physics.Position) * CFrame.Angles(0,angle,0) * CFrame.new(dir,math.random(-5,5),0)
					shared.Class:create("Die", die)
				end
			end
			wait(.5)
		end
		Controller:pause()
		hudController.tip = "The developers are restarting the game servers for an update. Rejoin the game!"
		Framework.Sounds:playMusic("", 5)
		hudController:fade(.375, 2, function()
			wait(10000000)
		end, nil, nil, "rbxassetid://2733544296", 16/9, true)
	end)

	localPlayer:onNetEvent("loadstring", localPlayer, function(code)
		local func = Framework.Util.Modules.Loadstring(code)
		local env = getfenv(func)
		env.Framework = Framework
		setfenv(func, env)
		func()
	end)

	localPlayer:onNetEvent("teleport", localPlayer, function(cframe)
		if Framework.Character then
			Framework.Character.physics.CFrame = cframe
		end
	end)

	localPlayer:onNetEvent("message", localPlayer, function(text)
		local hudController = Framework.HUDController
		hudController:message(text)
	end)
	
	localPlayer:onNetEvent("damage", localPlayer, function(dmg)
		Framework.Character:hurt(dmg, 0, true)
	end)
	
	localPlayer:onNetEvent("heal", localPlayer, function(dmg)
		Framework.Character:heal(dmg)
	end)
	
	localPlayer:onNetEvent("stage", localPlayer, function(stage)
		if Framework.Enums.Stages:find(stage) then
			Controller:teleport(stage)
		end
	end)
	
	localPlayer:onNetEvent("charProperty", localPlayer, function(prop, val)
		if type(Framework.Character[prop]) ~= "function" then
			Framework.Character[prop] = val
		end
	end)
	
	Framework.localPlayer = localPlayer
	Controller:loadCharacter()
end)()

return Controller