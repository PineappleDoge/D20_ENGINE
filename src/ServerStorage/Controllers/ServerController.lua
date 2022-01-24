local Framework = _G.Framework
local DataStore2 = Framework.Util.Modules.DataStore2

local Controller = shared.Class:new()
Controller:setName(script.Name)
Controller:setParent(Framework)
Controller:generate()

local Suffix = "A1"

Controller.dataStore = "D20_DS"..Suffix
Controller.banStore = game:GetService("DataStoreService"):GetDataStore("D20GameBans") --like this to preserve legacy bans + ds2 isn't necessary

local Players = shared.Class:new()
Players:setName("Players")
Players:setParent(Framework)
Players:generate()

game.Players.PlayerAdded:connect(function(player)
	local Util = Framework.Util
	local dataStore = DataStore2(Controller.dataStore, player)
	local uData = dataStore:Get()
	local bData = Controller.banStore:GetAsync(player.userId)
	if uData and type(uData) == "string" then
		uData = game:GetService("HttpService"):JSONDecode(uData)
	end
	local newPlayer = _G.Class:create("Player", player, uData)
	newPlayer.dataStore = dataStore
	
	if bData and not newPlayer.admin then
		if bData.Until == 0 then
			player:Kick("You have been PERMBANNED by "..bData.BannedBy.." for: "..bData.Reason)
			return
		end
		if os.time() < bData.Until then
			local timeString = Util.String:getTime(math.ceil(bData.Until - os.time()))
			player:Kick("You have been TEMPBANNED by "..bData.BannedBy.." for "..timeString.." for: "..bData.Reason)
			return
		end
	end
	
	dataStore:BindToClose(function()
		if not newPlayer.destroyed then
			local uData = newPlayer:serialize()
			dataStore:Set(game:GetService("HttpService"):JSONEncode(uData))
		end
	end)
	
	newPlayer:updateTag()
end)
game.Players.PlayerRemoving:connect(function(player)
	if Players[player.userId] then
		local playerObj = Players[player.userId]
		local uData = playerObj:serialize()
		local dataStore = playerObj.dataStore
		playerObj:setParent(nil)
		playerObj:update()
		playerObj:destroy()
		dataStore:Set(game:GetService("HttpService"):JSONEncode(uData))
		dataStore:Save()
	end
end)

coroutine.wrap(function()
	while wait(5) do
		for i,v in next, Framework.Players:getChildren() do
			local uData = v:serialize()
			local dataStore = v.dataStore
			dataStore:Set(game:GetService("HttpService"):JSONEncode(uData))
			dataStore:Save()
			wait(1)
		end
	end
end)

function Controller:shutdown() --Takes at most 47.5 seconds to do w/ the executor
	for i,v in next, Framework.Players:getChildren() do
		v:fireNet(v.object, "shutdown")
	end
	local TweenService = game:GetService("TweenService")
	TweenService:Create(game.Lighting.ShutdownEffect, TweenInfo.new(30), {
		Saturation = -1
	}):Play()
	wait(37.5)
	game.Players.PlayerAdded:connect(function(v)
		v:Kick("The server has shut down. Please rejoin.")
	end)
	for i,v in next, game.Players:GetChildren() do
		v:Kick("The server has shut down. Please rejoin.")
	end
end

function Controller:kick(players, kicker)
	if type(players) ~= "table" then
		players = {players}
	end
	for i,v in next, players do
		local pObject = Framework.Players[v.userId]
		if pObject and not pObject.admin then
			v:Kick("You have been kicked by "..kicker.Name..".")
		end
	end
end

function Controller:ban(player, reason, banner)
	if game.Players:FindFirstChild(player) then
		local pObject = Framework.Players[game.Players[player].userId]
		if pObject and pObject.admin then
			return "Player is an admin!"
		end
		game.Players[player]:Kick("You have been banned by "..banner.Name.." for: "..reason)
	end
	local id
	pcall(function()
		id = game.Players:GetUserIdFromNameAsync(player)
	end)
	if id then
		self.banStore:SetAsync(id, {
			Until = 0,
			BannedBy = banner.Name,
			Reason = reason
		})
		return true
	end
end

function Controller:tempBan(player, reason, time, banner)
	print(player, reason, time, banner)
	if game.Players:FindFirstChild(player) then
		local pObject = Framework.Players[game.Players[player].userId]
		if pObject and pObject.admin then
			return "Player is an admin!"
		end
		game.Players[player]:Kick("You have been tempbanned by "..banner.Name.." for "..Framework.Util.String:getTime(time).." for: "..reason)
	end
	local id
	pcall(function()
		id = game.Players:GetUserIdFromNameAsync(player)
	end)
	if id then
		self.banStore:SetAsync(id, {
			Until = os.time() + time,
			BannedBy = banner.Name,
			Reason = reason
		})
		return true
	end
end

function Controller:unban(player, reason, banner)
	local id
	pcall(function()
		id = game.Players:GetUserIdFromNameAsync(player)
	end)
	if id then
		self.banStore:SetAsync(id, {
			Until = 1,
			BannedBy = banner.Name,
			Reason = reason
		})
		return true
	end
end

function Controller:getBan(player)
	local id
	pcall(function()
		id = game.Players:GetUserIdFromNameAsync(player)
	end)
	if id then
		return self.banStore:GetAsync(id)
	end
end

game:BindToClose(function()
	wait(5)
end)

return Controller