local Framework = shared.Framework

local Assets = {
	"rbxassetid://3152531577",
	"rbxassetid://3152531500"
}
local Indexes = {}

function addAsset(asset)
	if not Indexes[asset] then
		Indexes[asset] = true
		Assets[#Assets+1] = asset
	end
end

function recurse(v)
	if v.ClassName:find("Image") then
		addAsset(v.Image)
	end
	for i,v in next, v:GetChildren() do
		recurse(v)
	end
end

return Assets