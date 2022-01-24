local Framework = shared.Framework

local Characters = {}

function Characters:getSkinString(skin, typ, player)
	if player then
		local cPrimary = player.Data.skinBG
		local cSecondary = player.Data.skinFG
		local cFace = player.face
		if not cFace then
			cFace = "No Face"
		end
		return skin..typ..cPrimary.r..cPrimary.g..cPrimary.b..cSecondary.r..cSecondary.g..cSecondary.b..tostring(cFace)
	else
		return skin..typ
	end
end

function Characters:setTransparency(character, val)
	for i,v in next, character:GetChildren() do
		if (v:IsA("BasePart") or v:IsA("UnionOperation")) and v.Name ~= "DieCollision" then
			v.Transparency = val
			if v.Name == "Head" then
				v.Decal.Transparency = val
			end
		end
	end
end

function Characters:updateSkin(character, skin, typ, player)
	skin = Framework.Enums.Skins[skin]
	if skin.oneEye then
		character.Head.Face.ImageLabel.ImageRectOffset = character.Head.Face.ImageLabel.ImageRectOffset + Vector2.new(0,512)
	end
end

function Characters:applySkin(character, skin, typ, player)
	skin = skin or "Black & White"
	typ = typ or "texture"
	if player == nil then
		player = Framework.localPlayer
	end
	if (skin == "L'G'BT" or skin == "Rainbow" or character.Skin.Value ~= Characters:getSkinString(skin, typ, player)) and Framework.Enums.Skins then
		character.Skin.Value = Characters:getSkinString(skin, typ, player)
		skin = Framework.Enums.Skins[skin]
		skin.texture = skin.texture or "rbxassetid://3152531577"
		skin.texture20 = skin.texture20 or "rbxassetid://3152531500"
		skin.textureColor = skin.textureColor or Color3.new(1,1,1)
		local primary = skin.primary
		local secondary = skin.secondary
		local face = skin.face
		local textureColor = skin.textureColor
		if skin.name == "Custom" then
			primary = player.Data.skinBG
			secondary = player.Data.skinFG
			face = player.Data.face
			textureColor = secondary
		end
		for i,v in next, character:GetChildren() do
			if (v:IsA("BasePart") or v:IsA("UnionOperation")) and v.Name ~= "Head" then
				v.Color = secondary
			end
		end
		character.Head.Color = primary
		character.Head.Face.ImageLabel.ImageColor3 = secondary
		character.Head.Face.Enabled = typ == "texture"
		character.Head.Decal.Texture = skin[typ]
		character.Head.Decal.Color3 = textureColor
		character.Head.Face.ImageLabel.ImageRectSize = Vector2.new(256,256)
		if face then
			character.Head.Face.ImageLabel.Image = face
			character.Head.Face.ImageLabel.ImageColor3 = Color3.new(1,1,1)
			character.Head.Face.ImageLabel.ImageRectOffset = Vector2.new()
			character.Head.Face.ImageLabel.ImageRectSize = Vector2.new()
		else
			character.Head.Face.ImageLabel.Image = "rbxassetid://3149794774"
		end
	end
	if type(skin) ~= "string" then
		skin = skin.name
	end
	self:updateSkin(character, skin, typ, player)
end

function Characters:applyHat(character, hat, texture)
	if character.Hat.Value ~= hat and Framework.Enums.Skins then
		character.Hat.Value = hat
		hat = Framework.Enums.Hats[hat]
		local hatModel = hat.object
		if character:FindFirstChild("HatModel") then
			character.HatModel:Destroy()
		end
		if hatModel then
			hatModel = hatModel:Clone()
			hatModel.Name = "HatModel"
			hatModel.Parent = character
			hatModel.Anchored = false
			local weld = Instance.new("Weld")
			weld.Parent = hatModel
			weld.Part0 = character.Head
			weld.Part1 = hatModel
			weld.C1 = hatModel.RotRelative.CFrame
			for i,v in next, hatModel:GetChildren() do
				if v:FindFirstChild("HatOffset") then
					v.Anchored = false
					local weld = Instance.new("Weld")
					weld.Parent = v
					weld.Part0 = hatModel
					weld.Part1 = v
					weld.C1 = v.HatOffset.CFrame
				end
			end
		end
	end
	self:updateHat(character, hat, texture)
end

function Characters:updateHat(character, hat, texture)
	if character:FindFirstChild("HatModel") then
		if character.HatModel:FindFirstChild("ReplaceHead") and (character.HatModel.ReplaceHead.Value or character == Framework.Character.character and Framework.Character.hideCharacter) then
			local t = (texture == "texture20" and 0 or 1)
			character.Head.LocalTransparencyModifier = t
			character.Head.Decal.LocalTransparencyModifier = t
			character.Head.Face.ImageLabel.ImageTransparency = t
			character.Cell.LocalTransparencyModifier = t
			character.HatModel.LocalTransparencyModifier = 1 - t
		else
			local t = (texture == "texture20" and 1 or 0)
			character.HatModel.LocalTransparencyModifier = t
			character.Head.LocalTransparencyModifier = 0
			character.Head.Decal.LocalTransparencyModifier = 0
			character.Head.Face.ImageLabel.ImageTransparency = 0
			character.Cell.LocalTransparencyModifier = 0
		end
	else
		character.Head.LocalTransparencyModifier = 0
		character.Head.Decal.LocalTransparencyModifier = 0
		character.Head.Face.ImageLabel.ImageTransparency = 0
		character.Cell.LocalTransparencyModifier = 0
	end
	if hat == "Freddy Freaker's Ears" then
		character.HatModel.Color = Framework.Enums.Skins[Framework.localPlayer.Data.skin].secondary
		character.HatModel.MeshPart.Color = character.HatModel.Color
	end
end

function Characters:setTag(char, name, tag, color)
	if tag then
		tag = "["..tag.."]"
	else
		tag = ""
	end
	color = color or Color3.new()
	char.Head.Nametag.Player.Text = name
	char.Head.Nametag.Tag.Text = tag
	char.Head.Nametag.Tag.TextColor3 = color
end

function Characters:rollNumber(char, number)
	local TweenService = game:GetService("TweenService")
	
	local rollGui = game.ReplicatedStorage.Assets.RollGui:Clone()
	rollGui.Parent = workspace.Classes
	rollGui.BillboardGui.TextLabel.Text = number
	rollGui.CFrame = char.Head.CFrame
	local newCF = char.Head.CFrame + Vector3.new(0,3,0)
	TweenService:Create(rollGui, TweenInfo.new(.5), {
		CFrame = newCF
	}):Play()
	TweenService:Create(rollGui.BillboardGui.TextLabel, TweenInfo.new(.25), {
		TextTransparency = 0
	}):Play()
	wait(.75)
	TweenService:Create(rollGui.BillboardGui.TextLabel, TweenInfo.new(.25), {
		TextTransparency = 1
	}):Play()
	wait(.25)
	rollGui:Destroy()
end

return Characters