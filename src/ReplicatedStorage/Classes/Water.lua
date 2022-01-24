local Framework = shared.Framework

local Water = shared.Class:new()
Water.object = nil
Water.objects = {}

function Water:isObject(inst)
	return inst.Name:sub(1,5) == "Water" and inst.Name:sub(1,10) ~= "WaterCover"
end

function Water:Destroy()
	self.object:Destroy()
end

Water:construct("Water", function(newWater, object)
	newWater.object = object
	newWater.objects[object] = newWater
	object.Parent = workspace.Classes
end)

return Water