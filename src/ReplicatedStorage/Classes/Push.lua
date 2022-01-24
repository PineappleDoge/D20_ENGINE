local Framework = shared.Framework

local Push = shared.Class:new()
Push.object = nil
Push.objects = {}
Push.enabled = true

function Push:update(dt)
	
end

function Push:isObject(inst)
	return inst.Name == "Push"
end

function Push:Destroy()
	self.object:Destroy()
end

Push:construct("Push", function(newPush, object)
	newPush.object = object
	newPush.objects[object] = newPush
	object.Parent = workspace.Classes
end)

return Push