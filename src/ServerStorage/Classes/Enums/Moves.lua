local Framework = _G.Framework

local newParentEnum = _G.Class:new()
newParentEnum:setName(script.Name)

local smObject = game.ReplicatedStorage.Assets.SpecialMove

function createEnum(name, desc)
	local newEnum = _G.Class:new()
	newEnum:setName(name)
	newEnum:setParent(newParentEnum)
	newEnum.object = game.ReplicatedStorage.Assets.Hats:FindFirstChild(name)
	newEnum.description = desc
	return newEnum
end

local Moves = {
	{"Spin", "Spin, boosting yourself with decreased gravity."},
	{"Bounce", "Bounce to the ground, and retain your height!"},
	{"Bee", "Soar above with the wings of a bee."},
	{"Dash", "Dash ahead with lots of speed!"},
	{"Glide", "Glide around! A horizontal-based special move."},
	{"Platform", "Makes a platform under you."},
	{"Spin Jump", "Basically, a triple jump."},
	{"Dive", "Dive in the air! A simple special move."},
	{"Grapple", "Create a hook in mid-air to swing around."},
	{"None", "No move is equipped."},
}

table.sort(Moves, function(a,b)
	return a[1] <= b[1]
end)

local Colors = {
	Bee = Color3.new(1,1,0),
	None = Color3.new(.75,.75,.75)
}

local colorMoveCount = 0
for i,v in next, Moves do
	if not Colors[i] then
		colorMoveCount = colorMoveCount + 1
	end
end

local colorMove = 0
for _,v in next, Moves do
	local i,v = v[1], v[2]
	local newEnum = createEnum(i, v)
	if Colors[i] then
		newEnum.color = Colors[i]
	else
		newEnum.color = Color3.fromHSV(colorMove/colorMoveCount,1,1)
		colorMove = colorMove + 1
	end
	newEnum.object = smObject:Clone()
	newEnum.object.Name = newEnum.name..newEnum.object.Name
	newEnum.object.Parent = game.ReplicatedStorage.Assets
	newEnum.object.M.Color = newEnum.color:lerp(Color3.new(1,1,1), .25)
	newEnum.object.O.Color = newEnum.color
	newEnum.object.O.Attachment.ParticleEmitter.Color = ColorSequence.new(newEnum.color)
end

local Exclusive = {"Bee"}
for i,v in next, Exclusive do
	newParentEnum[v].exclusive = true
end

return newParentEnum