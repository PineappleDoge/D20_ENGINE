local Framework = shared.Framework

local WaterCover = shared.Class:new()
WaterCover.object = nil
WaterCover.objects = {}

function WaterCover:isObject(inst)
	return inst.Name:sub(1,10) == "WaterCover"
end

function WaterCover:Destroy()
	self.object:Destroy()
end

WaterCover:construct("WaterCover", function(newWaterCover, object)
	newWaterCover.object = object
	newWaterCover.objects[object] = newWaterCover
	object.Parent = workspace.Classes
	local cf = {object.CFrame:components()}
	cf[8] = -cf[8]
	object.CFrame = CFrame.new(unpack(cf))
end)

return WaterCover