--	// FileName: DefaultChatMessage.lua
--	// Written by: TheGamer101
--	// Description: Create a message label for a standard chat message.

local clientChatModules = script.Parent.Parent
local ChatSettings = require(clientChatModules:WaitForChild("ChatSettings"))
local ChatConstants = require(clientChatModules:WaitForChild("ChatConstants"))
local util = require(script.Parent:WaitForChild("Util"))

function CreateMessageLabel(messageData, channelName)

	local fromSpeaker = messageData.FromSpeaker
	local message = messageData.Message

	local extraData = messageData.ExtraData or {}
	local useFont = extraData.Font or ChatSettings.DefaultFont
	local useTextSize = extraData.TextSize or ChatSettings.ChatWindowTextSize
	local useNameColor = extraData.NameColor or ChatSettings.DefaultNameColor
	local useChatColor = extraData.ChatColor or ChatSettings.DefaultMessageColor
	local useChannelColor = extraData.ChannelColor or useChatColor
	local tags = extraData.Tags or {}
	
	local NAME_COLORS =
	{
		Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
		Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
		Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
		BrickColor.new("Bright violet").Color,
		BrickColor.new("Bright orange").Color,
		BrickColor.new("Bright yellow").Color,
		BrickColor.new("Light reddish violet").Color,
		BrickColor.new("Brick yellow").Color,
	}

	local function GetNameValue(pName)
		local value = 0
		for index = 1, #pName do
			local cValue = string.byte(string.sub(pName, index, index))
			local reverseIndex = #pName - index + 1
			if #pName%2 == 1 then
				reverseIndex = reverseIndex - 1
			end
			if reverseIndex%4 >= 2 then
				cValue = -cValue
			end
			value = value + cValue
		end
		return value
	end

	local color_offset = 0
	local function ComputeNameColor(pName)
		return NAME_COLORS[((GetNameValue(pName) + color_offset) % #NAME_COLORS) + 1]
	end
	
	local Framework = shared.Framework
	if game.Players:FindFirstChild(fromSpeaker) and Framework.Players and Framework.Players[game.Players[fromSpeaker].userId] then
		local Player = Framework.Players[game.Players[fromSpeaker].userId]
		if Player then
			fromSpeaker = Player.playerName
			if Player.chatNameColor and Player.chatNameColor ~= Color3.new(2,2,2) then
				useNameColor = Player.chatNameColor
			else
				useNameColor = ComputeNameColor(fromSpeaker)
			end
			if Player.chatColor and Player.chatColor ~= Color3.new(2,2,2) then
				useChatColor = Player.chatColor
			end
		end
	end
	
	local formatUseName = string.format("[%s]:", fromSpeaker)
	local speakerNameSize = util:GetStringTextBounds(formatUseName, useFont, useTextSize)
	local numNeededSpaces = util:GetNumberOfSpaces(formatUseName, useFont, useTextSize) + 1

	local BaseFrame, BaseMessage = util:CreateBaseMessage("", useFont, useTextSize, useChatColor)
	local NameButton = util:AddNameButtonToBaseMessage(BaseMessage, useNameColor, formatUseName, fromSpeaker)
	
	local ChannelButton = nil

	local guiObjectSpacing = UDim2.new(0, 0, 0, 0)

	if channelName ~= messageData.OriginalChannel then
			local formatChannelName = string.format("{%s}", messageData.OriginalChannel)
			ChannelButton = util:AddChannelButtonToBaseMessage(BaseMessage, useChannelColor, formatChannelName, messageData.OriginalChannel)
			guiObjectSpacing = UDim2.new(0, ChannelButton.Size.X.Offset + util:GetStringTextBounds(" ", useFont, useTextSize).X, 0, 0)
			numNeededSpaces = numNeededSpaces + util:GetNumberOfSpaces(formatChannelName, useFont, useTextSize) + 1
	end

	local tagLabels = {}
	for i, tag in pairs(tags) do
		local tagColor = tag.TagColor or Color3.fromRGB(255, 0, 255)
		local tagText = tag.TagText or "???"
		local formatTagText = string.format("[%s] ", tagText)
		local label = util:AddTagLabelToBaseMessage(BaseMessage, tagColor, formatTagText)
		label.Position = guiObjectSpacing

		numNeededSpaces = numNeededSpaces + util:GetNumberOfSpaces(formatTagText, useFont, useTextSize)
		guiObjectSpacing = guiObjectSpacing + UDim2.new(0, label.Size.X.Offset, 0, 0)

		table.insert(tagLabels, label)
	end

	NameButton.Position = guiObjectSpacing

	local function UpdateTextFunction(messageObject)
		if messageData.IsFiltered then
			BaseMessage.Text = string.rep(" ", numNeededSpaces) .. messageObject.Message
		else
			BaseMessage.Text = string.rep(" ", numNeededSpaces) .. string.rep("_", messageObject.MessageLength)
		end
	end

	UpdateTextFunction(messageData)

	local function GetHeightFunction(xSize)
		return util:GetMessageHeight(BaseMessage, BaseFrame, xSize)
	end

	local FadeParmaters = {}
	FadeParmaters[NameButton] = {
		TextTransparency = {FadedIn = 0, FadedOut = 1},
		TextStrokeTransparency = {FadedIn = 0.75, FadedOut = 1}
	}

	FadeParmaters[BaseMessage] = {
		TextTransparency = {FadedIn = 0, FadedOut = 1},
		TextStrokeTransparency = {FadedIn = 0.75, FadedOut = 1}
	}

	for i, tagLabel in pairs(tagLabels) do
		local index = string.format("Tag%d", i)
		FadeParmaters[tagLabel] = {
			TextTransparency = {FadedIn = 0, FadedOut = 1},
			TextStrokeTransparency = {FadedIn = 0.75, FadedOut = 1}
		}
	end

	if ChannelButton then
		FadeParmaters[ChannelButton] = {
			TextTransparency = {FadedIn = 0, FadedOut = 1},
			TextStrokeTransparency = {FadedIn = 0.75, FadedOut = 1}
		}
	end

	local FadeInFunction, FadeOutFunction, UpdateAnimFunction = util:CreateFadeFunctions(FadeParmaters)

	return {
		[util.KEY_BASE_FRAME] = BaseFrame,
		[util.KEY_BASE_MESSAGE] = BaseMessage,
		[util.KEY_UPDATE_TEXT_FUNC] = UpdateTextFunction,
		[util.KEY_GET_HEIGHT] = GetHeightFunction,
		[util.KEY_FADE_IN] = FadeInFunction,
		[util.KEY_FADE_OUT] = FadeOutFunction,
		[util.KEY_UPDATE_ANIMATION] = UpdateAnimFunction
	}
end

return {
	[util.KEY_MESSAGE_TYPE] = ChatConstants.MessageTypeDefault,
	[util.KEY_CREATOR_FUNCTION] = CreateMessageLabel
}
