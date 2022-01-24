local Framework = shared.Framework

local Wind = shared.Class:new()
Wind.object = nil
Wind.objects = {}
Wind.enabled = true

function Wind:update(dt)
	
end

function Wind:isObject(inst)
	return inst.Name == "Wind"
end

function Wind:Destroy()
	self.object:Destroy()
end

Wind:construct("Wind", function(newWind, object)
	newWind.object = object
	newWind.objects[object] = newWind
	object.Parent = workspace.Classes
end)

return Wind