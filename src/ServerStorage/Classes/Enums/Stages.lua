local Framework = _G.Framework

local newParentEnum = _G.Class:new()
newParentEnum:setName(script.Name)

do
	local newStage = _G.Class:new()
	newStage:setName("Menu")
	newStage.image = "rbxassetid://3106580386"
	newStage.imageRatio = 16/9
	newStage.hub = true
	newStage.toHub = nil
	newStage.tip = "Loading the game..."
	newStage:setParent(newParentEnum)

	local newStage = _G.Class:new()
	newStage:setName("Test Stage")
	newStage.image = "rbxassetid://0"
	newStage.imageRatio = 16/9
	newStage.hub = false
	newStage.toHub = "Display"
	newStage.tip = "A hidden relic of time's past."
	newStage:setParent(newParentEnum)

	local newStage = _G.Class:new()
	newStage:setName("Dice Dock")
	newStage.image = "rbxassetid://0"
	newStage.imageRatio = 16/9
	newStage.hub = false
	newStage.toHub = "Test Stage"
	newStage.tip = "A hidden relic of time's past."
	newStage:setParent(newParentEnum)
end

do
	local newStage = _G.Class:new()
	newStage:setName("Display")
	newStage.image = "rbxassetid://0"
	newStage.imageRatio = 16/9
	newStage.hub = false
	newStage.toHub = "Test Stage"
	newStage.tip = "Getting you into the game!"
	newStage:setParent(newParentEnum)
	
	local newStage = _G.Class:new()
	newStage:setName("Old Dice Dock")
	newStage.image = "rbxassetid://0"
	newStage.imageRatio = 16/9
	newStage.hub = false
	newStage.toHub = "Test Stage"
	newStage.tip = "A hidden relic of time's past."
	newStage:setParent(newParentEnum)

	local newStage = _G.Class:new()
	newStage:setName("Old Lavender Canyon")
	newStage.image = "rbxassetid://0"
	newStage.imageRatio = 16/9
	newStage.hub = false
	newStage.toHub = "Test Stage"
	newStage.tip = "A hidden relic of time's past."
	newStage:setParent(newParentEnum)

	local newStage = _G.Class:new()
	newStage:setName("Old Mount Oka")
	newStage.image = "rbxassetid://0"
	newStage.imageRatio = 16/9
	newStage.hub = false
	newStage.toHub = "Test Stage"
	newStage.tip = "A hidden relic of time's past."
	newStage:setParent(newParentEnum)

	local newStage = _G.Class:new()
	newStage:setName("Old Oceanic Ruins")
	newStage.image = "rbxassetid://0"
	newStage.imageRatio = 16/9
	newStage.hub = false
	newStage.toHub = "Test Stage"
	newStage.tip = "A hidden relic of time's past."
	newStage:setParent(newParentEnum)

	local newStage = _G.Class:new()
	newStage:setName("Old Beesmas Festival")
	newStage.image = "rbxassetid://0"
	newStage.imageRatio = 16/9
	newStage.hub = false
	newStage.toHub = "Test Stage"
	newStage.tip = "A hidden relic of time's past."
	newStage:setParent(newParentEnum)

	local newStage = _G.Class:new()
	newStage:setName("Old Tutorial")
	newStage.image = "rbxassetid://0"
	newStage.imageRatio = 16/9
	newStage.hub = false
	newStage.toHub = "Test Stage"
	newStage.tip = "A hidden relic of time's past."
	newStage:setParent(newParentEnum)
end

return newParentEnum