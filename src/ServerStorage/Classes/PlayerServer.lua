local Framework = _G.Framework

local Player = _G.Class:new()
Player:setName("Player")
Player.playerName = "Player"
Player.hideTag = false
Player.object = nil
Player.tag = nil
Player.tagColor = Color3.new(1,1,1)
Player.admin = false
Player.tester = false
Player.primary = Color3.new(1,1,1)
Player.secondary = Color3.new()
Player.face = nil
Player.rollItem = nil
Player.stage = nil

function Player:serialize()
	local data = {}
	data.data = self.Data:serialize()
	data.data.skinFG = {data.data.skinFG.r,data.data.skinFG.g,data.data.skinFG.b}
	data.data.skinBG = {data.data.skinBG.r,data.data.skinBG.g,data.data.skinBG.b}
	data.skins = {}
	for i,v in next, self.Skins:getChildren() do
		data.skins[#data.skins + 1] = v.name
	end
	data.hats = {}
	for i,v in next, self.Hats:getChildren() do
		data.hats[#data.hats + 1] = v.name
	end
	data.moves = {}
	for i,v in next, self.Moves:getChildren() do
		data.moves[#data.moves + 1] = v.name
	end
	data.tags = {}
	for i,v in next, self.Tags:getChildren() do
		data.tags[v.name] = v:serialize()
	end
	data.gtags = {}
	for i,v in next, self.GlobalTags:getChildren() do
		data.gtags[v.name] = v:serialize()
	end
	data.antiques = {}
	for i,c in next, self.Antiques:getChildren() do
		data.antiques[c.name] = {}
		for i,v in next, c:getChildren() do
			data.antiques[c.name][#data.antiques[c.name] + 1] = v.name
		end
	end
	return data
end

function Player:deserialize(data)
	data.data = data.data or {}
	data.skins = data.skins or {}
	data.hats = data.hats or {}
	data.moves = data.moves or {}
	data.tags = data.tags or {}
	data.gtags = data.gtags or {}
	data.antiques = data.antiques or {}
	
	data.data.skinFG = Color3.new(unpack(data.data.skinFG))
	data.data.skinBG = Color3.new(unpack(data.data.skinBG))
	
	self.Data:deserialize(data.data)
	for i,v in next, data.skins do
		self:awardSkin(v, true)
	end
	for i,v in next, data.hats do
		self:awardHat(v, true)
	end
	for i,v in next, data.moves do
		self:awardMove(v, true)
	end
	for i,v in next, data.tags do
		local newClass = _G.Class:new()
		newClass:setName(i)
		newClass:deserialize(v)
		newClass:setParent(self.Tags)
		newClass:generate()
	end
	for i,v in next, data.gtags do
		local newClass = _G.Class:new()
		newClass:setName(i)
		newClass:deserialize(v)
		newClass:setParent(self.GlobalTags)
		newClass:generate()
	end
	for i,c in next, data.antiques do
		for _,v in next,c do
			self:awardAntique(i, v)
		end
	end
end

function Player:awardSkin(name, bypass)
	if not self.Skins:find(name) and Framework.Enums.Skins:find(name) and (bypass or self.dev or not Framework.Enums.Skins[name].exclusive) then
		local newClass = _G.Class:new()
		newClass:setName(name)
		newClass:setParent(self.Skins)
		newClass:generate()
	end
end
function Player:awardHat(name, bypass)
	if not self.Hats:find(name) and Framework.Enums.Hats:find(name) and (not Framework.Enums.Hats[name].exclusive or bypass or self.dev) then
		local newClass = _G.Class:new()
		newClass:setName(name)
		newClass:setParent(self.Hats)
		newClass:generate()
	end
end
function Player:awardMove(name, bypass)
	if not self.Moves:find(name) and Framework.Enums.Moves:find(name) and (bypass or not Framework.Enums.Moves[name].exclusive) then
		local newClass = _G.Class:new()
		newClass:setName(name)
		newClass:setParent(self.Moves)
		newClass:generate()
		self:setMove(name)
	end
end
function Player:awardAntique(name, sub)
	if not self.Antiques:find(name) then
		local newClass = _G.Class:new()
		newClass:setName(name)
		newClass:setParent(self.Antiques)
		newClass:generate()
	end
	if not self.Antiques[name]:find(sub) then
		local newClass = _G.Class:new()
		newClass:setName(sub)
		newClass:setParent(self.Antiques[name])
		newClass:generate()
	end
end
function Player:addDice(amount)
	self.Data.dice = math.max(0,self.Data.dice + amount)
	self.Data:update()
end

function Player:setSkin(name, bypass)
	local Enums = Framework.Enums
	if self.Skins:find(name) or bypass then
		self.Data.skin = name
		self.primary = Enums.Skins[name].primary
		self.secondary = Enums.Skins[name].secondary
		self.face = nil
		if Enums.Skins[name].face then
			self.face = Enums.Skins[name].face
		elseif name == "Custom" then
			self.face = self.Data.face
			self.primary = self.Data.skinBG
			self.secondary = self.Data.skinFG
		end
		self:update()
		self.Data:update()
	end
end
function Player:setHat(name, bypass)
	if self.Hats:find(name) or bypass then
		self.Data.hat = name
		self.Data:update()
	end
end
function Player:setMove(name)
	if self.Moves:find(name) then
		self.Data.move = name
		self.Data:update()
	end
end

function Player:updateTag()
	self.tag = nil
	if self.name == "8036457" then
		self.playerName = "cyberdile"
	elseif self.dev then
		self.tag = "DEV"
		self.tagColor = Color3.new(1,.2,.2)
	elseif self.admin then
		self.tag = "ADMIN"
		self.tagColor = Color3.new(.2,1,.5)
	elseif self.contributor then
		self.tag = "CONTRIBUTOR"
		self.tagColor = Color3.new(1,.8,.2)
	elseif self.tester then
		self.tag = "TESTER"
		self.tagColor = Color3.new(.2,.5,1)
	elseif self.cool then
		self.tag = "COOL"
		self.tagColor = Color3.new(1,.5,.2)
	end
end

function Player:resetData()
	self.Tags:clearAllChildren()
	self.Moves:clearAllChildren()
	self.Antiques:clearAllChildren()
	self.Data.spawn = "Dice Dock"
	self.Data.maxMoves = 1
	self.Data.moves = 1
	self.Data.hat = "None"
	self.Data.skin = "Black & White"
	self.Data.move = "None"
	self.Data.newGame = true

	self:awardSkin("Black & White")
	self:awardHat("None")
	self:awardMove("None")
end

function Player:updateRoll(shopEnum)
	local rs = {}
	for i,v in next,shopEnum:getChildren() do
		local add = true
		if v.type == "Hat" then
			if self.Hats:find(v.item) then
				add = false
			end
		elseif v.type == "Skin" then
			if self.Skins:find(v.item) then
				add = false
			end
		end
		if add then
			rs[#rs + 1] = v
		end
	end
	if #rs == 0 then
		return false
	end
	for i = 1,20 do
		local item = rs[math.random(1,#rs)]
		self.RollItems[i].type = item.type
		self.RollItems[i].item = item.item
		self.RollItems[i]:update()
	end
	self.shopItem = shopEnum.name
	self:update()
	return true
end

local codes = {
	["lesbian rights"] = function(player)
		player:awardSkin("'L'GBT",true)
		return 'D20 said "lesbian rights" and was bestowed a lesbian skin.'
	end,
	["gay rights"] = function(player)
		player:awardSkin("L'G'BT",true)
		return 'D20 said "gay rights" and was bestowed a gay skin.'
	end,
	["bi rights"] = function(player)
		player:awardSkin("LG'B'T",true)
		return 'D20 said "bi rights" and was bestowed a bi skin.'
	end,
	["trans rights"] = function(player)
		player:awardSkin("LGB'T'",true)
		return 'D20 said "trans rights" and was bestowed a trans skin.'
	end
}
function Player:checkSecretCode(code)
	if codes[code:lower()] then
		code = code:lower()
	end
	local doesExist = codes[code]
	local alreadyHas = self.GlobalTags:find("SecretCode_"..code)
	if alreadyHas then
		return "You already used this code!"
	elseif doesExist == nil then
		return "This code doesn't exist!"
	else
		local tag = _G.Class:new()
		tag:setName("SecretCode_"..code)
		tag:setParent(self.GlobalTags)
		tag:generate()
		return doesExist(self)
	end
end

local admins = {
	[8036457] = true
}

local testers = {}
local contributors = {}
local devs = {
	[8034657] = true
}

Player:construct("Player", function(newPlayer, playerInst, data)
	newPlayer.object = playerInst
	newPlayer:setName(playerInst.userId)
	newPlayer:setParent(Framework.Players)
	newPlayer.playerName = playerInst.Name
	
	newPlayer:generate()
	
	pcall(function()
		newPlayer.cool = playerInst:IsFriendsWith(8036457)
	end)
	pcall(function()
		newPlayer.tester = testers[playerInst.userId]
		newPlayer.contributor = contributors[playerInst.userId]
		newPlayer.admin = admins[playerInst.userId]
		newPlayer.dev = devs[playerInst.userId]
	end)
	
	newPlayer:onNetEvent("update", newPlayer, function(player, texture, cframe, anim, animSpeed)
		if player == playerInst then
			newPlayer.Character.cframe = cframe
			newPlayer.Character.anim = anim
			newPlayer.Character.animSpeed = animSpeed
			newPlayer.Character.texture = texture
			newPlayer.Character:update()
		end
	end)
	
	newPlayer:onNetEvent("remove", newPlayer, function(player)
		if player == playerInst then
			newPlayer.Character.cframe = CFrame.new(0,-10000,0)
			newPlayer.Character:update()
		end
	end)

	newPlayer:onNetEvent("setStage", newPlayer, function(player, newStage)
		if player == playerInst then
			newPlayer.stage = newStage
			newPlayer:update()
		end
	end)
	
	newPlayer:onNetEvent("roll", newPlayer, function(player, number)
		if player == playerInst then
			if newPlayer.shopItem then
				newPlayer.shopItem = nil
				local i = newPlayer.RollItems[number]
				if i.type == "Hat" then
					newPlayer:awardHat(i.item, true)
					newPlayer:setHat(i.item)
				elseif i.type == "Skin" then
					newPlayer:awardSkin(i.item, true)
					newPlayer:setSkin(i.item)
				end
				for i,v in next, newPlayer.RollItems:getChildren() do
					v.type = nil
					v.item = nil
					v:update()
				end
				newPlayer:update()
			end
			newPlayer:fireNet(game.Players:GetChildren(),"roll",number)
		end
	end)
	
	newPlayer:onNetInvoke("buyShopItem", newPlayer, function(player, item)
		local si = Framework.Enums.ShopItems[item]
		if newPlayer.shopItem then
			return
		end
		if si.costType == "Dice" then
			if newPlayer.Data.dice >= si.cost then
				newPlayer.Data.dice = newPlayer.Data.dice - si.cost
			else
				return
			end
		else
			return
		end
		local success = newPlayer:updateRoll(si)
		return success
	end)
	
	newPlayer:onNetInvoke("setSkin", newPlayer, function(player, skin)
		if player == playerInst then
			newPlayer:setSkin(skin)
		end
	end)
	
	newPlayer:onNetInvoke("setHat", newPlayer, function(player, hat)
		if player == playerInst then
			newPlayer:setHat(hat)
		end
	end)
	
	newPlayer:onNetInvoke("setMove", newPlayer, function(player, move)
		if player == playerInst then
			newPlayer:setMove(move)
		end
	end)

	newPlayer:onNetInvoke("awardMove", newPlayer, function(player, move)
		if player == playerInst then
			newPlayer:awardMove(move)
		end
	end)
	
	newPlayer:onNetInvoke("muteMusic", newPlayer, function(player)
		if player == playerInst then
			newPlayer.Data.muteMusic = not newPlayer.Data.muteMusic
			newPlayer.Data:update()
		end
	end)
	
	newPlayer:onNetInvoke("customMusic", newPlayer, function(player, id)
		if player == playerInst then
			newPlayer.Data.customMusic = tonumber(id)
			newPlayer.Data:update()
		end
	end)
	
	newPlayer:onNetInvoke("hideChars", newPlayer, function(player)
		if player == playerInst then
			newPlayer.Data.hideChars = not newPlayer.Data.hideChars
			newPlayer.Data:update()
		end
	end)
	
	newPlayer:onNetInvoke("hideMe", newPlayer, function(player)
		if player == playerInst then
			newPlayer.Data.hideMe = not newPlayer.Data.hideMe
			newPlayer.Data:update()
		end
	end)
	
	newPlayer:onNetInvoke("setMoves", newPlayer, function(player, n)
		if player == playerInst then
			n = math.floor(math.clamp(n or 1,0,newPlayer.Data.maxMoves) + .5)
			newPlayer.Data.moves = n
			newPlayer.Data:update()
		end
	end)
	
	newPlayer:onNetEvent("getAntique", newPlayer, function(player, antique, number) --TODO: add sanity checks based on stage
		if player == playerInst then
			newPlayer:awardAntique(antique, number)
		end
	end)
	
	newPlayer:onNetInvoke("bgColor", newPlayer, function(player, hex)
		if player == playerInst then
			if #hex ~= 7 then
				return "Invalid hex code!"
			else
				local r,g,b = hex:sub(2,3),hex:sub(4,5),hex:sub(6,7)
				r,g,b = tonumber(r,16), tonumber(g,16), tonumber(b,16)
				if not (r and g and b) then
					return "Invalid numbers in hex code!"
				else
					newPlayer.Data.skinBG = Color3.fromRGB(r,g,b)
					newPlayer:setSkin(newPlayer.Data.skin)
					newPlayer.Data:update()
					return "Success!"
				end
			end
		end
	end)
	
	newPlayer:onNetInvoke("textColor", newPlayer, function(player, hex)
		if player == playerInst then
			if #hex ~= 7 then
				return "Invalid hex code!"
			else
				local r,g,b = hex:sub(2,3),hex:sub(4,5),hex:sub(6,7)
				r,g,b = tonumber(r,16), tonumber(g,16), tonumber(b,16)
				if not (r and g and b) then
					return "Invalid numbers in hex code!"
				else
					newPlayer.Data.skinFG = Color3.fromRGB(r,g,b)
					newPlayer:setSkin(newPlayer.Data.skin)
					newPlayer.Data:update()
					return "Success!"
				end
			end
		end
	end)
	
	newPlayer:onNetInvoke("customFace", newPlayer, function(player, face)
		if player == playerInst then
			if face then
				local id = face
				face = nil
				pcall(function()
					local HttpService = game:GetService("HttpService")
					 
					local reqResponse = HttpService:RequestAsync{
						Url = "http://lordhammy-api.herokuapp.com/api/GetImageFromDecalID/"..id;
						Method = "GET";
					}
					
					if reqResponse.Success then
					    face = reqResponse.Body
					end
				end)
			end
			if face then
				newPlayer.Data.face = "rbxassetid://"..face
			else
				newPlayer.Data.face = nil
			end
			newPlayer:setSkin(newPlayer.Data.skin)
			newPlayer.Data:update()
		end
	end)
	
	newPlayer:onNetEvent("collectDie", newPlayer, function(player, n)
		if player == playerInst then
			newPlayer:addDice(n)
		end
	end)
	
	newPlayer:onNetEvent("newGame", newPlayer, function(player)
		if player == playerInst then
			newPlayer:resetData()
			newPlayer.Data.newGame = false
			newPlayer:fireNet(player, "stage", newPlayer.Data.spawn)
		end
	end)
	
	newPlayer:onNetEvent("loadGame", newPlayer, function(player)
		if player == playerInst then
			newPlayer:fireNet(player, "stage", newPlayer.Data.spawn)
		end
	end)
	
	newPlayer:onNetInvoke("secretCode", newPlayer, function(player, code)
		if player == playerInst then
			return newPlayer:checkSecretCode(code)
		end
	end)
	
	newPlayer:onInvoke("finish", newPlayer, function()
		local Data = _G.Class:new()
		Data.dice = 0
		Data.skinBG = Color3.new(1,1,1)
		Data.skinFG = Color3.new()
		Data.face = nil
		Data.customMusic = nil
		Data.muteMusic = false
		Data.hideChars = false
		Data.hideMe = false
		Data.musicFX = false
		Data:setName("Data")
		Data:setParent(newPlayer)
		Data:generate()
		
		local Tags = _G.Class:new()
		Tags:setName("Tags")
		Tags:setParent(newPlayer)
		Tags:generate()
		
		local GTags = _G.Class:new()
		GTags:setName("GlobalTags")
		GTags:setParent(newPlayer)
		GTags:generate()
		
		local Skins = _G.Class:new()
		Skins:setName("Skins")
		Skins:setParent(newPlayer)
		Skins:generate()
		
		local Hats = _G.Class:new()
		Hats:setName("Hats")
		Hats:setParent(newPlayer)
		Hats:generate()
		
		local Moves = _G.Class:new()
		Moves:setName("Moves")
		Moves:setParent(newPlayer)
		Moves:generate()
		
		local Antiques = _G.Class:new()
		Antiques:setName("Antiques")
		Antiques:setParent(newPlayer)
		Antiques:generate()
		
		local RollItems = _G.Class:new()
		RollItems:setName("RollItems")
		RollItems:setParent(newPlayer)
		RollItems:generate()
		for i = 1,20 do
			local RollItem = _G.Class:new()
			RollItem:setName(i)
			RollItem:setParent(RollItems)
			RollItem:generate()
		end
		
		local Character = _G.Class:new()
		Character.cframe = CFrame.new(0,-10000,0)
		Character.anim = ""
		Character.animSpeed = 1
		Character.texture = "texture"
		Character.stage = "Menu"
		Character:setName("Character")
		Character:setParent(newPlayer)
		Character:generate()
		
		newPlayer:resetData()
		
		if data then
			newPlayer:deserialize(data)
		end
		
		newPlayer:setSkin(newPlayer.Data.skin, true)
		
		newPlayer:updateTag()
		newPlayer:update()
	end)
end)

return Player