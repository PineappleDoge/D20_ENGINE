local Framework = _G.Framework

local newParentEnum = _G.Class:new()
newParentEnum:setName(script.Name)

local Colors = {
	Red = 		Color3.fromRGB(255,50,50),
	Orange = 	Color3.fromRGB(255,100,50),
	Yellow = 	Color3.fromRGB(255,255,100),
	Green = 	Color3.fromRGB(50,255,100),
	Blue = 		Color3.fromRGB(50,100,255),
	Purple = 	Color3.fromRGB(200,100,255),
	White = 	Color3.fromRGB(255,255,255),
	Black = 	Color3.fromRGB(0,0,0),
	Pink = 		Color3.fromRGB(255,50,200),
}

function getColorSkin(primary, secondary)
	local newEnum = _G.Class:new()
	newEnum.primary = primary
	newEnum.secondary = secondary
	newEnum.textureColor = secondary
	return newEnum
end

local Names = {
	["White & White"] = "Neon",
	["Red & Red"] = "Neon Red",
	["Orange & Orange"] = "Neon Orange",
	["Yellow & Yellow"] = "Neon Yellow",
	["Green & Green"] = "Neon Green",
	["Blue & Blue"] = "Neon Blue",
	["Purple & Purple"] = "Neon Purple",
	["Pink & Pink"] = "Neon Pink",
	["Black & Black"] = "Silhouette",
}

local Descs = {
	["Black & White"] = "D20's favorite skin."
}

for name1,color1 in next,Colors do
	for name2,color2 in next,Colors do
		local newEnum = getColorSkin(color1, color2)
		newEnum:setName(name2.." & "..name1)
		newEnum.description = "A"..(name2:sub(1,1) == "O" and "n" or "").." "..name2:lower().." and "..name1:lower().." skin."
		if Descs[newEnum.name] then
			newEnum.description = Descs[newEnum.name]
		end
		if Names[newEnum.name] then
			newEnum:setName(Names[newEnum.name])
			newEnum.description = "A "..newEnum.name:lower().." skin."
		end
		newEnum:setParent(newParentEnum)
	end
end

local newEnum = _G.Class:new()
newEnum:setName("Gygax")
newEnum.description = "A skin with the colors of the Egg of Gygax."
newEnum.texture = "rbxassetid://1675099886"
newEnum.texture20 = "rbxassetid://1675099361"
newEnum.primary = Color3.new(0,.2,0)
newEnum.secondary = Color3.new(.7,.7,.7)
newEnum:setParent(newParentEnum)

local newEnum = _G.Class:new()
newEnum:setName("Roman")
newEnum.description = "A skin with Roman Numeral numbers."
newEnum.texture = "rbxassetid://1812361771"
newEnum.texture20 = "rbxassetid://1812359950"
newEnum.primary = Color3.new(1,1,.9)
newEnum.secondary = Color3.fromRGB(27,42,53)
newEnum:setParent(newParentEnum)

local newEnum = _G.Class:new()
newEnum:setName("Boom")
newEnum.description = "Boom from the Boom & Fricko! game that premiered at RDC 2018."
newEnum.texture = "rbxassetid://2090631685"
newEnum.texture20 = "rbxassetid://2090627908"
newEnum.primary = Color3.new(.5,0,1)
newEnum.secondary = Color3.new()
newEnum:setParent(newParentEnum)

local newEnum = _G.Class:new()
newEnum:setName("Fricko")
newEnum.description = "Fricko from the Boom & Fricko! game that premiered at RDC 2018."
newEnum.texture = "rbxassetid://2090768517"
newEnum.texture20 = "rbxassetid://2090767892"
newEnum.primary = Color3.fromRGB(180,255,0)
newEnum.secondary = Color3.new()
newEnum.oneEye = true
newEnum:setParent(newParentEnum)

local newEnum = _G.Class:new()
newEnum:setName("Cool")
newEnum.description = "A skin with cold colors."
newEnum.texture = "rbxassetid://2124087088"
newEnum.texture20 = "rbxassetid://2124086743"
newEnum.primary = Color3.fromRGB(28,146,111)
newEnum.secondary = Color3.new(1,1,1)
newEnum:setParent(newParentEnum)

local newEnum = _G.Class:new()
newEnum:setName("Warm")
newEnum.description = "A skin with warm colors."
newEnum.texture = "rbxassetid://2124086414"
newEnum.texture20 = "rbxassetid://2124085995"
newEnum.primary = Color3.fromRGB(255,179,0)
newEnum.secondary = Color3.new(1,1,1)
newEnum:setParent(newParentEnum)

local newEnum = _G.Class:new()
newEnum:setName("Aesthetic")
newEnum.description = "A skin with aesthetic colors."
newEnum.texture = "rbxassetid://2124549342"
newEnum.texture20 = "rbxassetid://2124549935"
newEnum.primary = Color3.fromRGB(200,70,128)
newEnum.secondary = Color3.new(1,1,1)
newEnum:setParent(newParentEnum)

local newEnum = getColorSkin(Color3.fromRGB(254,217,14),Color3.fromRGB(205,178,111))
newEnum:setName("Homer")
newEnum.description = "D'oh!"
newEnum.face = "rbxassetid://1899952391"
newEnum:setParent(newParentEnum)

local newEnum = getColorSkin(Color3.fromRGB(245,205,48), Color3.fromRGB(13,105,172))
newEnum:setName("Noob")
newEnum.description = "oof"
newEnum.face = "rbxassetid://34067417"
newEnum:setParent(newParentEnum)

local newEnum = getColorSkin(Color3.fromRGB(164,0,97), Color3.fromRGB(138,30,4))
newEnum:setName("'L'GBT")
newEnum.description = 'D20 says "lesbian rights".'
newEnum:setParent(newParentEnum)

local newEnum = getColorSkin(Color3.new(1,1,1), Color3.new(1,1,1))
newEnum:setName("L'G'BT")
newEnum.description = 'D20 says "gay rights".'
newEnum:setParent(newParentEnum)

local newEnum = getColorSkin(Color3.fromRGB(0,56,168), Color3.fromRGB(212,0,110))
newEnum:setName("LG'B'T")
newEnum.description = 'D20 says "bi rights".'
newEnum:setParent(newParentEnum)

local newEnum = getColorSkin(Color3.fromRGB(245,169,184), Color3.fromRGB(91,206,250))
newEnum:setName("LGB'T'")
newEnum.description = 'D20 says "trans rights".'
newEnum:setParent(newParentEnum)

local newEnum = getColorSkin(Color3.new(1,1,1), Color3.new(1,1,1))
newEnum:setName("Rainbow")
newEnum.description = 'Flashing rainbow text!'
newEnum:setParent(newParentEnum)

local newEnum = getColorSkin(Color3.new(.8,.8,.8), Color3.new(.2,.2,.2))
newEnum:setName("Custom")
newEnum.description = "A custom skin with custom colors! Change your skin color and face in Settings > Game."
newEnum:setParent(newParentEnum)

local Exclusive = {"Homer", "Custom", "'L'GBT", "L'G'BT", "LG'B'T", "LGB'T'"}
for i,v in next, Exclusive do
	newParentEnum[v].exclusive = true
end

return newParentEnum